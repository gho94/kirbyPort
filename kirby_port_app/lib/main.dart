import 'package:flutter/material.dart';
import 'package:kirby_port_app/controller/room_controller.dart';
import 'package:kirby_port_app/controller/topic_controller.dart';
import 'package:kirby_port_app/route.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화를 위해 필요
import 'firebase_options.dart'; // Firebase 설정 파일
import 'package:kirby_port_app/service/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase의 비동기 방식을 가능하게 하기 위해 Flutter 엔진 초기화
  await Firebase.initializeApp(
    //이제 비동기 방식인 initializeApp사용가능(파이어베이스 불러오기위한 기본 동작)
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 초기화 옵션
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserService.instance),
        ChangeNotifierProvider(create: (context) => RoomController()),
        ChangeNotifierProvider(create: (context) => TopicController()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
