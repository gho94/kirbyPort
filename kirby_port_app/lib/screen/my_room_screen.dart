import 'package:flutter/material.dart';
import 'package:kirby_port_app/view_model/room_topic_view_model.dart';
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
  Map<int, String> topicIdToName = {};

  @override
  void onScroll() {
    final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
    roomViewModel.getMyRooms();
  }

  @override
  void initState() {
    super.initState();
    initScrollListener();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        final roomViewModel = Provider.of<RoomViewModel>(context, listen: false);
        final selectedTopicIds = Provider.of<TopicViewModel>(context, listen: false).selectedTopicIds;
        selectedTopicIds.isEmpty ? roomViewModel.getMyRooms() : roomViewModel.getFilteredMyRooms(selectedTopicIds);
      }
    });
  }

  @override
  void dispose() {
    disposeScrollListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<RoomViewModel, TopicViewModel, RoomTopicViewModel>(
      builder: (context, roomViewModel, topicViewModel, roomTopicViewModel, child) {
        topicIdToName.addEntries(topicViewModel.topics.map((topic) => MapEntry(topic.id!, topic.name)));

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: roomViewModel.rooms.length + (roomViewModel.loading ? 1 : 0),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    if (roomViewModel.loading && index == roomViewModel.rooms.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final room = roomViewModel.rooms[index];
                    final List<String> topicNames = roomTopicViewModel.roomTopics
                        .where((roomTopic) => roomTopic.roomId == room.id!)
                        .map((roomTopic) => topicIdToName[roomTopic.topicId] ?? "Unknown")
                        .toList();

                    return RoomItem(
                      room: room,
                      topicNames: topicNames.isNotEmpty ? topicNames : ["Unknown"],
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
