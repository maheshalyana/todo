import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/views/task_form.dart';

import '../viewmodels/task_view_model.dart';

class TaskView extends StatelessWidget {
  final Task task;

  const TaskView({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Title:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Description:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            task.description,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Due Date:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            task.dueDate.toString(),
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Priority:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            task.priority,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Status:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            task.status,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskForm(task: task)));
                },
                child: const Text('Edit Task'),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  Provider.of<TaskViewModel>(context, listen: false)
                      .deleteTask(task)
                      .then((value) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task deleted successfully'),
                      ),
                    );
                  });
                },
                child: const Text('Delete Task'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
