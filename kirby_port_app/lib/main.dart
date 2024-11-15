import 'package:flutter/material.dart';
import 'package:kirby_port_app/controller/room_controller.dart';
import 'package:kirby_port_app/controller/topic_controller.dart';
import 'package:kirby_port_app/route.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RoomController()),
        ChangeNotifierProvider(create: (context) => TopicController()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
