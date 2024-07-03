// import 'package:flutter/material.dart';
// import 'package:connecto/models/user_model.dart';
// import 'package:connecto/services/connection_service.dart';

// class UserCard extends StatelessWidget {
//   final UserModel user;
//   final String currentUserId;

//   UserCard({required this.user, required this.currentUserId});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage(user.profilePicture ?? ''),
//         ),
//         title: Text(user.name),
//         subtitle: Text(user.email),
//         trailing: ConnectionActionButtons(user: user, currentUserId: currentUserId),
//       ),
//     );
//   }
// }

// class ConnectionActionButtons extends StatefulWidget {
//   final UserModel user;
//   final String currentUserId;

//   ConnectionActionButtons({required this.user, required this.currentUserId});

//   @override
//   _ConnectionActionButtonsState createState() => _ConnectionActionButtonsState();
// }

// class _ConnectionActionButtonsState extends State<ConnectionActionButtons> {
//   late String connectionStatus;

//   @override
//   void initState() {
//     super.initState();
//     getConnectionStatus();
//   }

//   void getConnectionStatus() async {
//     try {
//       String status = await ConnectionService().getConnectionStatus(widget.currentUserId, widget.user.userId);
//       setState(() {
//         connectionStatus = status;
//       });
//     } catch (e) {
//       print('Error fetching connection status: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (connectionStatus == 'accepted') {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: Icon(Icons.message),
//             onPressed: () {
//               // Handle message action
//             },
//           ),
//         ],
//       );
//     } else if (connectionStatus == 'pending') {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: Icon(Icons.check),
//             onPressed: () {
//               // Handle accept action
//               ConnectionService().updateConnection(widget.user.userId, widget.currentUserId, 'accepted');
//               setState(() {
//                 connectionStatus = 'accepted';
//               });
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.clear),
//             onPressed: () {
//               // Handle decline action
//               ConnectionService().updateConnection(widget.user.userId, widget.currentUserId, 'declined');
//               setState(() {
//                 connectionStatus = 'declined';
//               });
//             },
//           ),
//         ],
//       );
//     } else {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: Icon(Icons.person_add),
//             onPressed: () {
//               // Handle connect action
//               ConnectionService().createConnection(widget.currentUserId, widget.user.userId, 'pending');
//               setState(() {
//                 connectionStatus = 'pending';
//               });
//             },
//           ),
//         ],
//       );
//     }
//   }
// }
