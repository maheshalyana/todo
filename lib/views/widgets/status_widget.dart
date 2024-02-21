import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StatusWidget extends StatelessWidget {
  StatusWidget({super.key, required this.status});
  String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: status == 'Todo'
              ? Colors.grey
              : status == 'In-Progress'
                  ? Colors.blueAccent
                  : Colors.green,
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
