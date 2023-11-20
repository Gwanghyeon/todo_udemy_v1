import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_v1/pages/todo_page.dart';
import 'package:todo_v1/providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoFilter>(
          create: (context) => TodoFilter(),
        ),
        ChangeNotifierProvider<TodoSearch>(
          create: (context) => TodoSearch(),
        ),
        ChangeNotifierProvider<TodoList>(
          create: (context) => TodoList(),
        ),
        ChangeNotifierProxyProvider<TodoList, ActiveTodoCount>(
          create: (context) => ActiveTodoCount(),
          update:
              (context, TodoList todoList, ActiveTodoCount? activeTodoCount) =>
                  activeTodoCount!..update(todoList),
        ),
        ChangeNotifierProxyProvider3<TodoFilter, TodoSearch, TodoList,
            FilteredTodo>(
          create: (context) => FilteredTodo(),
          update: (context, todoFilter, todoSearch, todoList, filteredTodo) =>
              filteredTodo!..update(todoFilter, todoSearch, todoList),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoPage(),
      ),
    );
  }
}
