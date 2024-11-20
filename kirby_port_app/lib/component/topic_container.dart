import 'package:flutter/material.dart';

class TopicContainer extends StatefulWidget {
  const TopicContainer({
    super.key,
    required this.text,
    required this.isSelected,
  });

  final String text;
  final bool isSelected;

  @override
  State<TopicContainer> createState() => _TopicContainerState();
}

class _TopicContainerState extends State<TopicContainer> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // height: 50,
        // width: 100,
        // constraints: const BoxConstraints(
        //   minWidth: 50, // 최소 너비
        //   minHeight: 30, // 최소 높이
        // ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.red : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
            child: Text(
          "# ${widget.text}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.isSelected ? Colors.white : Colors.black,
          ),
        )),
      ),
    );
  }
}
