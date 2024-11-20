import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 130),
                  //제목:커비포트
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/kirby.gif',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'KirBy',
                            style: TextStyle(
                                fontSize: 31,
                                fontWeight: FontWeight.w900,
                                color: Colors.red[900]),
                          ),
                          Text(
                            'Port',
                            style: TextStyle(
                                fontSize: 31,
                                fontWeight: FontWeight.w900,
                                color: Colors.red[900]),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '이메일을 입력해주세요.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "E-mail",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 158, 158, 158),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '비밀번호를 입력해주세요.';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 158, 158, 158),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  //로그인/회원가입
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfff44336)),
                      child: const Text('Login',
                          style: TextStyle(
                              color: Color(0xFFFfffff), fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                        onPressed: () {
                          context.push('/signup');
                        },
                        child: Text(
                          'Join Us',
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 16),
                        )),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Hot Chat🔥',
                    style: TextStyle(
                      color: Colors.red[900],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 0.5, color: Colors.red),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5), // 그림자 색상 및 투명도
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
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          Text(
                            '오징어게임 2',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Start: 2024-12-01 20:30",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            "Start: 2024-12-01 23:00",
                            style: TextStyle(color: Colors.white, fontSize: 1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[700],
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
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  // border: Border.all(width: 0.5, color: Colors.red),
                  borderRadius: BorderRadius.circular(12),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.red.withOpacity(0.5), // 그림자 색상 및 투명도
                  //     blurRadius: 20, // 그림자 흐림 정도
                  //     offset: const Offset(0, 0), // 그림자의 x, y 위치
                  //   ),
                  // ],
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
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          Text(
                            '오징어게임 1',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Start: 2024-12-01 20:30",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            "Start: 2024-12-01 23:00",
                            style: TextStyle(color: Colors.white, fontSize: 1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[700],
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
                              style: TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }
}
