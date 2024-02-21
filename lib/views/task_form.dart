import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';

// ignore: must_be_immutable
class TaskForm extends StatefulWidget {
  Task? task;

  TaskForm({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _status = 'Todo';
  String _priority = 'Low';

  @override
  void initState() {
    super.initState();

    // Initialize form fields with task data if provided
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDateController.text = widget.task!.dueDate.toLocal().toString();
      _status = widget.task!.status;
      _priority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task?.id == null ? 'Create Task' : 'Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Title is required'),
                    MinLengthValidator(3,
                        errorText: 'Title must be at least 3 characters long'),
                  ]),
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Description is required'),
                    MinLengthValidator(10,
                        errorText:
                            'Description must be at least 10 characters long'),
                  ]),
                  maxLines: 3,
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dueDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedDate != null) {
                      pickedDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime!.hour,
                        pickedTime.minute,
                      );
                      _dueDateController.text = pickedDate.toString();
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Due Date'),
                ),
                const SizedBox(height: 16),
                const Text('Status:'),
                ToggleButtons(
                  isSelected: _statusButtonsSelected(),
                  onPressed: (index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < _statusButtonsSelected().length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          _statusButtonsSelected()[buttonIndex] =
                              !_statusButtonsSelected()[buttonIndex];
                        } else {
                          _statusButtonsSelected()[buttonIndex] = false;
                        }
                      }
                      _status = _getStatusFromIndex(index);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  children: [
                    'Todo',
                    'In-Progress',
                    'Done',
                  ]
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text('Priority:'),
                ToggleButtons(
                  isSelected: _priorityButtonsSelected(),
                  onPressed: (index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < _priorityButtonsSelected().length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          _priorityButtonsSelected()[buttonIndex] =
                              !_priorityButtonsSelected()[buttonIndex];
                        } else {
                          _priorityButtonsSelected()[buttonIndex] = false;
                        }
                      }
                      _priority = _getPriorityFromIndex(index);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  children: [
                    'Low',
                    'Medium',
                    'High',
                  ]
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) _saveTask(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text('Save Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<bool> _statusButtonsSelected() {
    return [
      _status == 'Todo',
      _status == 'In-Progress',
      _status == 'Done',
    ];
  }

  List<bool> _priorityButtonsSelected() {
    return [
      _priority == 'Low',
      _priority == 'Medium',
      _priority == 'High',
    ];
  }

  String _getStatusFromIndex(int index) {
    return index == 0 ? 'Todo' : (index == 1 ? 'In-Progress' : 'Done');
  }

  String _getPriorityFromIndex(int index) {
    return index == 0 ? 'Low' : (index == 1 ? 'Medium' : 'High');
  }

  void _saveTask(BuildContext context) {
    // Saving Form Data
    widget.task!.title = _titleController.text;
    widget.task!.description = _descriptionController.text;
    widget.task!.dueDate = DateTime.parse(_dueDateController.text);
    widget.task!.status = _status;
    widget.task!.priority = _priority;

    // Save the task in Firestore data source
    TaskViewModel taskViewModel = TaskViewModel();
    taskViewModel.saveTask(widget.task!);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }
}
