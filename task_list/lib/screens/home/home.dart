import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/main.dart';
import 'package:task_list/screens/edit/cubit/edit_task_cubit.dart';
import 'package:task_list/screens/edit/edit.dart';
import 'package:task_list/screens/home/bloc/task_list_bloc.dart';
import 'package:task_list/widgets.dart';

const taskBoxName = 'task';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return BlocProvider(
      create: (context) => TaskListBloc(context.read<Repository<TaskEntity>>()),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(TaskEntity(), context.read<Repository<TaskEntity>>()),
                child: const EditTaskScreen(),
              ),
            ));
          },
          label: const Row(
            children: [Text('Create Task'), Icon(CupertinoIcons.add)],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                themedata.colorScheme.primary,
                themedata.colorScheme.primaryContainer
              ])),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Todo List',
                          style: themedata.textTheme.headlineSmall!
                              .apply(color: themedata.colorScheme.onPrimary),
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: themedata.colorScheme.onPrimary,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                            )
                          ]),
                      child: TextField(
                        onChanged: (value) {
                          context
                              .read<TaskListBloc>()
                              .add(TaskListSearch(value));
                        },
                        controller: controller,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search Tasks'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Consumer<Repository<TaskEntity>>(
                builder: (context, model, child) {
                  context.read<TaskListBloc>().add(TaskListStarted());
                  return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                    if (state is TaskListSuccess) {
                      return TaskList(items: state.items, themedata: themedata);
                    } else if (state is TaskListEmpty) {
                      return const EmptyState();
                    } else if (state is TaskListLoading ||
                        state is TaskListInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskListError) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else {
                      throw Exception('state not found');
                    }
                  });
                },
              ),
            ),
          ])),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themedata,
  });

  final List<TaskEntity> items;
  final ThemeData themedata;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Today',
                    style: themedata.textTheme.headlineSmall!
                        .apply(fontSizeFactor: 0.8),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 3,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.5),
                      color: primaryColor,
                    ),
                  )
                ]),
                MaterialButton(
                  color: const Color(0xffEAEFF5),
                  textColor: secondaryTextColor,
                  elevation: 0,
                  onPressed: () {
                    context.read<TaskListBloc>().add(TaskListDeleteAll());
                  },
                  child: const Row(
                    children: [
                      Text('Delete All'),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        CupertinoIcons.delete,
                        size: 18,
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            final TaskEntity task = items[index - 1];
            return TaskItem(
              task: task,
            );
          }
        });
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.high:
        priorityColor = highPriority;
        break;
      case Priority.medium:
        priorityColor = normalPriority;
        break;
      case Priority.low:
        priorityColor = lowPriority;
        break;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<EditTaskCubit>(
                  create: (context) => EditTaskCubit(
                      widget.task, context.read<Repository<TaskEntity>>()),
                  child: const EditTaskScreen(),
                )));
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(
          left: 16,
        ),
        height: 74,
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          MyCheckbox(
            value: widget.task.isCompleted,
            onTap: () {
              setState(() {
                widget.task.isCompleted = !widget.task.isCompleted;
              });
            },
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              widget.task.name,
              style: TextStyle(
                  fontSize: 16,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 84,
            width: 5,
            decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          )
        ]),
      ),
    );
  }
}