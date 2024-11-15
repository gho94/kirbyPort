import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kirby_port_app/controller/room_controller.dart';
import 'package:kirby_port_app/model/room_model.dart';
import 'package:provider/provider.dart';

class RoomItem extends StatelessWidget {
  final Room room;
  final String topicName;
  const RoomItem({super.key, required this.room, required this.topicName});

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
                    ElevatedButton(onPressed: () => _updateReserveYn(context, "Y"), child: const Text("예약"))
                  else ...[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () => context.go("/list"),
                      child: const Text("참여"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(onPressed: () => _updateReserveYn(context, "N"), child: const Text("취소")),
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
    final roomController = Provider.of<RoomController>(context, listen: false);

    roomController.updateReserveYn(
      roomId: room.id!,
      reserveYn: reserveYn,
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );
  }
}
