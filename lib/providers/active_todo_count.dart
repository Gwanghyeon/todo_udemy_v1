import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_v1/providers/todo_list.dart';

class ActiveTodoCountState extends Equatable {
  final int activeTodoCount;

  const ActiveTodoCountState({
    required this.activeTodoCount,
  });

  factory ActiveTodoCountState.initial() {
    // activeTodoCount: ProxyProvider 에 의해 앱 시작시 바로 update
    return const ActiveTodoCountState(activeTodoCount: 0);
  }

  @override
  List<Object> get props => [activeTodoCount];

  @override
  bool get stringify => true;

  ActiveTodoCountState copyWith({int? activeTodoCount}) {
    return ActiveTodoCountState(
        activeTodoCount: activeTodoCount ?? this.activeTodoCount);
  }
}

// ==================================
// ActiveTodoCountState를 관리하는 클래스
// ==================================
class ActiveTodoCount with ChangeNotifier {
  late ActiveTodoCountState _state;
  final int initialCountvalue;

  ActiveTodoCount({required this.initialCountvalue}) {
    _state = ActiveTodoCountState(activeTodoCount: initialCountvalue);
  }

  ActiveTodoCountState get state => _state;

  void update(TodoList todoList) {
    // using ProxyProvider : todoList의 값이 변할때마다 호출
    final int newActiveTodoCount = todoList.state.todoList
        // Returning the todo items where the completed value is false
        .where((todo) => !todo.completed)
        .toList()
        .length;

    _state = _state.copyWith(activeTodoCount: newActiveTodoCount);
    notifyListeners();
  }
}
