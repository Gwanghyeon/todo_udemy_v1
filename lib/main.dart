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
        ChangeNotifierProxyProvider<TodoList, ActiveTodoCount>(
          create: (context) => ActiveTodoCount(
            // 초기값으로 Provider에서 제공된 값으로 생성
            initialCountvalue: context.read<TodoList>().state.todoList.length,
          ),
          update:
              (context, TodoList todoList, ActiveTodoCount? activeTodoCount) =>
                  activeTodoCount!..update(todoList),
        ),
        ChangeNotifierProxyProvider3<TodoFilter, TodoSearch, TodoList,
            FilteredTodo>(
          create: (context) => FilteredTodo(
            initialFiletedTodo: context.read<TodoList>().state.todoList,
          ),
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
