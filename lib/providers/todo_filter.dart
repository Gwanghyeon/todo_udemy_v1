import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Filter { all, active, completed }

class TodoFilterState extends Equatable {
  final Filter filter;

  // default Constructor
  const TodoFilterState({required this.filter});

  // Factory Constructor
  factory TodoFilterState.initial() {
    return const TodoFilterState(filter: Filter.all);
  }

  @override
  List<Object> get props => [filter];

  @override
  bool get stringify => true;

  TodoFilterState copyWith({Filter? filter}) {
    return TodoFilterState(filter: filter ?? this.filter);
  }
}

// ====================================
// provider to filter todo items
// setting the state of the todo item
// ====================================

class TodoFilter with ChangeNotifier {
  TodoFilterState _state = TodoFilterState.initial();
  TodoFilterState get state => _state;

  void changeFilter(Filter newFilter) {
    _state = _state.copyWith(filter: newFilter);
    notifyListeners();
  }
}
