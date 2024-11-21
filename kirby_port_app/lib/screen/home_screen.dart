import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kirby_port_app/screen/my_room_screen.dart';
import 'package:kirby_port_app/screen/room_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KriBy - Port"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_alt_outlined,
                color: Colors.red[900],
                size: 30,
              ),
              onPressed: () => context.push("/home/topic-filter")),
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.red[900],
                size: 30,
              ),
              onPressed: () => context.push("/home/create-room")),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          RoomListScreen(),
          MyRoomScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "마이"),
        ],
      ),
    );
  }
}
