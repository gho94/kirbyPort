import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kirby_port_app/widgets/page/my_room_page.dart';
import 'package:kirby_port_app/widgets/page/room_list_page.dart';
import 'package:kirby_port_app/widgets/screen/create_room_screen.dart';
import 'package:kirby_port_app/widgets/screen/home_screen.dart';
import 'package:kirby_port_app/widgets/screen/topic_filter_screen.dart';

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
            return const RoomListPage();
          },
        ),
        GoRoute(
          path: "myRoom",
          builder: (BuildContext context, GoRouterState state) {
            return const MyRoomPage();
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
        // GoRoute(
        //   path: "list",
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const ChatScreen();
        //   },
        // ),
      ],
    ),
  ],
);
