import 'package:flutter/material.dart';

class TopicContainer extends StatefulWidget {
  const TopicContainer({
    super.key,
    required this.text,
    required this.isSelected,
    this.badgeNumber,
  });

  final String text;
  final bool isSelected;
  final int? badgeNumber;

  @override
  State<TopicContainer> createState() => _TopicContainerState();
}

class _TopicContainerState extends State<TopicContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IntrinsicWidth(
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
              color: widget.isSelected ? Colors.red[900] : Colors.white.withOpacity(0.15),
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
        ),
        if (widget.badgeNumber != null)
          Positioned(
            right: -6,
            bottom: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Center(
                child: Text(
                  widget.badgeNumber.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
