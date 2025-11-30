import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/bloc/task_event.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_state.dart';
import '../widgets/task_input.dart';
import '../widgets/task_filter.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage && current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Tasks"),
        ),
        body: RefreshIndicator(
          onRefresh: () async => context.read<TaskBloc>().add(LoadTasks()),
          child: const Column(
            children: [
              TaskFilterWidget(),
              SizedBox(height: 10),
              Expanded(child: TaskList()),
              SafeArea(
                child: TaskInput(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
