import 'package:flutter/material.dart';
import 'package:kirby_port_app/view_model/room_topic_view_model.dart';
import 'package:kirby_port_app/view_model/room_view_model.dart';
import 'package:kirby_port_app/view_model/topic_view_model.dart';
import 'package:kirby_port_app/component/infinite_scroll_mixin.dart';
import 'package:kirby_port_app/component/room_item.dart';
import 'package:provider/provider.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen>
    with InfiniteScrollMixin {
  @override
  void onScroll() {
    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    roomViewModel.getRooms();
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
    return Consumer3<RoomViewModel, TopicViewModel, RoomTopicViewModel>(
      builder:
          (context, roomViewModel, topicViewModel, roomTopicViewModel, child) {
        final selectedTopicIds = topicViewModel.selectedTopicIds;
        final roomIds = roomTopicViewModel.roomTopics
            .where((roomTopic) => selectedTopicIds.contains(roomTopic.topicId))
            .map((roomTopic) => roomTopic.roomId)
            .toSet();
        final filterRooms = roomViewModel.rooms
            .where((room) =>
                selectedTopicIds.isEmpty || roomIds.contains(room.id!))
            .toList();

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount:
                      filterRooms.length + (roomViewModel.loading ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    if (roomViewModel.loading && index == filterRooms.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final room = filterRooms[index];

                    final List<int> topicIds = roomTopicViewModel.roomTopics
                        .where((roomTopic) => roomTopic.roomId == room.id!)
                        .map((roomTopic) => roomTopic.topicId)
                        .toList();
                    final List<String> topicNames = topicViewModel.topics
                        .where((topic) => topicIds.contains(topic.id!))
                        .toList()
                        .map((topic) => topic.name)
                        .toList();

                    return RoomItem(
                      room: room,
                      topicNames:
                          topicNames.isNotEmpty ? topicNames : ["Unknown"],
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
