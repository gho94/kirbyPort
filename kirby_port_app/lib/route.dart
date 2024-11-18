import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kirby_port_app/screen/chat_screen.dart';
import 'package:kirby_port_app/screen/create_room_screen.dart';
import 'package:kirby_port_app/screen/home_screen.dart';
import 'package:kirby_port_app/screen/my_room_screen.dart';
import 'package:kirby_port_app/screen/room_list_screen.dart';
import 'package:kirby_port_app/screen/topic_filter_screen.dart';

GoRouter get router => _router;

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: "chat",
          builder: (BuildContext context, GoRouterState state) {
            return const RoomListScreen();
          },
        ),
        GoRoute(
          path: "myRoom",
          builder: (BuildContext context, GoRouterState state) {
            return const MyRoomScreen();
          },
        ),
        GoRoute(
          path: "topic-filter",
          builder: (BuildContext context, GoRouterState state) {
            return const TopicFilterScreen();
          },
        ),
        GoRoute(
          path: "create-room",
          builder: (BuildContext context, GoRouterState state) {
            return const CreateRoomScreen();
          },
        ),
        GoRoute(
          path: "list",
          builder: (BuildContext context, GoRouterState state) {
            return const ChatScreen();
          },
        ),
      ],
    ),
  ],
);
