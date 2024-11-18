import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Align(
            //타이틀 위치지정
            alignment: Alignment.centerLeft,
            child: Text(
              'Kirby Port',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.transparent, //배경색없음
        ),
        body: LayoutBuilder(
          //부모 위젯의 크기를 기반으로 동적 크기 설정
          builder: (context, constrains) {
            //context : 부모로부터 현재 자식위젯의 위치를 확인,
            //constrains : 부모위젯이 자식에게 부여하는 크기 제한 정보
            double screenWidth =
                constrains.maxWidth; //screenWidth크기정의 = 부모위젯의 최대너비
            double screenHeight =
                constrains.maxHeight; //screenHeight크기정의 = 부모위젯의 최대높이
            double boxHeight = screenHeight * 0.8; //높이지정
            double boxWidth = screenWidth * 0.85; //너비지정

            return Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white, //0xffFFF001),//FFFF77),//컨테이너색상
                ),
                width: boxWidth, //박스폭
                height: boxHeight, //박스높이
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                      child: Text(
                        "가입하기",
                        style: TextStyle(color: Colors.black, fontSize: 26),
                      ),
                    ), //가입하기
                    const SizedBox(height: 15), //간격
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: TextFormField(
                        //텍스트 입력 위젯, textField기반, 유효성 검사를 할 때 유용
                        decoration: const InputDecoration(
                          //텍스트입력필드의 디자인 추가
                          labelText: 'Nickname', //내부에 표시되는 레이블 텍스트
                          border:
                              OutlineInputBorder(), //기본 테두리 설정.. TextFormField는
                          // 활성/포커스 상태 두 가지가 있어서 각각 설정해줘야 함
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          )), //활성 상태 보더 속성),
                          focusedBorder: OutlineInputBorder(
                            //창을 클릭했을때 보더 속성
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ), //포커스 상태 테두리 색상
                          ), //테두리
                          filled: true, //색채우기
                          fillColor: Colors.white, //흰색
                        ),
                        obscureText: false, // 비밀번호 입력 시 텍스트 표시
                      ),
                    ), //닉네임 입력
                    const SizedBox(height: 10), //간격
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: TextFormField(
                        //텍스트 입력 위젯, textField기반, 유효성 검사를 할 때 유용
                        decoration: const InputDecoration(
                          //텍스트입력필드의 디자인 추가
                          labelText: 'ID', //내부에 표시되는 레이블 텍스트
                          border:
                              OutlineInputBorder(), //기본 테두리 설정.. TextFormField는 활성/포커스 상태 두 가지가 있어서 각각 설정해줘야 함
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          )), //활성 상태 보더 속성),
                          focusedBorder: OutlineInputBorder(
                            //창을 클릭했을때 보더 속성
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          filled: true, //색채우기
                          fillColor: Colors.white, //흰색
                        ),
                        obscureText: false, // 텍스트 숨김
                      ),
                    ), //ID 입력
                    const SizedBox(height: 10), //간격
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: TextFormField(
                        //텍스트 입력 위젯, textField기반, 유효성 검사를 할 때 유용
                        decoration: const InputDecoration(
                          //텍스트입력필드의 디자인 추가
                          labelText: 'Password', //내부에 표시되는 레이블 텍스트
                          border:
                              OutlineInputBorder(), //기본 테두리 설정.. TextFormField는 활성/포커스 상태 두 가지가 있어서 각각 설정해줘야 함
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          )), //활성 상태 보더 속성),
                          focusedBorder: OutlineInputBorder(
                            //창을 클릭했을때 보더 속성
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          filled: true, //색채우기
                          fillColor: Colors.white, //흰색
                        ),
                        obscureText: true, // 비밀번호 입력 시 텍스트 숨김
                      ),
                    ), //PW 입력
                    const SizedBox(height: 30), //간격
                    ElevatedButton(
                      onPressed: () {
                        context.push('/loginScreen');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // 텍스트 및 아이콘 색상
                        backgroundColor: Colors.red, // 배경색
                        elevation: 0, // 버튼 그림자 높이
                        minimumSize: const Size(200, 40),
                        padding: const EdgeInsets.symmetric(
                            //버튼내부여백
                            horizontal: 24, //양쪽여백 각 24픽셀
                            vertical: 16 //상하여백 각 16픽셀
                            ), // 버튼 내부 여백
                        shape: RoundedRectangleBorder(
                          //모서리설정 : 둥근 사각형 외곽
                          borderRadius:
                              BorderRadius.circular(13), // 모서리 둥글기 결정 (숫자=반지름값)
                        ),
                      ), //실행 시 유효성 검사 및 페이지 이동
                      child: const Text('완료'),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
