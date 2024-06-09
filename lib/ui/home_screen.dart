import 'package:chat_application/blocs/authentication/authentication_bloc.dart';
// import 'package:chat_application/blocs/authentication/authentication_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import '../services/websocket_service.dart';
// import 'chat_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat App'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               context.read<AuthenticationBloc>().add(AuthenticationLoggedOut());
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//         ],
//       ),
//       body: ChatScreen(),
//     );
//   }
// }
