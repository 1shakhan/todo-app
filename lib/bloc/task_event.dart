import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class ToggleTaskCompletion extends TaskEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ReturnTask extends TaskEvent {
  final String taskId;

  const ReturnTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

enum TaskFilter { all, completed, notCompleted, deleted }

class FilterChanged extends TaskEvent {
  final TaskFilter filter;

  const FilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}
