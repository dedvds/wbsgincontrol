import 'package:flutter/material.dart';

import '../entities/plan.dart';

class PlanListTile extends StatelessWidget {
  final Plan plan;
  final VoidCallback? toggle;
  final VoidCallback? delete;

  const PlanListTile({
    Key? key,
    required this.plan ,
    this.toggle,
    this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(plan.id),
      leading: IconButton(
        icon: Icon(
          plan.isComplete
              ? Icons.check_box
              : Icons.check_box_outline_blank_rounded,
          color: const Color.fromRGBO(16, 185, 129, 1),
        ),
        onPressed: toggle,
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete_outline,
          color: Color.fromRGBO(239, 68, 68, 1),
        ),
        onPressed: delete,
      ),
      dense: true,
      title: Text(
        plan.content,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              decoration: plan.isComplete
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
      ),
    );
  }
}
