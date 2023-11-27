import 'package:equatable/equatable.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
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
// When values from other classes are needed, use LocatorMixin for read & watch
class ActiveTodoCount extends StateNotifier<ActiveTodoCountState>
    with LocatorMixin {
  ActiveTodoCount() : super(ActiveTodoCountState.initial());

  @override
  void update(Locator watch) {
    final newActiveTodoCount = watch<TodoListState>()
        .todoList
        .where((todo) => !todo.completed)
        .toList()
        .length;
    state = state.copyWith(activeTodoCount: newActiveTodoCount);
    super.update(watch);
  }
}
