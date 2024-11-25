import 'package:flutter/material.dart';
import 'package:kirby_port_app/route.dart';
import 'package:kirby_port_app/utils/notification_permission.dart';
import 'package:kirby_port_app/view_model/chat_view_model.dart';
import 'package:kirby_port_app/view_model/room_topic_view_model.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationPermission.handleNotificationPermission();
  NotificationPermission.startListening();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RoomViewModel()),
        ChangeNotifierProvider(create: (context) => TopicViewModel()),
        ChangeNotifierProvider(create: (context) => RoomTopicViewModel()),
        ChangeNotifierProvider(
            create: (context) =>
                ChatViewModel(serverUrl: "http://192.168.35.15:3000")),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
          scaffoldBackgroundColor: Colors.grey[900],
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black26, selectedItemColor: Colors.red),
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
      ),
    );
  }
}
