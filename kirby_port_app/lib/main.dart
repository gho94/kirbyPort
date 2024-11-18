import 'package:flutter/material.dart';
import 'package:kirby_port_app/route.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RoomViewModel()),
        ChangeNotifierProvider(create: (context) => TopicViewModel()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
