// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_v1/model/todo_model.dart';
import 'package:todo_v1/providers/providers.dart';

// ============================
// Container showing Todo Item
// todo 를 받아 위젯에 표시
// ============================

class TodoContainer extends StatefulWidget {
  final Todo todo;
  const TodoContainer({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoContainer> createState() => _TodoContainerState();
}

class _TodoContainerState extends State<TodoContainer> {
  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    // TODO: 할일 내용을 편집하는 기능 chapter 50
    return ListTile(
      leading: Checkbox(
        value: todo.completed,
        onChanged: (_) {
          context.read<TodoList>().toggleTodo(todo.id);
        },
      ),
      title: Text(todo.desc),
    );
  }
}
