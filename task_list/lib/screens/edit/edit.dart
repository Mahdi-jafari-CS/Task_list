import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/main.dart';

const taskBoxName = 'task';

class EditTaskScreen extends StatefulWidget {
  EditTaskScreen({super.key, required this.task});

  final TaskEntity task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

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
        label: Row(children: [
          const Text('Create Task'),
          Icon(CupertinoIcons.check_mark)
        ]),
        onPressed: () {
          widget.task.name = _controller.text;
          widget.task.priority = widget.task.priority;
          final repository = Provider.of<Repository<TaskEntity>>(context,listen: false);
          repository.createOrUpdate(widget.task);
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                    child: PriorityCheckBox(
                        ontap: () {
                          setState(() {
                            widget.task.priority = Priority.low;
                          });
                        },
                        label: 'Low',
                        isSelected: widget.task.priority == Priority.low,
                        color: lowPriority)),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: PriorityCheckBox(
                        ontap: () {
                          setState(() {
                            widget.task.priority = Priority.medium;
                          });
                        },
                        label: 'Medium',
                        isSelected: widget.task.priority == Priority.medium,
                        color: normalPriority)),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: PriorityCheckBox(
                        ontap: () {
                          setState(() {
                            widget.task.priority = Priority.high;
                          });
                        },
                        label: 'High',
                        isSelected: widget.task.priority == Priority.high,
                        color: highPriority)),
                SizedBox(
                  width: 8,
                )
              ],
            ),
            TextField(
              controller: _controller,
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

  const _MyCheckBoxShape({super.key, required this.value, required this.color});

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
