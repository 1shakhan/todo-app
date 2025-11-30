import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';

class TaskFilterWidget extends StatelessWidget {
  const TaskFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentFilter = context.select((TaskBloc bloc) => bloc.state.filter);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SegmentedButton<TaskFilter>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(
            value: TaskFilter.all,
            label: Text('All', maxLines: 1),
          ),
          ButtonSegment(
            value: TaskFilter.completed,
            label: Text('Done', maxLines: 1),
          ),
          ButtonSegment(
            value: TaskFilter.notCompleted,
            label: Text('Pending', maxLines: 1),
          ),
          ButtonSegment(
            value: TaskFilter.deleted,
            label: Text('Deleted', maxLines: 1),
          ),
        ],
        selected: {currentFilter},
        onSelectionChanged: (Set<TaskFilter> newSelection) {
          context.read<TaskBloc>().add(FilterChanged(newSelection.first));
        },
      ),
    );
  }
}
