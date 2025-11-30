import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../services/task_storage_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskStorageService _storageService;

  TaskBloc(this._storageService) : super(const TaskState()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<DeleteTask>(_onDeleteTask);
    on<ReturnTask>(_onReturnTask);
    on<FilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = await _storageService.loadTasks();
      emit(state.copyWith(
        status: TaskStatus.success,
        tasks: tasks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.failure,
        errorMessage: 'Failed to load tasks',
      ));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state.tasks.any((task) => task.title == event.task.title)) {
      // Ideally we should have a way to signal one-off errors (like SnackBar),
      // but here we might set an error message in state or rely on UI to validate before adding.
      // However, requirements say "Prevent Duplicate titles (show SnackBar error if happened)".
      // Setting errorMessage in state is one way, or we could have a specific side effect stream.
      // For simplicity, I will set errorMessage which the UI can listen to.
      emit(state.copyWith(errorMessage: "Task already exists"));
      // Clear error immediately after? Or let UI handle it.
      // A better approach for "single-shot" events is often using a Listener, but putting it in state works if we clear it.
      // Note: Setting it to null immediately might race condition if not handled carefully,
      // but since Bloc processes events sequentially, the listener in UI will likely see the change.
      // However, to be safe, we can just emit the error, and the UI can show it.
      // The UI listener 'listenWhen' checks if error changed and is not null.
      // If we emit null immediately, the listener might miss it or fire twice if we are not careful.
      // A common pattern is to emit the error, then emit a clean state, OR have the UI reset it.
      // Here, I'll rely on the fact that if I emit state with error, then immediately state with null error,
      // the UI BlocListener will trigger for the state with error.
      emit(state.copyWith(errorMessage: null));
      return;
    }

    final newTasks = List<Task>.from(state.tasks)..add(event.task);
    await _storageService.saveTasks(newTasks);
    emit(state.copyWith(
      tasks: newTasks,
      status: TaskStatus.success,
    ));
  }

  Future<void> _onToggleTaskCompletion(ToggleTaskCompletion event, Emitter<TaskState> emit) async {
    final newTasks = state.tasks.map((task) {
      if (task.id == event.taskId) {
        return task.copyWith(isDone: !task.isDone);
      }
      return task;
    }).toList();

    await _storageService.saveTasks(newTasks);
    emit(state.copyWith(tasks: newTasks));
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    final newTasks = state.tasks.map((task) {
      if (task.id == event.taskId) {
        return task.copyWith(isDeleted: true);
      }
      return task;
    }).toList();
    await _storageService.saveTasks(newTasks);
    emit(state.copyWith(tasks: newTasks));
  }

  Future<void> _onReturnTask(ReturnTask event, Emitter<TaskState> emit) async {
    final newTasks = state.tasks.map((task) {
      if (task.id == event.taskId) {
        return task.copyWith(isDeleted: false);
      }
      return task;
    }).toList();
    await _storageService.saveTasks(newTasks);
    emit(state.copyWith(tasks: newTasks));
  }

  void _onFilterChanged(FilterChanged event, Emitter<TaskState> emit) {
    emit(state.copyWith(filter: event.filter));
  }
}
