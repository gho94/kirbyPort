import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserService with ChangeNotifier {
  // 싱글톤 패턴으로 UserService 인스턴스 생성
  static final UserService instance = UserService._internal();

  UserCredential? userCredential;
  Map<String, dynamic>? currentUserData;

  UserService._internal();

  // 로그인 메서드
  Future<bool> loginUser(String email, String password) async {
    try {
      // Firebase Authentication을 통해 사용자 로그인
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 로그인 성공 시 True 반환
      return true;
    } catch (e) {
      print("Login failed: $e");
      return false;
    }
  }

  // 사용자 데이터 가져오기 메서드
  void listenUserData(String uid) async {
    try {
      // Firestore에서 사용자 데이터 가져오기
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        currentUserData = snapshot.data() as Map<String, dynamic>;
        notifyListeners(); // 데이터 변경 알림
      } else {
        print("No user data found for UID: $uid");
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
    }
  }

  // 로그아웃 메서드
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      userCredential = null;
      currentUserData = null;
      notifyListeners();
    } catch (e) {
      print("Logout failed: $e");
    }
  }
}
