import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:kirby_port_app/component/infinite_scroll_mixin.dart';
import 'package:kirby_port_app/component/room_item.dart';
import 'package:provider/provider.dart';

class MyRoomScreen extends StatefulWidget {
  const MyRoomScreen({super.key});

  @override
  State<MyRoomScreen> createState() => _MyRoomScreenState();
}

class _MyRoomScreenState extends State<MyRoomScreen> with InfiniteScrollMixin {
  @override
  void onScroll() {
    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    roomViewModel.loadMoreRooms();
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
    return Consumer2<RoomViewModel, TopicViewModel>(
      builder: (context, roomViewModel, topicViewModel, child) {
        final selectedTopicIds = topicViewModel.selectedTopicIds;
        final myRooms = roomViewModel.rooms.where((room) => room.reserveYn == "Y").toList();
        final filterRooms = myRooms.where((room) => selectedTopicIds.isEmpty || selectedTopicIds.contains(room.topicId)).toList();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: filterRooms.length + (roomViewModel.loading ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      if (roomViewModel.loading && index == filterRooms.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final room = filterRooms[index];
                      final topic = topicViewModel.topics.where((topic) => topic.id == room.topicId).firstOrNull;

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
