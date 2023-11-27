// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';
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

class FilteredTodo extends StateNotifier<FilteredTodoState> with LocatorMixin {
  FilteredTodo() : super(FilteredTodoState.initial());

  // list, filter value, searchTerm 에 대한 정보가 필요함
  // using ProxyProvider: 의존값을 처음으로 얻을 때, 변경될 때마다 호출
  @override
  void update(Locator watch) {
    final todoList = watch<TodoListState>().todoList;
    final currentFilter = watch<TodoFilterState>().filter;
    final searchTerm = watch<TodoSearchState>().searchTerm;

    List<Todo> filteredTodoList;

    // Set Filter ========================================
    switch (currentFilter) {
      case Filter.active:
        filteredTodoList = todoList.where((todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        filteredTodoList = todoList.where((todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        filteredTodoList = todoList;
        break;
    }

    if (searchTerm.isNotEmpty) {
      filteredTodoList = filteredTodoList
          .where((todo) => todo.desc.toLowerCase().contains(searchTerm))
          .toList();
    }
    state = state.copyWith(filteredTodoList: filteredTodoList);
    super.update(watch);
  }
}
