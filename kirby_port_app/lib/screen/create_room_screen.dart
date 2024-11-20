import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/model/topic_model.dart';
import 'package:provider/provider.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _textEditingController = TextEditingController();
  Topic? _selectedTopic;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _isActionEnabled = false;

  void _addRoom() {
    DateTime selectedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    Room room = Room(
      name: _textEditingController.text,
      startTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime),
      endTime: DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(selectedDateTime.add(const Duration(hours: 1))),
      topicId: _selectedTopic?.id ?? 1,
      playerId: 1,
      createdAt: DateTime.now().toString(),
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
          _selectedDate != null &&
          _selectedTime != null;
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
          color: Colors.red[900],
        ),
        title: const Text(
          '채팅방 생성',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isActionEnabled ? _addRoom : null,
            icon: const Icon(Icons.check),
            color: Colors.red,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "방 이름",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 18),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _textEditingController,
              decoration: InputDecoration(
                  labelText: ' 채팅방 이름을 지정',
                  labelStyle: TextStyle(color: Colors.red.withOpacity(0.6)),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(), //기본설정
                  ),
                  enabledBorder: const OutlineInputBorder(
                    //포커스가 없는 상태의 테두리
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 214, 0, 0),
                      width: 2,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    //포커스된 상태의 테두리
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 214, 0, 0),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[900]),
              onChanged: (value) => validActionEnable(),
              cursorColor: Colors.white,
            ),
            const SizedBox(height: 40),
            const Text("주제 선택",
                style: TextStyle(
                  color: Colors.white,
                )),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => _showTopicSelectionDialog(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
                backgroundColor: Colors.red[900],
              ),
              child: Text(
                _selectedTopic?.name ?? "선택하기",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "날짜 선택",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: _selectDate,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
                backgroundColor: Colors.red[900],
              ),
              child: Text(
                  _selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : "날짜 선택하기",
                  style: const TextStyle(
                    color: Colors.white,
                  )),
            ),
            const SizedBox(height: 5),
            const Text(
              "시간 선택",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: _selectTime,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
                backgroundColor: Colors.red[900],
              ),
              child: Text(
                _selectedTime != null
                    ? getFormattedTime(_selectedTime!)
                    : "시간 선택하기",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
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

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
        validActionEnable();
      });
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null && selectedTime != _selectedTime) {
      setState(() {
        _selectedTime = selectedTime;
        validActionEnable();
      });
    }
  }

  String getFormattedTime(TimeOfDay timeOfDay) {
    final DateTime dateTime =
        DateTime(2024, 1, 1, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(dateTime);
  }
}
