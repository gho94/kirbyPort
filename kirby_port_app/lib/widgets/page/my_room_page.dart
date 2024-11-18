import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kirby_port_app/controller/room_controller.dart';
import 'package:kirby_port_app/controller/topic_controller.dart';
import 'package:kirby_port_app/widgets/infinite_scroll_mixin.dart';
import 'package:kirby_port_app/widgets/room_item.dart';
import 'package:provider/provider.dart';

class MyRoomPage extends StatefulWidget {
  const MyRoomPage({super.key});

  @override
  State<MyRoomPage> createState() => _MyRoomPageState();
}

class _MyRoomPageState extends State<MyRoomPage> with InfiniteScrollMixin {
  @override
  void onScroll() {
    final roomController = Provider.of<RoomController>(context, listen: false);
    roomController.loadMoreRooms();
  }

  @override
  void initState() {
    super.initState();
    initScrollListener();
  }

  @override
  void dispose() {
    disposeScrollListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RoomController, TopicController>(
      builder: (context, roomController, topicController, child) {
        final selectedTopicIds = topicController.selectedTopicIds;
        final myRooms = roomController.rooms.where((room) => room.reserveYn == "Y").toList();
        final filterRooms = myRooms.where((room) => selectedTopicIds.isEmpty || selectedTopicIds.contains(room.topicId)).toList();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: filterRooms.length + (roomController.loading ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      if (roomController.loading && index == filterRooms.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final room = filterRooms[index];
                      final topic = topicController.topics.where((topic) => topic.id == room.topicId).firstOrNull;

                      return RoomItem(room: room, topicName: topic?.name ?? "Unknown");
                    },
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push("/create-room"),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
