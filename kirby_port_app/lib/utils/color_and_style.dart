import 'package:flutter/material.dart';
// 스타일 지정 내용

// 소제목 텍스트스타일
const TextStyle titleTextStyle = TextStyle(
    color: Colors.white, //보라색 됨
    fontSize: 17,
    fontWeight: FontWeight.w500);

//색상지정
const myRed900 = Color(0xffB71D1C); //기본
const myRed800 = Color(0xffC62828); //아이콘버튼
const myRed700 = Color(0xffD3302F); //포인트
const myGrey = Color(0xff212121);
const myLightGrey = Color(0xff9E9E9E);

// myElevatedButton 사용예시
// myElevatedButton(onPressed: () => print("Button 1 clicked"),text: _selectedTopic?.name ?? "선택하기",),
Widget myElevatedButton({required VoidCallback onPressed, required String text,}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45), backgroundColor: myRed800,), // 동일한 스타일 사용
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16,),),);
}

// myInputDecoration 사용예시
// TextField(decoration: myInputDecoration(labelText: "채팅방 이름을 지정",labelStyle: const TextStyle(color: Colors.white),),),
InputDecoration myInputDecoration({String? labelText,}) {
  return InputDecoration(
    labelText: labelText, // labelText가 null일 경우 아무것도 표시되지 않음
    labelStyle: const TextStyle(color: Colors.white),
    // 기본 테두리 설정
    border: const OutlineInputBorder(borderSide: BorderSide(),),
    // 포커스가 없는 상태의 테두리
    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: myLightGrey, width: 1.5,),),
    // 포커스된 상태의 테두리
    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: myRed900, width: 1.5,),),
    filled: true,
    fillColor: myGrey,
  );
}
