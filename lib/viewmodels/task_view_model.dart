import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share/flutter_share.dart';

import '../models/task.dart';

class TaskViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Task> tasks = [];

  List<Task> getTasks() {
    return tasks;
  }

  // Function to fetch tasks from Firestore
  Future<void> fetchTasks(String taskType) async {
    User? user = _auth.currentUser;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection(taskType)
          .get();
      tasks = await Future.wait(querySnapshot.docs.map((doc) async {
        return Task.fromFirestore(await doc['task'].get());
      }));

      notifyListeners();
    } catch (error) {
      print("Error fetching tasks: $error");
    }
  }

  // Function to toggle the status of a task
  Future<void> toggleTaskStatus(Task task) async {
    try {
      String newStatus = task.status == 'Todo'
          ? 'In-Progress'
          : task.status == 'In-Progress'
              ? 'Done'
              : 'Todo';

      await _firestore.collection('tasks').doc(task.id).update({
        'status': newStatus,
        'updatedAt': DateTime.now(),
        'updatedBy': _firestore.collection('users').doc(_auth.currentUser!.uid)
      });

      int index = tasks.indexWhere((t) => t.id == task.id);
      tasks[index].status = newStatus;

      notifyListeners();
    } catch (error) {
      print("Error toggling task status: $error");
    }
  }

  // Function to toggle the priority of a task
  Future<void> toggleTaskPriority(Task task) async {
    try {
      String newPriority = task.priority == 'Low'
          ? 'Medium'
          : task.priority == 'Medium'
              ? 'High'
              : 'Low';

      await _firestore.collection('tasks').doc(task.id).update({
        'priority': newPriority,
        'updatedAt': DateTime.now(),
        'updatedBy': _firestore.collection('users').doc(_auth.currentUser!.uid)
      });

      int index = tasks.indexWhere((t) => t.id == task.id);
      tasks[index].priority = newPriority;

      notifyListeners();
    } catch (error) {
      print("Error toggling task priority: $error");
    }
  }

  // Function to Save a new task or update an existing task
  Future<void> saveTask(Task task) async {
    try {
      User? user = _auth.currentUser;
      DocumentReference updatedBy =
          _firestore.collection('users').doc(user!.uid);
      print("Updated by: $updatedBy");
      task.updatedBy = updatedBy;
      task.updatedAt = DateTime.now();
      if (task.id == null) {
        DocumentReference createdBy =
            _firestore.collection('users').doc(user.uid);
        task.createdBy = createdBy;
        task.createdAt = DateTime.now();

        DocumentReference docRef =
            await _firestore.collection('tasks').add(task.toMap());
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc(task.id)
            .set({
          'task': docRef,
        });
        task.id = docRef.id;

        tasks.add(task);
      } else {
        // Update existing task
        task.updatedAt = DateTime.now();
        await _firestore.collection('tasks').doc(task.id).update(task.toMap());

        int index = tasks.indexWhere((t) => t.id == task.id);
        tasks[index] = task;
      }

      notifyListeners();
    } catch (error) {
      print("Error saving task: $error");
    }
  }

  // Function to delete a task
  Future<void> deleteTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).delete();
      tasks.removeWhere((t) => t.id == task.id);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .where('task', isEqualTo: _firestore.collection('tasks').doc(task.id))
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });

      notifyListeners();
    } catch (error) {
      print("Error deleting task: $error");
    }
  }

  Future<String> generateDynamicLink(String taskId) async {
    try {
      final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: "https://tododynamic.page.link",
        link: Uri.parse("https://tododynamic.page.link/task?taskId=$taskId"),
        androidParameters:
            const AndroidParameters(packageName: "com.example.todo"),
      );
      final dynamicLink = FirebaseDynamicLinks.instance;
      final dynamicUrl = await dynamicLink.buildShortLink(dynamicLinkParams);
      FlutterShare.share(
        title: "Share Task",
        text: "Check out this task",
        linkUrl: dynamicUrl.shortUrl.toString(),
      );
      return dynamicUrl.shortUrl.toString();
    } catch (e) {
      return "Error generating dynamic link: $e";
    }
  }

  Future<void> joinSharedTask(String taskId) async {
    try {
      User? user = _auth.currentUser;
      DocumentReference taskRef = _firestore.collection('tasks').doc(taskId);
      QuerySnapshot sharedTasksSnapshot = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('shared_tasks')
          .where('task', isEqualTo: taskRef)
          .get();

      if (sharedTasksSnapshot.docs.isEmpty) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('shared_tasks')
            .add({
          'task': taskRef,
        });
      } else {
        throw Exception("Task already shared with user");
      }

      taskRef.collection('shared_with').add({
        'user': _firestore.collection('users').doc(user.uid),
      });

      notifyListeners();
    } catch (error) {
      throw Exception("Error joining shared task: $error");
    }
  }
}
