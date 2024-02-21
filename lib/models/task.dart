import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String title;
  String description;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime dueDate;
  String priority;
  String status;
  DocumentReference? createdBy;
  DocumentReference? updatedBy;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.createdBy,
    this.updatedBy,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      dueDate: (data['due_date'] as Timestamp).toDate(),
      priority: data['priority'] ?? '',
      status: data['status'] ?? '',
      createdBy: data['created_by'],
      updatedBy: data['updated_by'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'due_date': dueDate,
      'priority': priority,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}
