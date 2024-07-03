import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/connection_model.dart';
import 'package:connecto/models/user_model.dart';

class ConnectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create Connection
  Future<void> createConnection(String userId, String connectedUserId, String status) async {
    try {
      DocumentReference docRef = _firestore.collection('connections').doc();
      String connectionId = docRef.id;

      await docRef.set({
        'connection_id': connectionId,
        'user_id': userId,
        'connected_user_id': connectedUserId,
        'status': status,
      });
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to create connection');
    }
  }

  // Read Connection
  Future<Connection?> getConnection(String connectionId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('connections').doc(connectionId).get();
      if (doc.exists) {
        return Connection.fromJson(doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to get connection');
    }
  }

  // Update Connection
  Future<void> updateConnection(String connectionId, String status) async {
    try {
      await _firestore.collection('connections').doc(connectionId).update({
        'status': status,
      });
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to update connection');
    }
  }

  // Delete Connection
  Future<void> deleteConnection(String connectionId) async {
    try {
      await _firestore.collection('connections').doc(connectionId).delete();
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to delete connection');
    }
  }

  // Get Connected Users with User Info for a Given User
  Future<List<ConnectionWithUser>> getConnectedUsersWithInfo(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('connections')
          .where('user_id', isEqualTo: userId)
          .get();
      List<ConnectionWithUser> connectedUsersWithInfo = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Connection connection = Connection.fromJson(doc.data()! as Map<String, dynamic>);
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(connection.connectedUserId).get();
        UserModel user = UserModel.fromDocument(userDoc);
        connectedUsersWithInfo.add(ConnectionWithUser(connection: connection, user: user));
      }
      return connectedUsersWithInfo;
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to get connected users with info');
    }
  }
}
