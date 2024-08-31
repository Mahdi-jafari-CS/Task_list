import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_list/main.dart';

class MyCheckbox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const MyCheckbox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border:
                !value ? Border.all(color: secondaryTextColor, width: 2) : null,
            color: value ? themeData.colorScheme.primary : null,
          ),
          child: value
              ? Icon(
                  CupertinoIcons.check_mark,
                  size: 16,
                  color: themeData.colorScheme.onPrimary,
                )
              : null),
    );
  }
}
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/empty_state.svg',
          width: 120,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text('Your task list is Empty dear'),
      ],
    );
  }
}
