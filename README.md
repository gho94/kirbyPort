# KirbyPort - 휘발성 오픈 채팅 플랫폼

## 프로젝트 개요
OTT 관련 주제에 대해 사용자가 직접 채팅방을 만들고, 주제를 설정하며, 알림을 통해 실시간 소통이 가능한 Flutter 기반 오픈 채팅 플랫폼입니다.  
- **프로젝트 기간:** 2024.11.13 ~ 2024.11.26
- **인원:** 5명
- **주요 역할:**  
  - 팀 개발 리드 및 일정 관리
  - SQLite 데이터베이스 설계
  - 채팅방/주제/알림 등 핵심 기능 구현

---

## 주요 기능
- **채팅방 및 주제 관리**
  - 사용자가 직접 채팅방 및 주제 생성/설정
  - 주제별 채팅방 목록 필터링 및 관리
- **실시간 알림 및 소통**
  - 알림 설정 및 배지 카운트 관리
  - 실시간 메시지 송수신(소켓 통신)
- **회원 관리**
  - 회원가입, 로그인, 내 정보 관리

---

## 기술 스택
- **Framework**: Flutter
- **상태관리**: Provider
- **주요 패키지**:
  - `sqflite`: 로컬 데이터베이스 관리
  - `go_router`: 앱 라우팅 시스템 구축
  - `socket_io_client`: 실시간 채팅 구현
  - `flutter_local_notifications`: 로컬 알림
  - `device_info_plus`, `permission_handler`: 디바이스 정보 및 권한 관리

---

## 프로젝트 구조

```
lib/
├── main.dart
├── route.dart
├── component/         # 재사용 UI 컴포넌트
├── model/             # 데이터 모델 정의
├── screen/            # 주요 화면(채팅, 방 생성, 로그인 등)
├── service/           # DB, 소켓, 알림 등 서비스 로직
├── utils/             # 컬러, 스타일 등 유틸리티
└── view_model/        # MVVM ViewModel 계층
```

---

## 아키텍처
이 프로젝트는 MVVM (Model-View-ViewModel) 아키텍처 패턴을 따릅니다:
- **Model**: 데이터 구조 정의 및 관리
- **View**: UI 컴포넌트 (screen/, component/)
- **ViewModel**: 비즈니스 로직 및 상태 관리 (providers/)

---

## 주요 화면
- **로그인/회원가입 화면**: 사용자 인증 및 회원 정보 입력
- **채팅방 목록/생성 화면**: 채팅방 리스트 확인, 신규 방/주제 생성
- **채팅 화면**: 실시간 메시지 송수신, 알림, 배지 카운트
- **주제 필터/관리 화면**: 주제별 채팅방 필터링 및 관리

---

## 성장 경험
- MVVM 아키텍처 패턴을 적용하여 비즈니스 로직과 UI를 분리하여 코드적용
- SQFlite 패키지를 활용하여 로컬 데이터베이스를 구축하고, 데이터를 로컬에서 관리
- Provider 패키지를 활용하여 앱 전체 상태를 관리하였고, 채팅방, 주제 등에 적용
- GoRoute 패키지를 활용하여 앱의 라우팅 시스템을 구축

---

## 프로젝트 회고
- MVVM, Provider, GoRouter 등 아키텍처와 패키지의 실질적 활용법을 익힘
- 파이어베이스, 서버 연동 등 미적용된 부분은 2차 프로젝트에서 보완 예정

---

## 프로젝트 캡쳐 이미지

<img src="https://github.com/user-attachments/assets/d40745e2-be49-4aa3-8630-ff6604bf0595" width="20%">
<img src="https://github.com/user-attachments/assets/d080acac-5263-40b9-82ff-526370e14bd9" width="20%">
<img src="https://github.com/user-attachments/assets/006607bc-d57f-4f5d-be30-4f40a25b81d0" width="20%">
<img src="https://github.com/user-attachments/assets/1166924a-0f85-4ba9-9185-609aee84d658" width="20%">
<img src="https://github.com/user-attachments/assets/0d28e674-9c8a-4704-8f34-8920a153119b" width="20%">
<img src="https://github.com/user-attachments/assets/107dc0f1-7411-4aba-ba7c-44289706fc5a" width="20%">
<img src="https://github.com/user-attachments/assets/bb257206-1342-46e9-8fbe-c3e946c6e2b0" width="20%">
<img src="https://github.com/user-attachments/assets/031644fb-6bec-42b7-a9a5-2034d94bfeda" width="20%">

---

## 성과
- 엘리스 1차 프로젝트 우수상 수상
<img src="https://github.com/user-attachments/assets/0563aade-6566-4caa-9400-ef3cb036d1a2" width="30%">

