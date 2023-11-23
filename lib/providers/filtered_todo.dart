// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:todo_v1/model/todo_model.dart';
import 'package:todo_v1/providers/providers.dart';

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

class FilteredTodo {
  final TodoFilter todoFilter;
  final TodoSearch todoSearch;
  final TodoList todoList;

  FilteredTodo(
      {required this.todoFilter,
      required this.todoSearch,
      required this.todoList});

  FilteredTodoState get state {
    List<Todo> _filteredTodoList;

    switch (todoFilter.state.filter) {
      case Filter.active:
        _filteredTodoList =
            todoList.state.todoList.where((todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodoList =
            todoList.state.todoList.where((todo) => todo.completed).toList();
      case Filter.all:
      default:
        _filteredTodoList = todoList.state.todoList;
        break;
    }

    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodoList = _filteredTodoList
          .where((todo) =>
              todo.desc.toLowerCase().contains(todoSearch.state.searchTerm))
          .toList();
    }
    return FilteredTodoState(filteredTodoList: _filteredTodoList);
  }
}
