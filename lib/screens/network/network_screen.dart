import 'package:connecto/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:connecto/screens/chat/chat_screen.dart';
import 'package:connecto/services/auth_service.dart';
import 'package:connecto/utils/constants.dart';
import 'package:connecto/models/user_model.dart';
import 'package:connecto/models/connection_model.dart';
import 'package:connecto/services/connection_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class ConnectionScreen extends StatefulWidget {
  late String currentUserId = '';

  ConnectionScreen({super.key});

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ConnectionService _connectionService = ConnectionService();
  final AuthService _authService = AuthService();
  final Set<String> _requestedUsers = Set<String>();

  @override
  void initState() {
    super.initState();
    widget.currentUserId = _authService.getCurrentUser()?.uid ?? '';
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/logo.svg'),
          onPressed: () {},
        ),
        title: const Text(
          'Find Your Great Job',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Friends'),
            Tab(text: 'Pending'),
            Tab(text: 'Suggestions'),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _showUserProfileActions(context);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  _authService.getCurrentUser()?.photoURL ??
                      'https://via.placeholder.com/150'),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(),
          _buildPendingTab(),
          _buildSuggestionsTab(),
        ],
      ),
    );
  }

  Widget _buildPendingTab() {
    return widget.currentUserId == ''
        ? Container()
        : FutureBuilder<List<Connection>>(
            future: _connectionService.getPendingRequests(widget.currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No pending requests.',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final connection = snapshot.data![index];
                    return FutureBuilder<UserModel?>(
                      future: _connectionService.getUser(connection.userId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text('Loading...'),
                          );
                        } else if (userSnapshot.hasError) {
                          return const ListTile(
                            title: Text('Error loading user'),
                          );
                        } else if (!userSnapshot.hasData) {
                          return const ListTile(
                            title: Text('User not found'),
                          );
                        } else {
                          final user = userSnapshot.data!;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  user.profilePicture ??
                                      'https://via.placeholder.com/150'),
                            ),
                            title: Text(user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black)),
                            subtitle: Text(connection.status,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54)),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check,
                                        color: Constants.accentColor),
                                    onPressed: () async {
                                      await _connectionService
                                          .acceptConnectionRequest(
                                              connection.connectionId)

                                          .then((value) => {
                                                if (mounted)
                                                  {
                                                    showSnackbar(context,
                                                        'Connection request accepted'),
                                                    setState(() {})
                                                  }
                              
                                              })
                                          .catchError(
                                            (error) {
                                              showSnackbar(context, 'Error: $error');
                                              return Future.value(<Set<void>>{});
                                            },
                                          );
                                      
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () async {
                                      await _connectionService
                                          .declineConnectionRequest(
                                              connection.connectionId)
                                          .then((value) => {
                                                if (mounted)
                                                  {
                                                    showSnackbar(context,
                                                        'Connection request declined'),
                                                    setState(() {})
                                                  }
                              
                                              })
                                          .catchError(
                                            (error) {
                                              showSnackbar(context, 'Error: $error');
                                              return Future.value(<Set<void>>{});
                                            },
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          );
  }

  Widget _buildFriendsTab() {
    return FutureBuilder<List<Connection>>(
      future: _connectionService.getAcceptedConnections(widget.currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No friends yet.',
              style: TextStyle(color: Colors.black),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final connection = snapshot.data![index];
              return widget.currentUserId == connection.connectedUserId
                  ? FutureBuilder<UserModel>(
                      future: _connectionService.getUser(connection.userId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text(
                              'Loading...',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        } else if (userSnapshot.hasError) {
                          return const ListTile(
                            title: Text(
                              'Error: ',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        } else if (!userSnapshot.hasData) {
                          return const ListTile(
                            title: Text(
                              'User not found.',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        } else {
                          return _buildUserCard(
                            userSnapshot.data!,
                            'Friends',
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      userId: widget.currentUserId,
                                      receiverId: connection.userId,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.message_outlined,
                                  color: Constants.accentColor),
                            ),
                          );
                        }
                      },
                    )
                  : FutureBuilder<UserModel>(
                      future: _connectionService
                          .getUser(connection.connectedUserId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text(
                              'Loading...',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        } else if (userSnapshot.hasError) {
                          return const ListTile(
                            title: Text(
                              'Error: ',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        } else if (!userSnapshot.hasData) {
                          return const ListTile(
                            title: Text(
                              'User not found.',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        } else {
                          return _buildUserCard(
                            userSnapshot.data!,
                            'Friends',
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      userId: widget.currentUserId,
                                      receiverId: connection.connectedUserId,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.message_outlined,
                                  color: Constants.accentColor),
                            ),
                          );
                        }
                      },
                    );
            },
          );
        }
      },
    );
  }

  Widget _buildSuggestionsTab() {
    return FutureBuilder<List<UserModel>>(
      future: _connectionService.getSuggestions(widget.currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.black),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No suggestions available.',
              style: TextStyle(color: Colors.black),
            ),
          );
        } else {
          final suggestedUsers = snapshot.data!;
          return ListView.builder(
            itemCount: suggestedUsers.length,
            itemBuilder: (context, index) {
              final user = suggestedUsers[index];
              return _buildUserCard(
                user,
                'Suggestions',
                IconButton(
                  onPressed: _requestedUsers.contains(user.id)
                      ? null
                      : () {
                          _sendConnectionRequest(user.id);
                        },
                  icon: Icon(
                    _requestedUsers.contains(user.id)
                        ? Icons.check
                        : Icons.person_add,
                    color: Constants.accentColor,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildUserCard(UserModel user, String status, Widget actionButton) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              user.profilePicture ?? 'https://via.placeholder.com/150'),
        ),
        title: Text(user.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black)),
        subtitle: Text(status,
            style: const TextStyle(fontSize: 14, color: Colors.black54)),
        trailing: SizedBox(
          width: 50,
          child: actionButton,
        ),
      ),
    );
  }

  void _sendConnectionRequest(String userId) async {
    await _connectionService
        .sendConnectionRequest(widget.currentUserId, userId)
        .then(
          (value) => showSnackbar(context, 'Connection request sent.'),
        )
        .catchError(
          (error) => showSnackbar(context, 'Error: $error'),
        );
    setState(() {
      _requestedUsers.add(userId);
    });
  }

  void _showUserProfileActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.account_circle,
                    color: Color.fromARGB(255, 128, 226, 177), size: 24),
                title: const Text(
                  'View Profile',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout,
                    color: Color.fromARGB(255, 128, 226, 177), size: 24),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                onTap: () {
                  _authService.signOut(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialogMessage(
      String status, String message, String title, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color:
                  status == 'success' ? Constants.accentColor : Colors.red[300],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
