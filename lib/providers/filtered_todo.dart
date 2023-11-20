// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_v1/model/todo_model.dart';
import 'package:todo_v1/providers/todo_filter.dart';
import 'package:todo_v1/providers/todo_list.dart';
import 'package:todo_v1/providers/todo_search.dart';

// ==========================================
// 상태관리가 필요한 자료를 담는 클래스 생성
// 1. State Class
// 2. factory 생성자를 활용하여 인스턴스 관리
// 3. copyWith 함수를 통한 갱신처리
// 해당 상태를 리슨하는 클래스 생성
// 1. 해당 클래스를 프로바이더의 인자로 제공
// 2. update를 통해 proxyProvider에 제공
// ==========================================

// ==========================================
// 사용자가 직접 접근하는 항목들의 상태관리를 위한 클래스
// 추가, 삭제, 완료 상태 변경
// ==========================================
class FilteredTodoState extends Equatable {
  final List<Todo> filteredTodoList;

  const FilteredTodoState({required this.filteredTodoList});

  factory FilteredTodoState.initial() {
    return const FilteredTodoState(filteredTodoList: []);
  }

  @override
  List<Object> get props => [filteredTodoList];

  @override
  bool get stringify => true;

  FilteredTodoState copyWith({
    List<Todo>? filteredTodoList,
  }) {
    return FilteredTodoState(
      filteredTodoList: filteredTodoList ?? this.filteredTodoList,
    );
  }
}

class FilteredTodo with ChangeNotifier {
  FilteredTodoState _state = FilteredTodoState.initial();
  FilteredTodoState get state => _state;

  // list, filter value, searchTerm 에 대한 정보가 필요함
  // using ProxyProvider: 의존값을 처음으로 얻을 때, 변경될 때마다 호출
  void update(TodoFilter todoFilter, TodoSearch todoSearch, TodoList todoList) {
    List<Todo> filteredTodoList;

    switch (todoFilter.state.filter) {
      case Filter.active:
        filteredTodoList =
            todoList.state.todoList.where((todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        filteredTodoList =
            todoList.state.todoList.where((todo) => todo.completed).toList();
      case Filter.all:
      default:
        filteredTodoList = todoList.state.todoList;
        break;
    }

    if (todoSearch.state.searchTerm.isNotEmpty) {
      filteredTodoList = filteredTodoList
          .where((todo) =>
              todo.desc.toLowerCase().contains(todoSearch.state.searchTerm))
          .toList();
    }

    _state = _state.copyWith(filteredTodoList: filteredTodoList);
    notifyListeners();
  }
}
