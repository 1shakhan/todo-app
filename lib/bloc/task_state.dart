import 'package:equatable/equatable.dart';
import '../models/task.dart';
import 'task_event.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<Task> tasks;
  final TaskFilter filter;
  final String? errorMessage;

  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.filter = TaskFilter.all,
    this.errorMessage,
  });

  List<Task> get filteredTasks {
    switch (filter) {
      case TaskFilter.completed:
        return tasks.where((task) => task.isDone && !task.isDeleted).toList();
      case TaskFilter.notCompleted:
        return tasks.where((task) => !task.isDone && !task.isDeleted).toList();
      case TaskFilter.all:
        return tasks.where((task) => !task.isDeleted).toList();
      case TaskFilter.deleted:
        return tasks.where((task) => task.isDeleted).toList();
    }
  }

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? tasks,
    TaskFilter? filter,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tasks, filter, errorMessage];
}
