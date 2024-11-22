import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kirby_port_app/utils/color_and_style.dart';
import 'package:provider/provider.dart';
import '../service/device_info_manager.dart';
import 'package:kirby_port_app/view_model/chat_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final DeviceInfoManager deviceInfoManager = DeviceInfoManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myGrey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //제목, IDPW, 버튼
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.24),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 120),
                      //제목:커비포트
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/kirby.gif',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'KirBy',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.red[900],
                                    fontFamily: 'kirby'),
                              ),
                              Text(
                                'Port',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.red[900],
                                  fontFamily: 'kirby',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      //ID/PW:입력창
                      SizedBox(
                        height: 45,
                        child: TextFormField(
                          controller: _nicknameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '닉네임을 입력해주세요~!';
                            }
                            return null;
                          },
                          decoration: myInputDecoration(
                            labelText: "Nick Name",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 20),
                      //로그인/회원가입
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 40,
                        child: myElevatedButton(
                          onPressed: () {
                            String nickname = _nicknameController.text.trim();
                            if (nickname.isNotEmpty) {
                              final chatViewModel = Provider.of<ChatViewModel>(
                                  context,
                                  listen: false);
                              chatViewModel.initializeUsers(nickname);
                              context.go('/home');
                            } else {
                              _showTopPopup(context);
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         content: Text('닉네임을 입력해주세요.'),
                              //         behavior: SnackBarBehavior.floating,
                              //         margin: EdgeInsets.only(top: kToolbarHeight),
                              //       ),
                              //     );
                            }
                          },
                          text: 'Login',
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          onPressed: () {
                            context.push('/signup');
                          },
                          child: const Text(
                            'Join Us',
                            style: TextStyle(color: myRed900, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              //Hot Chat
              Column(
                children: [
                  //Text: Hot Chst
                  const Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Hot Chat🔥',
                        style: TextStyle(
                          color: myRed900,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  //채팅방 목록
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(width: 0.5, color: myRed900),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    myRed900.withOpacity(0.5), // 그림자 색상 및 투명도
                                blurRadius: 20, // 그림자 흐림 정도
                                offset: const Offset(0, 0), // 그림자의 x, y 위치
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#액션, #스릴러',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    Text(
                                      '오징어게임 2',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Start: 2024-12-01 20:30",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      "Start: 2024-12-01 23:00",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: myRed700,
                                          minimumSize: const Size(20, 40)),
                                      onPressed: () => context.push('/'),
                                      child: const Text(
                                        "참여",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () => context.push('/'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          minimumSize: const Size(20, 40)),
                                      child: const Text(
                                        "취소",
                                        style: TextStyle(
                                            color: Colors.white), //보라색 됨
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#액션, #스릴러',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    Text(
                                      '오징어게임 1',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Start: 2024-12-01 20:30",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      "Start: 2024-12-01 23:00",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 1),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: myRed700,
                                          minimumSize: const Size(20, 40)),
                                      onPressed: () => context.push('/'),
                                      child: const Text(
                                        "참여",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () => context.push('/'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          minimumSize: const Size(20, 40)),
                                      child: const Text(
                                        "취소",
                                        style: TextStyle(
                                            color: Colors.white), //보라색 됨
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          //검은색 아래쪽 채우는 그라데이션
          Positioned(
            bottom: 0, // 화면의 바닥에 배치
            left: 0,
            right: 0,
            height: 30, // 검은색 영역의 높이
            child: Container(
              color: Colors.black, // 검은색
            ),
          ),

          // 검은색 위에서부터 시작하는 그라데이션
          Positioned(
            bottom: 30, // 검은색 위에서부터 시작
            left: 0,
            right: 0,
            height: 80, // 그라데이션 높이
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black, // 시작점 (검은색)
                    Colors.transparent, // 끝점 (투명)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTopPopup(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(200, 195, 5, 5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '닉네임을 입력해주세요.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }
}
