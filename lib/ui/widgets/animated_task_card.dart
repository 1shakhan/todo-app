import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/task.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import 'task_item.dart';

class AnimatedTaskCard extends StatefulWidget {
  final Task task;

  const AnimatedTaskCard({super.key, required this.task});

  @override
  State<AnimatedTaskCard> createState() => _AnimatedTaskCardState();
}

class _AnimatedTaskCardState extends State<AnimatedTaskCard> {
  bool _isVisible = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // Fade-In on Insert
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  void _handleDelete() async {
    // Fade-Out on Delete
    setState(() {
      _isVisible = false;
    });

    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      context.read<TaskBloc>().add(DeleteTask(widget.task.id));
    }
  }

  void _handleReturn() async {
    // Fade-Out on Delete
    setState(() {
      _isVisible = false;
    });

    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      context.read<TaskBloc>().add(ReturnTask(widget.task.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: _isHovered ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
          child: TaskItem(
            task: widget.task,
            onRemove: widget.task.isDeleted ? _handleReturn : _handleDelete,
          ),
        ),
      ),
    );
  }
}
