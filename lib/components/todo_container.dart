// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
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
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    // Text Editing
    // editing via dialog
    return ListTile(
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            bool _error = false;
            // 초기값으로 해당 Todo의 내용을 표시
            textEditingController.text = todo.desc;

            // Dialog 내에서 State Handling -> StatefulBuilder 필요
            return StatefulBuilder(
              builder: (context, setState) {
                return CupertinoAlertDialog(
                  title: Text('Edit Todo'),
                  content: TextField(
                    controller: textEditingController,
                    autofocus: true,
                    decoration: InputDecoration(
                      errorText: _error ? 'Enter Contents of Todo' : null,
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('CANCEL')),
                    TextButton(
                        onPressed: () {
                          // error 발생 시 validation error를 표시하기 위한 setState
                          setState(
                            () {
                              _error = textEditingController.text.isEmpty
                                  ? true
                                  : false;
                              if (!_error) {
                                context.read<TodoList>().editTodo(
                                    todo.id, textEditingController.text);
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                        child: Text('EDIT')),
                  ],
                );
              },
            );
          },
        );
      },
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
