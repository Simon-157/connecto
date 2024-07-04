import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/connection_model.dart';
import 'package:connecto/models/user_model.dart';

class ConnectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _connections => _firestore.collection('connections');
  CollectionReference get _users => _firestore.collection('users');

// Create Connection
  Future<void> _createConnection(String userId, String connectedUserId) async {
    DocumentReference docRef = _connections.doc();
    String connectionId = docRef.id;

    try {
      await docRef.set({
        'connection_d': connectionId,
        'user_id': userId,
        'connected_user_id': connectedUserId,
        'status': 'pending',
      });

      print('Connection created successfully');
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to create connection');
    }
  }

  // Send a connection request
  Future<void> sendConnectionRequest(
      String userId, String connectedUserId) async {
    final existingConnection = await _getConnection(userId, connectedUserId);
    final reverseConnection = await _getConnection(connectedUserId, userId);
    print(reverseConnection);
    if (existingConnection != null || reverseConnection != null) {
      throw Exception("Connection request already exists in some state.");
    }

    // Create connection
    if (existingConnection == null && reverseConnection == null) {
      await _createConnection(userId, connectedUserId);
    }
  }

  // Accept a connection request
  Future<void> acceptConnectionRequest(String connectionId) async {
    await _connections.doc(connectionId).update({'status': 'accepted'});
  }

  // Decline a connection request
  Future<void> declineConnectionRequest(String connectionId) async {
    await _connections.doc(connectionId).update({'status': 'declined'});
  }

  // Check if a connection request exists in any state
  Future<Connection?> _getConnection(
      String userId, String connectedUserId) async {
    final snapshot = await _connections
        .where('user_id', isEqualTo: userId)
        .where('connected_user_id', isEqualTo: connectedUserId)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return Connection.fromSnapshot(snapshot.docs.first);
  }

  // Fetch pending connection requests for a user
  Future<List<Connection>> getPendingRequests(String userId) async {
    final snapshot = await _connections
        .where('connected_user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.map((doc) => Connection.fromSnapshot(doc)).toList();
  }

  // Fetch accepted connections for a user
  Future<List<Connection>> getAcceptedConnections(String userId) async {
    final snapshot = await _connections
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .get();

    final reverseSnapshot = await _connections
        .where('connected_user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .get();

    final connections =
        snapshot.docs.map((doc) => Connection.fromSnapshot(doc)).toList();
    final reverseConnections = reverseSnapshot.docs
        .map((doc) => Connection.fromSnapshot(doc))
        .toList();

    // remove duplicate connectionIds
    final connectionSet = <String>{};
    final uniqueConnections = <Connection>[];

    for (var connection in [...connections, ...reverseConnections]) {
      if (connectionSet.add(connection.connectionId)) {
        uniqueConnections.add(connection);
      }
    }

    return uniqueConnections;
  }

 
   Future<List<UserModel>> getSuggestions(String userId) async {
    //  all users
    final allUsersSnapshot = await _users.get();
    final allUsers = allUsersSnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();

    //  all connections for the user
    final userConnectionsSnapshot = await _connections
        .where('user_id', isEqualTo: userId)
        .get();
    final connectedUserIds = userConnectionsSnapshot.docs.map((doc) => doc['connected_user_id'] as String).toSet();

    //  all reverse connections for the user
    final reverseConnectionsSnapshot = await _connections
        .where('connected_user_id', isEqualTo: userId)
        .get();
    final reverseConnectedUserIds = reverseConnectionsSnapshot.docs.map((doc) => doc['user_id'] as String).toSet();

    // Combine sets of connected user ids
    final allConnectedUserIds = connectedUserIds.union(reverseConnectedUserIds);

    // Filter out connected users and the user themselves from the list of all users
    final suggestedUsers = allUsers.where((user) => !allConnectedUserIds.contains(user.userId) && user.userId != userId).toList();

    return suggestedUsers;
  }

  Future<UserModel> getUser(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).get();
    return UserModel.fromSnapshot(snapshot);
  }
}
