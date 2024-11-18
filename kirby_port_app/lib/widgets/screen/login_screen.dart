import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kirby_port_app/service/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false, //키보드가 올라와도 화면 재배치 없음
      appBar: AppBar(
        //상단 바(앱바)
        title: const Align(
          //타이틀 글자의 위치 지정을 위해 align 사용
          alignment: Alignment.centerLeft, //중앙+좌측 정렬
          child: Text(
            'KirBy Port', //align의 차일드로 텍스트입력
            style: TextStyle(color: Colors.red), //글자색 레드
          ),
        ),
        backgroundColor: Colors.transparent, //배경색없음
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
            //EdgeInsets - 여백을 정의하는 클래스
            //symmetric - 수평 및 수직 방향의 여백을 각각 설정할 수 있음
            horizontal: MediaQuery.of(context).size.width * 0.25), //수평여백
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/kirby.gif',
                  width: 100,
                  height: 100,
                ),
                Text('  Login',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              //ID
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "E-mail",
                enabledBorder: OutlineInputBorder(
                  //활성 상태 보더 속성
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 158, 158, 158), //활성 상태 테두리 색상
                    width: 1.5, //테두리 두께
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  //창을 클릭했을때 보더 속성
                  borderSide: BorderSide(
                    color: Colors.red, //포커스 상태 테두리 색상
                    width: 1.5,
                  ),
                ), //테두리
                filled: true, //색채우기
                fillColor: Colors.white, //흰색
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              //PW
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Password",
                enabledBorder: OutlineInputBorder(
                  //활성 상태 보더 속성
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 158, 158, 158), //활성 상태 테두리 색상
                    width: 1.5, //테두리 두께
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  //창을 클릭했을때 보더 속성
                  borderSide: BorderSide(
                    color: Colors.red, //포커스 상태 테두리 색상
                    width: 1.5,
                  ),
                ), //테두리
                filled: true, //색채우기
                fillColor: Colors.white, //흰색
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              //로그인
              width: MediaQuery.of(context).size.width * 0.3,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  //비동기로 진행
                  bool ret = await UserService.instance.loginUser(
                      //UserService 클래스의 싱글톤 객체를 가져온다
                      _emailController.text,
                      _passwordController.text);
                  if (ret) {
                    print('Login successful');
                    print(
                        'User UID: ${UserService.instance.userCredential?.user?.uid}');
                    Provider.of<UserService>(context, listen: false)
                        .listenUserData(
                            UserService.instance.userCredential!.user!.uid);
                    print('Navigating to /home');
                    GoRouter.of(context).go('/home');
                  } else {
                    print('Login failed');
                  }

                  // if (ret) {//ret이 true일 때(로그인 성공 시)
                  //   Provider.of<UserService>(context, listen: false)
                  //       .listenUserData(
                  //           UserService.instance.userCredential!.user!.uid);
                  //   GoRouter.of(context).go('/home');
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text('Login failed!'),
                  //   ));
                  // }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff44336)),
                child: const Text('Login',
                    style: TextStyle(color: Color(0xFFFfffff), fontSize: 20)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                  onPressed: () {
                    context.push('/joinScreen');
                  },
                  child: const Text(
                    'Join Us',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
