import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_state.dart';
import 'animated_task_card.dart';
import 'empty_state.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state.status == TaskStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = state.filteredTasks;

        if (tasks.isEmpty && state.status == TaskStatus.success) {
           return const EmptyState();
        }

        // Filter Switch Animation
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: ListView.builder(
            key: ValueKey<Object>(state.filter), // Triggers switch when filter changes
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return AnimatedTaskCard(
                key: ValueKey(task.id),
                task: task,
              );
            },
          ),
        );
      },
    );
  }
}
