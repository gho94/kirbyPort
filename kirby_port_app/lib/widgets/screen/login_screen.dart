import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //자유도높은 앱 스타일
      title: 'Kirby Port', //앱의 이름 표시
      color: Colors.red, //앱 속성 기본 색, 안드로이드 앱의 작업 표시줄 배경색
      home: Scaffold(
        //상중하단을 나눠주는 양식
        backgroundColor: const Color(0xffF9DBE8), //스캐폴드의 전체를 채우는 배경색
        appBar: AppBar(
          //상단 바(앱바)
          title: const Align(
            //타이틀 글자의 위치 지정을 위해 align 사용
            alignment: Alignment.centerLeft, //중앙+좌측 정렬
            child: Text(
              'Kirby Port', //align의 차일드로 텍스트입력
              style: TextStyle(color: Color(0xffE1015B)), //글자색 레드
            ),
          ),
          backgroundColor: Colors.transparent, //배경색없음
        ),
        body: LayoutBuilder(
          //부모 위젯의 크기를 기반으로 동적 크기 설정
          builder: (context, constrains) {
            //context : 부모로부터 현재 자식위젯의 위치를 확인,
            //constrains : 부모위젯이 자식에게 부여하는 크기 제한 정보
            //double screenWidth = constrains.maxWidth;//screenWidth크기정의 = 부모위젯의 최대너비
            double screenHeight =
                constrains.maxHeight; //screenHeight크기정의 = 부모위젯의 최대높이
            double boxHeight = screenHeight * 0.8; //높이지정
            double boxWidth = boxHeight * 0.5; //너비지정

            return Align(
              alignment: Alignment.center, //가운데정렬
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xffFFF001)
                      .withOpacity(0.5), //0xffFFF001),//FFFF77),//컨테이너색상
                ),
                width: boxWidth, //박스폭
                height: boxHeight, //박스높이
                child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, //세로로 여러개 위젯갖기 위해 감싸줌
                    children: [
                      Image.asset(
                        'assets/kirby.gif',
                        width: 100,
                        height: 100,
                      ), //사진삽입, 사이즈지정
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: TextFormField(
                          //텍스트 입력 위젯, textField기반, 유효성 검사를 할 때 유용
                          decoration: const InputDecoration(
                            //텍스트입력필드의 디자인 추가
                            labelText: 'ID', //내부에 표시되는 레이블 텍스트
                            border:
                                OutlineInputBorder(), //기본 테두리 설정.. TextFormField는
                            // 활성/포커스 상태 두 가지가 있어서 각각 설정해줘야 함
                            enabledBorder: OutlineInputBorder(
                              //활성 상태 보더 속성
                              borderSide: BorderSide(
                                color: Color(0xffFABE00), //활성 상태 테두리 색상
                                width: 2.0, //테두리 두께
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              //창을 클릭했을때 보더 속성
                              borderSide: BorderSide(
                                color: Color(0xffFABE00), //포커스 상태 테두리 색상
                                width: 2.0,
                              ),
                            ), //테두리
                            filled: true, //색채우기
                            fillColor: Colors.white, //흰색
                          ),
                          obscureText: false, // 비밀번호 입력 시 텍스트 표시
                        ),
                      ),
                      const SizedBox(height: 10), //PW입력창
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: TextFormField(
                          //텍스트 입력 위젯, textField기반, 유효성 검사를 할 때 유용
                          decoration: const InputDecoration(
                            //텍스트입력필드의 디자인 추가
                            labelText: 'Password', //내부에 표시되는 레이블 텍스트
                            border:
                                OutlineInputBorder(), //기본 테두리 설정.. TextFormField는 활성/포커스 상태 두 가지가 있어서 각각 설정해줘야 함
                            enabledBorder: OutlineInputBorder(
                              //활성 상태 보더 속성
                              borderSide: BorderSide(
                                color: Color(0xffFABE00), //활성 상태 테두리 색상
                                width: 2.0, //테두리 두께
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              //창을 클릭했을때 보더 속성
                              borderSide: BorderSide(
                                color: Color(0xffFABE00), //포커스 상태 테두리 색상
                                width: 2.0,
                              ),
                            ),
                            filled: true, //색채우기
                            fillColor: Colors.white, //흰색
                          ),
                          obscureText: true, // 비밀번호 입력 시 텍스트 숨김
                        ),
                      ),
                      const SizedBox(height: 30), //PW입력창
                      ElevatedButton(
                          onPressed: () {
                            context.push('/home');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                const Color(0xffE1015B), // 텍스트 및 아이콘 색상
                            backgroundColor: Colors.white, // 배경색
                            elevation: 0, // 버튼 그림자 높이
                            padding: const EdgeInsets.symmetric(
                                //버튼내부여백
                                horizontal: 24, //양쪽여백 각 24픽셀
                                vertical: 16 //상하여백 각 16픽셀
                                ), // 버튼 내부 여백
                            shape: RoundedRectangleBorder(
                              //모서리설정 : 둥근 사각형 외곽
                              borderRadius: BorderRadius.circular(
                                  13), // 모서리 둥글기 결정 (숫자=반지름값)
                            ),
                          ), //실행 시 유효성 검사 및 페이지 이동
                          child: const Text('로그인하기')),
                      TextButton(
                          onPressed: () {
                            context.push('/joinScreen');
                          },
                          child: const Text(
                            'Join Us',
                            style: TextStyle(
                                color: Color(0xffE1015B), fontSize: 11),
                          )),
                      const SizedBox(height: 50),
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }
}

//궁금한점
//a아래 b쓸 수 있고, b안에 a쓸 수 있으면 그게 무한정 입력이 가능한건지
//