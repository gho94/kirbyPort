import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:provider/provider.dart';
import '../service/local_notification_manager.dart';

class RoomItem extends StatelessWidget {
  final Room room;
  final String topicName;
  final int index;

  const RoomItem({super.key, required this.room, required this.topicName, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  topicName,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  room.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 5),
                Text(
                  "Start: ${room.startTime}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  "End: ${room.endTime}",
                  style: const TextStyle(color: Colors.white, fontSize: 1),
                ),
              ],
            ),
            Center(
              child: Row(
                children: [
                  if (room.reserveYn == "N")
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.red[900],
                      ),
                      onPressed: () {
                        _updateReserveYn(context, "Y");
                        LocalNotificationManager.showInstanceNotification(room.name, "예약 성공", index);
                        DateTime startTime = DateTime.parse(room.startTime);
                        LocalNotificationManager.scheduleNotification(room.name, "방이 오픈 되었커비 ", startTime, index);
                      },
                    )
                  else ...[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700], minimumSize: const Size(20, 40)),
                      onPressed: () => context.push("/home/list"),
                      child: const Text(
                        "참여",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, minimumSize: const Size(20, 40)),
                      onPressed: () {
                        _updateReserveYn(context, "N");
                        LocalNotificationManager.cancelNotification(index);
                        LocalNotificationManager.showInstanceNotification(room.name, "예약 취소", index);
                      },
                      child: const Text(
                        "취소",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _updateReserveYn(BuildContext context, String reserveYn) {
    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);

    if (room.id != null) {
      roomViewModel.updateReserveYn(
        roomId: room.id!,
        reserveYn: reserveYn,
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      );
    } else {
      print("Room ID is null, cannot update reserve status.");
    }
  }
}
