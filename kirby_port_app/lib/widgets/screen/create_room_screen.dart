import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kirby_port_app/controller/room_controller.dart';
import 'package:kirby_port_app/controller/topic_controller.dart';
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
      endTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime.add(const Duration(hours: 1))),
      topicId: _selectedTopic?.id ?? 1,
      playerId: 1,
      createdAt: DateTime.now().toString(),
      reserveYn: "N",
    );

    final roomController = Provider.of<RoomController>(context, listen: false);
    roomController.addRoom(room);

    Navigator.pop(context);
  }

  void validActionEnable() {
    setState(() {
      _isActionEnabled = _textEditingController.text.isNotEmpty && _selectedTopic != null && _selectedDate != null && _selectedTime != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _isActionEnabled ? _addRoom : null,
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("방 이름"),
            const SizedBox(height: 5),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (value) => validActionEnable(),
            ),
            const SizedBox(height: 20),
            const Text("주제 선택"),
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () => _showTopicSelectionDialog(context),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 36)),
                child: Text(_selectedTopic?.name ?? "선택하기")),
            const SizedBox(height: 20),
            const Text("날짜 선택"),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: _selectDate,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 36)),
              child: Text(_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : "날짜 선택하기"),
            ),
            const SizedBox(height: 5),
            const Text("시간 선택"),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: _selectTime,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 36)),
              child: Text(_selectedTime != null ? getFormattedTime(_selectedTime!) : "시간 선택하기"),
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
              children: Provider.of<TopicController>(context).topics.map((topic) {
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
    final DateTime dateTime = DateTime(2024, 1, 1, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(dateTime);
  }
}
