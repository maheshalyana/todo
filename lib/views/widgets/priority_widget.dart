import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PriorityWidget extends StatelessWidget {
  PriorityWidget({super.key, required this.priority});
  String priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: priority == 'High'
            ? Colors.redAccent
            : priority == 'Medium'
                ? Colors.orangeAccent
                : Colors.greenAccent,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
