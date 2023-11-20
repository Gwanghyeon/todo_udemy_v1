// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_v1/model/todo_model.dart';

class TodoListState extends Equatable {
  final List<Todo> todoList;

  const TodoListState({required this.todoList});

  factory TodoListState.initial() {
    return TodoListState(todoList: [
      Todo(id: '1', desc: 'Clean the room'),
      Todo(id: '2', desc: 'Wash the dish'),
      Todo(id: '3', desc: 'Do homework'),
    ]);
  }

  @override
  List<Object> get props => [todoList];

  @override
  bool get stringify => true;

  TodoListState copyWith({
    List<Todo>? todoList,
  }) {
    return TodoListState(
      todoList: todoList ?? this.todoList,
    );
  }
}

class TodoList with ChangeNotifier {
  TodoListState _state = TodoListState.initial();
  TodoListState get state => _state;

  // =============================
  // Add new Todo item in the list
  // =============================
  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);
    final newTodoList = [..._state.todoList, newTodo];

    _state = _state.copyWith(todoList: newTodoList);
    notifyListeners();
  }

  // ===========================
  //  Edit description of Todo
  // ===========================
  void editTodo(String id, String newDesc) {
    final newTodoList = _state.todoList.map((todo) {
      if (todo.id == id) {
        return Todo(id: id, desc: newDesc, completed: todo.completed);
      }
      return todo;
    }).toList();

    _state = _state.copyWith(todoList: newTodoList);
    notifyListeners();
  }

  // ===================================
  // Toggle isCompleted variable in Todo
  // ===================================
  void toggleTodo(String id) {
    final newTodoList = _state.todoList.map((todo) {
      if (todo.id == id) {
        return Todo(id: id, desc: todo.desc, completed: !todo.completed);
      }
      return todo;
    }).toList();

    _state = _state.copyWith(todoList: newTodoList);
  }

  // ==============================
  // Remove Todo Item in Todo List
  // ==============================
  void removeTodo(Todo targetTodo) {
    final newTodoList =
        _state.todoList.where((todo) => todo.id != targetTodo.id).toList();

    _state = _state.copyWith(todoList: newTodoList);
    notifyListeners();
  }
}
