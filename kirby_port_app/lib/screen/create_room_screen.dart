import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kirby_port_app/component/room_item.dart';
import 'package:kirby_port_app/component/topic_container.dart';
import 'package:kirby_port_app/model/room_topic_model.dart';
import 'package:kirby_port_app/view_model/room_topic_view_model.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:provider/provider.dart';
import 'package:kirby_port_app/utils/color_and_style.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _textEditingController = TextEditingController();
  bool _topicSelected = false;
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isActionEnabled = false;

  void validActionEnable() {
    setState(() {
      _isActionEnabled = _textEditingController.text.isNotEmpty && _topicSelected && _startDate != null && _endDate != null;
    });
  }

  Future<void> _addRoom() async {
    Room room = createRoom();

    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    int roomId = await roomViewModel.addRoom(room);

    _addRoomTopic(roomId);
  }

  void _addRoomTopic(int roomId) {
    final List<int> selectedTopicIds = Provider.of<TopicViewModel>(context, listen: false).selectedTopicIds;
    for (int topicId in selectedTopicIds) {
      RoomTopic roomTopic = RoomTopic(
        roomId: roomId,
        topicId: topicId,
      );

      final roomTopicViewModel = Provider.of<RoomTopicViewModel>(context, listen: false);
      roomTopicViewModel.addRoomTopic(roomTopic);
    }

    final topicViewModel = Provider.of<TopicViewModel>(context, listen: false);
    topicViewModel.clearSelectedTopics();

    final roomTopicViewModel = Provider.of<RoomTopicViewModel>(context, listen: false);
    roomTopicViewModel.getRoomTopics();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            final topicViewModel = Provider.of<TopicViewModel>(context, listen: false);
            topicViewModel.clearSelectedTopics();
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
                maxLength: 15,
                decoration: myInputDecoration(),
                onChanged: (value) => validActionEnable(),
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 30),
              const Text("주제", style: titleTextStyle),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildTopicList()),
                ],
              ),
              const SizedBox(height: 30),
              const Text("시작 날짜", style: titleTextStyle),
              const SizedBox(height: 10),
              myElevatedButton(
                onPressed: () async {
                  DateTime? selectedDateTime = await _selectDateTime(context);
                  if (selectedDateTime != null) {
                    if (selectedDateTime.isBefore(DateTime.now()) && context.mounted) {
                      _showInvalidDateDialog(context, true);
                    } else {
                      setState(() {
                        _startDate = selectedDateTime;
                        _endDate = _startDate!.add(const Duration(hours: 1));
                      });
                      validActionEnable();
                    }
                  }
                },
                text: _startDate != null ? getFormattedDateTime(_startDate!) : "선택하기",
              ),
              const SizedBox(height: 30),
              const Text("종료 날짜", style: titleTextStyle),
              const SizedBox(height: 10),
              myElevatedButton(
                onPressed: () async {
                  DateTime? selectedDateTime = await _selectDateTime(context);
                  if (selectedDateTime != null) {
                    if (_startDate != null && selectedDateTime.isBefore(_startDate!) && context.mounted) {
                      _showInvalidDateDialog(context, false);
                    } else {
                      setState(() {
                        _endDate = selectedDateTime;
                      });
                      validActionEnable();
                    }
                  }
                },
                text: _endDate != null ? getFormattedDateTime(_endDate!) : "선택하기",
              ),
              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '채팅방 생성 미리보기',
                  style: TextStyle(
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    decorationColor: myRed900,
                    fontWeight: FontWeight.w900,
                    color: myRed900,
                  ),
                ),
              ),
              _buildPreviewRoomItem(),
              //_buildPreviewCard(),
            ],
          ),
        ),
      ),
    );
  }

  void _showInvalidDateDialog(BuildContext context, bool isStart) {
    String content = isStart ? "시작 날짜는 오늘보다 뒤이어야 합니다." : "종료 날짜는 시작 날짜보다 뒤이어야 합니다.";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("유효하지 않은 날짜"),
          content: Text(content),
          actions: [
            TextButton(child: const Text("확인"), onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    DateTime now = DateTime.now();

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && context.mounted) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return null;
  }

  String getFormattedDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  Widget _buildTopicList() {
    return Consumer<TopicViewModel>(
      builder: (context, topicViewModel, child) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: topicViewModel.topics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        topicViewModel.toggleTopicSelection(topic.id!);
                        setState(() {
                          _topicSelected = topicViewModel.selectedTopicIds.isNotEmpty;
                        });
                        validActionEnable();
                      },
                      child: TopicContainer(
                        text: topic.name,
                        isSelected: topicViewModel.selectedTopicIds.contains(topic.id!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Room createRoom() {
    return Room(
      name: _textEditingController.text.isEmpty ? "방 이름" : _textEditingController.text,
      startTime: _startDate == null ? DateTime.now().toString() : _startDate.toString(),
      endTime: _endDate == null ? DateTime.now().toString() : _endDate.toString(),
      playerId: 1,
      createdAt: DateTime.now().toString(),
      reserveYn: "N",
    );
  }

  Widget _buildPreviewRoomItem() {
    Room room = createRoom();

    return Consumer<TopicViewModel>(
      builder: (context, topicViewModel, child) {
        List<String> topicNames =
            topicViewModel.topics.where((topic) => topicViewModel.selectedTopicIds.contains(topic.id!)).map((topic) => topic.name).toList();

        return RoomItem(room: room, topicNames: topicNames.isNotEmpty ? topicNames : ["Unknown"]);
      },
    );
  }
}
