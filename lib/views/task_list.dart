import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/viewmodels/user_view_model.dart';
import 'package:todo/views/auth_view.dart';
import 'package:todo/views/task_view.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';
import 'task_form.dart';
import 'widgets/priority_widget.dart';
import 'widgets/status_widget.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String selectedTaskType = 'tasks';

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<TaskViewModel>(context).fetchTasks(selectedTaskType);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Provider.of<TaskViewModel>(context).dispose();
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = Provider.of<TaskViewModel>(context).getTasks();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text('ToDo'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<UserViewModel>(context, listen: false)
                    .signOut()
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false));
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskForm(
                task: Task(
                    description: '',
                    title: '',
                    dueDate: DateTime.now(),
                    priority: 'Low',
                    status: 'Todo'),
              );
            }));
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                tabs: ['tasks', 'shared_tasks'].map((taskType) {
                  return Tab(
                    text: taskType == 'tasks'
                        ? 'My Tasks'
                        : 'Collaboration Tasks',
                  );
                }).toList(),
                onTap: (index) {
                  setState(() {
                    selectedTaskType = index == 0 ? 'tasks' : 'shared_tasks';
                    Provider.of<TaskViewModel>(context, listen: false)
                        .fetchTasks(selectedTaskType);
                  });
                },
              ),
              SizedBox(
                height: height * 0.7,
                width: width,
                child: TabBarView(
                  controller: tabController,
                  children: ['tasks', 'shared_tasks'].map((selectedTaskType) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: tasks.isEmpty
                            ? [
                                Icon(
                                  Icons.hourglass_empty_rounded,
                                  size: 100,
                                ),
                                Center(child: const Text('No tasks available'))
                              ]
                            : tasks.map((task) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                  height: height * 0.65,
                                                  child: TaskView(
                                                    task: task,
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      title: Row(
                                        children: [
                                          Text(task.title),
                                          IconButton(
                                            onPressed: () {
                                              Provider.of<TaskViewModel>(
                                                      context,
                                                      listen: false)
                                                  .generateDynamicLink(
                                                      task.id!);
                                            },
                                            icon: const Icon(Icons.share),
                                          )
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(task.description),
                                          Wrap(
                                            children: [
                                              const Text(
                                                'Due Date:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year} by ${task.dueDate.hour}:${task.dueDate.minute}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Provider.of<TaskViewModel>(
                                                      context,
                                                      listen: false)
                                                  .toggleTaskStatus(task);
                                            },
                                            child: StatusWidget(
                                              status: task.status,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: () {
                                              Provider.of<TaskViewModel>(
                                                      context,
                                                      listen: false)
                                                  .toggleTaskPriority(task);
                                            },
                                            child: PriorityWidget(
                                              priority: task.priority,
                                            ),
                                          ),
                                        ],
                                      ),
                                      isThreeLine: true,
                                    ),
                                    SizedBox(
                                        width: width * 0.8,
                                        child: const Divider()),
                                  ],
                                );
                              }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
