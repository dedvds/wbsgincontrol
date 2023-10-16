import 'package:flutter/material.dart';

import '../entities/grocery.dart';

class GroceryListTile extends StatelessWidget {
  final Grocery grocery;
  final VoidCallback? toggle;
  final VoidCallback? delete;

  const GroceryListTile({
    Key? key,
    required this.grocery,
    this.toggle,
    this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(grocery.id),
      leading: IconButton(
        icon: Icon(
          grocery.isComplete
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
        grocery.content,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              decoration: grocery.isComplete
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
      ),
    );
  }
}
