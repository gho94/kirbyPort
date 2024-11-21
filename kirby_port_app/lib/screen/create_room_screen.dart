import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/model/topic_model.dart';
import 'package:provider/provider.dart';
import 'package:kirby_port_app/utils/color_and_style.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _textEditingController = TextEditingController();
  Topic? _selectedTopic;
  DateTime? _selectedDateTime;

  bool _isActionEnabled = false;

  void _addRoom() {
    final createdAtLocalDT = DateTime.now();
    final startDateTime = _selectedDateTime!;

    Room room = Room(
      name: _textEditingController.text,
      startTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(startDateTime),
      endTime: DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(startDateTime.add(const Duration(hours: 1))),
      topicId: _selectedTopic?.id ?? 1,
      playerId: 1,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAtLocalDT),
      reserveYn: "N",
    );

    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    roomViewModel.addRoom(room);

    Navigator.pop(context);
  }

  void validActionEnable() {
    setState(() {
      _isActionEnabled = _textEditingController.text.isNotEmpty &&
          _selectedTopic != null &&
          _selectedDateTime != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: myRed900,
        ),
        title: const Text('채팅방 생성'),
        actions: [
          IconButton(
            onPressed: _isActionEnabled ? _addRoom : null,
            icon: const Icon(Icons.check),
            color: myRed900,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("방 이름", style: titleTextStyle),
              const SizedBox(height: 10),
              TextField(
                controller: _textEditingController,
                decoration: myInputDecoration(),
                onChanged: (value) => validActionEnable(),
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 30),
              const Text("주제", style: titleTextStyle),
              const SizedBox(height: 10),
              myElevatedButton(
                onPressed: () => _showTopicSelectionDialog(context),
                text: _selectedTopic?.name ?? "선택하기",
              ),
              const SizedBox(height: 30),
              const Text("날짜 및 시간", style: titleTextStyle),
              const SizedBox(height: 10),
              myElevatedButton(
                onPressed: _selectDateTime,
                text: _selectedDateTime != null
                    ? getFormattedDateTime(_selectedDateTime!)
                    : "선택하기",
              ),
              const SizedBox(height: 60),
              _buildPreviewCard(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTopicSelectionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("주제를 선택하세요."),
          actions: [
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children:
                  Provider.of<TopicViewModel>(context).topics.map((topic) {
                return SizedBox(
                  width: 46.0,
                  height: 46.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _selectedTopic = topic;
                        validActionEnable();
                      });
                      Navigator.pop(context);
                    },
                    // 오류 때문에 추가함
                    heroTag: Text(topic.name),
                    child: Text(topic.name),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDateTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted) return;
    if (selectedDate == null) {
      // 달력 다이얼로그 취소해도 시간으로 넘어가서 수정
      return;
    }
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );

    if (selectedTime == null) {
      // 시간 다이얼로그 취소시 오류나서 수정
      return;
    }

    setState(() {
      _selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      validActionEnable();
    });
  }

  String getFormattedDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  Widget _buildPreviewCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.black,
        elevation: 10.0,
        margin: EdgeInsets.zero, // 여백 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '채팅방 생성 미리보기',
                style: TextStyle(
                  fontSize: 17,
                  decoration: TextDecoration.underline,
                  decorationColor: myRed900,
                  fontWeight: FontWeight.w900,
                  color: myRed900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _textEditingController.text.isNotEmpty == true
                    ? _textEditingController.text
                    : "방 이름을 입력해주세요",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              buildPreviewText(
                  _selectedTopic?.name != null
                      ? "#${_selectedTopic!.name}"
                      : "#주제를 선택해주세요",
                  fontSize: 20),
              const SizedBox(height: 10),
              buildPreviewText(_selectedDateTime != null
                  ? "Start ${getFormattedDateTime(_selectedDateTime!)}"
                  : "Start 일시를 선택해주세요"),
              const SizedBox(height: 5),
              buildPreviewText("End ${_getEndTimeFormatted() ?? "일시를 선택해주세요"}"),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  //buildPreviewText("커스텀 텍스트", fontSize: 14); //폰트사이즈는 선택
  Text buildPreviewText(String value, {double fontSize = 14}) {
    return Text(
      value,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  String? _getEndTimeFormatted() {
    if (_selectedDateTime != null) {
      DateTime endTime = _selectedDateTime!.add(const Duration(hours: 1));
      return getFormattedDateTime(endTime);
    }
    return null;
  }
}
