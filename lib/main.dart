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
        // =====================================================
        // ChangeNotifierProxyProvider
        // value: TodoList의 값을 기준으로 ActiveTodoCount를 업데이트
        // =====================================================
        ProxyProvider<TodoList, ActiveTodoCount>(
          update: (context, TodoList todoList, _) =>
              ActiveTodoCount(todoList: todoList),
        ),
        ProxyProvider3<TodoFilter, TodoSearch, TodoList, FilteredTodo>(
          update: (context, todoFilter, todoSearch, todoList, _) =>
              FilteredTodo(
            todoFilter: todoFilter,
            todoSearch: todoSearch,
            todoList: todoList,
          ),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoPage(),
      ),
    );
  }
}
