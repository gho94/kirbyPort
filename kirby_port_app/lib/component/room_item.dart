import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:provider/provider.dart';
import '../service/local_notification_manager.dart';

class RoomItem extends StatelessWidget {
  final Room room;
  final List<String> topicNames;

  const RoomItem({super.key, required this.room, required this.topicNames});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(room.id.toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        final bool? confirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('삭제 확인'),
              content: Text('${room.name}을(를) 삭제하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('삭제'),
                ),
              ],
            );
          },
        );
        if (confirmed == true) {
          _deleteRoom(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${room.name} 삭제됨')),
          );
        }
        return confirmed;
      },
      background: _buildSwipeBackground(Colors.red),
      secondaryBackground: _buildSwipeBackground(Colors.red),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: topicNames.map((topicName) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Center(
                              child: Text("#$topicName", style: const TextStyle(fontSize: 12)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    room.name,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(room.startTime))} ~ ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(room.endTime))}",
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
              Center(
                child: Row(
                  children: [
                    if (room.reserveYn == "N")
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.grey),
                        onPressed: () => _updateReserveYn(context, "Y"),
                      )
                    else ...[
                      if (DateTime.now().isAfter(DateTime.parse(room.startTime)))
                        IconButton(
                          icon: const Icon(Icons.door_front_door_outlined, color: Colors.red),
                          onPressed: () => context.push('/home/list', extra: room.name),
                        )
                      else ...[
                        IconButton(
                          icon: const Icon(Icons.notifications_active, color: Colors.red),
                          onPressed: () => _updateReserveYn(context, "N"),
                        )
                      ]
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateReserveYn(BuildContext context, String reserveYn) {
    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    roomViewModel.updateReserveYn(
      roomId: room.id!,
      reserveYn: reserveYn,
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );

    _sendReservationNotification(reserveYn);
  }

  void _sendReservationNotification(String reserveYn) {
    if (reserveYn == "Y") {
      LocalNotificationManager.showInstanceNotification(room.name, "예약 성공", room.id!);
      DateTime startTime = DateTime.parse(room.startTime);
      LocalNotificationManager.scheduleNotification(room.name, "방이 오픈 되었커비 ", startTime, room.id!);
    } else {
      LocalNotificationManager.cancelNotification(room.id!);
      LocalNotificationManager.showInstanceNotification(room.name, "예약 취소", room.id!);
    }
  }

  void _deleteRoom(BuildContext context) {
    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    roomViewModel.removeRoom(room.id!);
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
