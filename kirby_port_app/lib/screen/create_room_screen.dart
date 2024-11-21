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
  DateTime? _selectedDateTime;

  bool _isActionEnabled = false;

  void _addRoom() {
    final createdAtLocalDT = DateTime.now();
    final startDateTime = _selectedDateTime!;

    Room room = Room(
      name: _textEditingController.text,
      startTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(startDateTime),
      endTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(startDateTime.add(const Duration(hours: 1))),
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
      _isActionEnabled = _textEditingController.text.isNotEmpty && _selectedTopic != null && _selectedDateTime != null;
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
        title: const Text('채팅방 생성'),
        actions: [
          IconButton(
            onPressed: _isActionEnabled ? _addRoom : null,
            icon: const Icon(Icons.check),
            color: Colors.red,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "방 이름",
              ),
              const SizedBox(height: 18),
              TextField(
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
              const SizedBox(height: 30),
              const Text("주제 선택", style: TextStyle()),
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
                    color: Colors.white, //보라색 됨
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("날짜 및 시간 선택"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectDateTime,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.red[900],
                ),
                child: Text(
                  _selectedDateTime != null ? getFormattedDateTime(_selectedDateTime!) : "날짜 및 시간 선택하기",
                  style: const TextStyle(color: Colors.white), //보라색 됨
                ),
              ),
              const SizedBox(height: 50),
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
              children: Provider.of<TopicViewModel>(context).topics.map((topic) {
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
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );

    setState(() {
      _selectedDateTime = DateTime(
        selectedDate!.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime!.hour,
        selectedTime.minute,
      );
      validActionEnable();
    });
  }

  String getFormattedDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  Widget _buildPreviewCard() {
    return Card(
      color: Colors.black,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '채팅방 생성 미리보기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _textEditingController.text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildPreviewRow(_selectedTopic?.name ?? "선택되지 않음"),
            const SizedBox(height: 10),
            _buildPreviewRow(_selectedDateTime != null ? getFormattedDateTime(_selectedDateTime!) : "선택되지 않음"),
            const SizedBox(height: 10),
            _buildPreviewRow("~ ${_getEndTimeFormatted() ?? "선택되지 않음"}")
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
