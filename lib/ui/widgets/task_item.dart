import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onRemove;

  const TaskItem({
    super.key,
    required this.task,
    required this.onRemove,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      onRemove();
    }
  }

  @override
  Widget build(BuildContext context) {
    // We remove the Slidable from here? Or keep it?
    // The instructions say "Fade-Out on Delete... On delete tap: setState(isVisible=false)..."
    // If Slidable is here, it will slide, then delete.
    // If we want the WHOLE row to fade out, Slidable needs to be inside the AnimatedOpacity in parent.
    // Yes, this is correct.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Slidable(
        key: ValueKey(task.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _confirmDelete(context),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: task.isDeleted
                ? null
                : AnimatedOpacity(
                    opacity: task.isDone ? 1.0 : 0.6, // Checkbox always visible, maybe check icon fade?
                    // The requirements say: "Completed state: ... show check icon fade. Uncompleted: ... fade icon out"
                    // But Checkbox handles its own icon.
                    // "Optional check icon fade: AnimatedOpacity(... child: Icon(Icons.check_circle_rounded)...)"
                    // I will stick to standard Checkbox for now but wrap the whole ListTile content if needed?
                    // Actually, standard Checkbox is fine, but let's implement the TITLE animation requested.
                    duration: const Duration(milliseconds: 300),
                    child: Checkbox(
                      value: task.isDone,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      onChanged: (_) {
                        context.read<TaskBloc>().add(ToggleTaskCompletion(task.id));
                      },
                    ),
                  ),
            title: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
                color: task.isDone ? Colors.grey : Colors.black87,
              ),
              child: Text(task.title),
            ),
            trailing: task.isDeleted
                ? IconButton(
                    icon: const Icon(CupertinoIcons.return_icon),
                    color: Colors.green,
                    onPressed: onRemove,
                  )
                : IconButton(
                    icon: const Icon(CupertinoIcons.delete, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(context),
                  ),
          ),
        ),
      ),
    );
  }
}
