import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_list/data/data.dart';

import 'package:task_list/main.dart';
import 'package:task_list/screens/edit/cubit/edit_task_cubit.dart';

const taskBoxName = 'task';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({
    super.key,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themedata = Theme.of(context);
    return Scaffold(
      backgroundColor: themedata.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themedata.colorScheme.surface,
        foregroundColor: Colors.black,
        title: const Text('Edit Tasks'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Row(
            children: [Text('Create Task'), Icon(CupertinoIcons.check_mark)]),
        onPressed: () {
          context.read<EditTaskCubit>().onSaveChangesClicked();
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        child: PriorityCheckBox(
                            ontap: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.low);
                            },
                            label: 'Low',
                            isSelected: priority == Priority.low,
                            color: lowPriority)),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: PriorityCheckBox(
                            ontap: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.medium);
                            },
                            label: 'Medium',
                            isSelected: priority == Priority.medium,
                            color: normalPriority)),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: PriorityCheckBox(
                            ontap: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.high);
                            },
                            label: 'High',
                            isSelected: priority == Priority.high,
                            color: highPriority)),
                    const SizedBox(
                      width: 8,
                    )
                  ],
                );
              },
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<EditTaskCubit>().onTextChanged(value);
              },
              decoration: InputDecoration(
                label: Text(
                  'Add task for today...',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(fontSizeFactor: 1.2),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final GestureTapCallback ontap;
  final bool isSelected;
  final Color color;
  const PriorityCheckBox(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.color,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                width: 2, color: secondaryTextColor.withOpacity(0.2))),
        child: Stack(
          children: [
            Center(
              child: Text(label,
                  style: themeData.textTheme.bodyMedium!
                      .apply(fontSizeFactor: 0.8)),
            ),
            Positioned(
                right: 4,
                top: 0,
                bottom: 0,
                child: Center(
                    child: _MyCheckBoxShape(value: isSelected, color: color))),
          ],
        ),
      ),
    );
  }
}

//defualt check box
class _MyCheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const _MyCheckBoxShape({ required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                size: 12,
                color: themeData.colorScheme.onPrimary,
              )
            : null);
  }
}
