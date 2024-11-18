import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

//TODO: 이 프라이빗 문제를 해결하면 어떻게해야 하는지
  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  int _currentStep = 0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _isLoading = false;

  //코드가 길어져서 각 스텝의 데코레이션 설정은 따로 메서드로 정의
  InputDecoration buildInputDecoration(String labelText, Color labelColor) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelStyle: TextStyle(
        fontSize: 14,
        color: labelColor,
        height: 3.0,
      ),
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  List<Step> _steps() => [
        //각 스텝의 단계를 리스트로 생성
        Step(
          //1. 이메일 입력
          title: const Text(
            //텍스트 표시 및 스타일 설정
            '이메일 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            //텍스트필드 컨트롤러 및 데코레이션, 키보드 입력 설정
            controller: _emailController,
            decoration: buildInputDecoration('이메일', Colors.red),
            keyboardType: TextInputType.emailAddress, //키보드 입력타입 이메일
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          //2. 비밀번호 입력
          title: const Text(
            '비밀번호 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _passwordController,
            decoration: buildInputDecoration('비밀번호', Colors.red),
            obscureText: true, //입력문자 가리기 활성화
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          //3. 닉네임
          title: const Text(
            '닉네임 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _nicknameController,
            decoration: buildInputDecoration('닉네임', Colors.red),
          ),
          isActive: _currentStep >= 2,
        ),
      ];

  Future<void> registerUser() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      // Invalid email
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          '유효한 이메일을 입력하세요.',
          style: TextStyle(color: Colors.red),
        )),
      );
      return;
    } //상태확인 후 오류메세지 출력(이메일)

    if (_passwordController.text.length < 6) {
      // Password too short
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호는 최소 6자 이상이어야 합니다.')),
      );
      return;
    } //상태확인 후 오류메세지 출력(비번)

    setState(() {
      _isLoading = true; // Show loading
    });

    try {
      // Firebase Auth를 사용하여 사용자 등록
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'nickname': _nicknameController.text,
        'email': _emailController.text,
        // 'profileimage':
        //     _defaultProfileImageUrl, // Firebase Storage의 기본 프로필 이미지 URL 저장
      });

      // 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다.')),
      );

      // 1초 후 로그인 페이지로 이동
      await Future.delayed(const Duration(seconds: 1));

      // 회원가입 후 로그인 페이지로 이동
      GoRouter.of(context).push('/LoginScreen');
    } on FirebaseAuthException catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? '회원가입에 실패했습니다.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Align(
          //타이틀 위치지정
          alignment: Alignment.centerLeft,
          child: Text(
            'Kirby Port',
            style: TextStyle(color: Colors.red),
          ),
        ),
        backgroundColor: Colors.transparent, //배경색없음
      ),
      //회원가입(비동기 작업)이 진행 중? true(로딩화면) : flase(Stepper)
      body: _isLoading
          //true : 로딩 중일 경우 시각적인 로딩 화면을 보여줌(CircularProgressIndicator)
          ? const Center(
              //중앙에 보여주기
              child: CircularProgressIndicator()) // Loading indicator(로딩스피너)
          //false : Stepper(단계별 UI).
          : Theme(
              //stepper의 테마 지정
              data: ThemeData(
                  //색상지정
                  colorScheme:
                      const ColorScheme.light(primary: Colors.red)), //주요 색상을 지정
              child: Center(
                //stepper 양식 지정
                child: Stepper(
                  stepIconHeight: 40, //스텝아이콘 높이40
                  stepIconWidth: 40, //스텝아이콘 너비40
                  stepIconBuilder: (stepIndex, stepState) {
                    //step인덱스순서, step상태(사용되지않음)
                    return Container(
                        //아이콘 크기와 정렬을 설정
                        alignment: Alignment.center, //가운데정렬
                        width: 40, //너비
                        height: 40, //높이
                        child: Text(
                            (stepIndex + 1).toString(), //현재 step의 번호를 텍스트로 표시
                            style: TextStyle(
                                //텍스트 색상을 조건에 따라 변경
                                color:
                                    _currentStep >= stepIndex //현재step까지 완료한 경우
                                        ? Colors.white //완료: 흰색표시
                                        : const Color.fromARGB(
                                            255, 193, 193, 193)))); //미완료: 회색표시
                  },
                  currentStep: _currentStep, //현재 진행중인 Step의 인덱스(0부터 시작)
                  onStepContinue: () {
                    //다음 버튼을 눌렀을 때 실행되는 함수
                    if (_currentStep < _steps().length - 1) {
                      setState(() {
                        //호출하여 UI 업데이트
                        _currentStep++; //인덱스 증가
                      });
                    } else {
                      registerUser(); // 마지막 단계에서 회원가입 처리
                      //-> registerUser호출, firebase에 회원가입 요청
                    }
                  },
                  onStepCancel: () {
                    //취소 버튼을 눌렀을때 실행되는 함수
                    if (_currentStep > 0) {
                      setState(() {
                        //호출하여 UI 업데이트
                        _currentStep--; //인덱스 감소
                      });
                    }
                  },
                  steps: _steps(), //함수로 생성된 step리스트를 사용

                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // 흰색 배경
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // 곡률 설정
                                ), // 검정 글씨
                              ),
                              child: const Text('Continue'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: details.onStepCancel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // 흰색 배경
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // 곡률 설정
                                ), // 검정 글씨
                              ),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
