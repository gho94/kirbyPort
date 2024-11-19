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
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("주제: $topicName"),
                Text("방이름: ${room.name}"),
                const SizedBox(height: 5),
                Text("시작: ${room.startTime}"),
                Text("종료: ${room.endTime}"),
              ],
            ),
            Center(
              child: Row(
                children: [
                  if (room.reserveYn == "N")
                    ElevatedButton(
                      onPressed: () {
                        _updateReserveYn(context, "Y");
                        LocalNotificationManager.showInstanceNotification(room.name, "예약 성공", index);
                        DateTime startTime = DateTime.parse(room.startTime);
                        LocalNotificationManager.scheduleNotification(room.name, "방이 오픈 되었커비 ", startTime, index);
                      },
                      child: const Text("예약"),
                    )
                  else ...[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () => context.push("/list"),
                      child: const Text("참여"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _updateReserveYn(context, "N");
                        LocalNotificationManager.cancelNotification(index);
                        LocalNotificationManager.showInstanceNotification(room.name, "예약 취소", index);
                      },
                      child: const Text("취소"),
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
