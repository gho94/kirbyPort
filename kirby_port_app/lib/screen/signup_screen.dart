import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<SignUpScreen> {
  int _currentStep = 0;
  bool _isLoading = false; // 로딩 상태
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();

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
        Step(
          title: const Text(
            '이메일 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _emailController,
            decoration: buildInputDecoration('이메일', Colors.red),
            keyboardType: TextInputType.emailAddress,
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text(
            '비밀번호 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _passwordController,
            decoration: buildInputDecoration('비밀번호', Colors.red),
            obscureText: true,
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 이메일을 입력하세요.')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호는 최소 6자 이상이어야 합니다.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      ScaffoldMessengerState scaffoldMessengerState =
          ScaffoldMessenger.of(context);
      GoRouter goRouter = GoRouter.of(context);

      await Future.delayed(const Duration(seconds: 2));

      scaffoldMessengerState
          .showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다.')));
      goRouter.go('/login');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Kirby Port',
            style: TextStyle(color: Colors.red),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Theme(
              data: ThemeData(
                  colorScheme: const ColorScheme.light(primary: Colors.red)),
              child: Center(
                child: Stepper(
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < _steps().length - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      registerUser();
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep--;
                      });
                    }
                  },
                  steps: _steps(),
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Continue'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: details.onStepCancel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
