// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'blocs/authentication/authentication_bloc.dart';
// import 'services/auth_service.dart';
// import 'services/websocket_service.dart';
// import 'ui/home_screen.dart';
// import 'ui/login_screen.dart';
//
// void main() async {
//   await Hive.initFlutter();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider(create: (_) => AuthService()),
//         Provider(create: (_) => WebSocketService()),
//         BlocProvider(create: (context) => AuthenticationBloc(context.read<AuthService>())),
//       ],
//       child: MaterialApp(
//         title: 'Flutter Chat App',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         builder: (context, child) => ResponsiveBreakpoints.builder(
//           child: child!,
//           breakpoints: [
//             const Breakpoint(start: 0, end: 450, name: MOBILE),
//             const Breakpoint(start: 451, end: 800, name: TABLET),
//             const Breakpoint(start: 801, end: 1920, name: DESKTOP),
//             const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
//           ],
//         ),
//         initialRoute: '/login',
//         routes: {
//           '/login': (context) => LoginScreen(),
//           '/home': (context) => HomeScreen(),
//         },
//       ),
//     );
//   }
// }

import 'package:chat_application/ui/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'models/chat_message.dart';
import 'models/user.dart';
import 'services/auth_service.dart';
import 'services/websocket_service.dart';
import 'ui/main_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  await Hive.openBox<User>('users');
  await Hive.openBox<ChatMessage>('chatMessages');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyBJlmNXHQmwt5DOhrpIQNCxNSSVOoBB8hk", appId: "1:47094194463:web:7c7b815f15314a3604d02a", messagingSenderId: "47094194463", projectId: "chat-application-a9144"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService(Hive.box<User>('users'))),
        Provider(create: (_) => WebSocketService(Hive.box<ChatMessage>('chatMessages'))),
      ],
      child: MaterialApp(
        title: 'Flutter Chat App',
        theme: ThemeData(primarySwatch: Colors.blue),
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/main': (context) => MainScreen(),
        },
      ),
    );
  }
}
