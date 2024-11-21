import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:provider/provider.dart';
import '../service/local_notification_manager.dart';
import 'dart:async';

class RoomItem extends StatefulWidget {
  final Room room;
  final String topicName;

  const RoomItem({super.key, required this.room, required this.topicName});

  @override
  State<RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Timer 초기화
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.room.id.toString()),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        _deleteRoom(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.room.name} 삭제됨')));
      },
      background: _buildSwipeBackground(Colors.red),
      secondaryBackground: _buildSwipeBackground(Colors.red),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 5,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${widget.topicName}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      widget.room.name,
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      " ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.room.startTime))}", // 초 없앰
                      style: const TextStyle(fontSize: 11),
                    ),
                    Text(
                      "  ~  ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.room.endTime))}", //초 없앰
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                Center(
                  child: Row(
                    children: [
                      if (widget.room.reserveYn == "N")
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _updateReserveYn(context, "Y");
                            LocalNotificationManager.showInstanceNotification(widget.room.name, "예약 성공", widget.room.id!);
                            DateTime startTime = DateTime.parse(widget.room.startTime);
                            LocalNotificationManager.scheduleNotification(widget.room.name, "방이 오픈 되었커비 ", startTime, widget.room.id!);
                          },
                        )
                      else if (DateTime.now().isAfter(DateTime.parse(widget.room.startTime)) && widget.room.reserveYn == "Y")
                        IconButton(
                          icon: const Icon(
                            Icons.door_front_door_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            context.push('/home/list');
                          },
                        )
                      else if (widget.room.reserveYn == "Y")
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_active,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _updateReserveYn(context, "N");
                          },
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateReserveYn(BuildContext context, String reserveYn) {
    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    roomViewModel.updateReserveYn(
      roomId: widget.room.id!,
      reserveYn: reserveYn,
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );
  }

  void _deleteRoom(BuildContext context) {
    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    roomViewModel.removeRoom(widget.room.id!);
  }

  Widget _buildSwipeBackground(Color color) {
    return Container(
      color: color,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Icon(
        Icons.delete,
      ),
    );
  }
}
