import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_v1/components/todo_container.dart';
import 'package:todo_v1/providers/providers.dart';
import 'package:todo_v1/utils/debounce.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              children: [
                TodoHeader(),
                CreateTodo(),
                Divider(),
                SearchAndFilterTodo(),
                ShowTodos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================
// Head of the app
// Showing the title and the Number of todos
// ===========================================
class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('TODO'),
        // Listen to the count value of ActiveTodoCount
        Text(
            '${context.watch<ActiveTodoCount>().state.activeTodoCount} items left'),
      ],
    );
  }
}

// ==================================================================
// To Add todo in the list
// stateful widget to use textEditingConroller needed to be disposed
// ==================================================================
class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final todoTextCont = TextEditingController();

  @override
  void dispose() {
    todoTextCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: todoTextCont,
      decoration: InputDecoration(labelText: 'What is your next move?'),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.trim().isNotEmpty) {
          context.read<TodoList>().addTodo(todoDesc);
          // 항목 추가시 필터를 all 상태로 변경
          context.read<TodoFilter>().changeFilter(Filter.all);
          todoTextCont.clear(); // To clear the TextField
        }
      },
    );
  }
}

// Handling SearchTerm, filter to show Todo items
class SearchAndFilterTodo extends StatelessWidget {
  final debounce = Debounce();
  SearchAndFilterTodo({super.key});

  @override
  Widget build(BuildContext context) {
    List<Filter> filters = [Filter.all, Filter.active, Filter.completed];

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Search Todos',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          // 입력될 때 마다 검색을 실시
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              // debounce 의 run 함수로 검색함수를 실행
              // Search after 500 milliseconds
              debounce.run(() {
                context.read<TodoSearch>().setSearchTerm(newSearchTerm);
              });
            }
          },
        ),
        const SizedBox(height: 12),
        // Buttons for filtering todo state; completed
        // using functions for rendering buttons: FilterButton
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              filters.map((filter) => FilterButton(context, filter)).toList(),
        ),
      ],
    );
  }

  Widget FilterButton(BuildContext context, Filter filter) {
    // filter 에 따라 색상을 다르게 표시
    // 주어진 필터값과 비교를 하여 같으면 파란색으로 설정
    final currentFilter = context.watch<TodoFilter>().state.filter;
    final buttonColor = currentFilter == filter ? Colors.blue : Colors.grey;

    return TextButton(
      // filter의 값을 바꾸도록 하는 함수 호출
      onPressed: () {
        context.read<TodoFilter>().changeFilter(filter);
      },
      // Filter 상태에 따라 버튼 메세지를 다르게 표시
      child: Text(
        filter == Filter.all
            ? "All"
            : filter == Filter.active
                ? 'Active'
                : 'Completed',
        style: TextStyle(color: buttonColor),
      ),
    );
  }
}

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final todoList = context.watch<FilteredTodo>().state.filteredTodoList;
    return ListView.separated(
      // ===============================
      // instead of using Expaned widget
      primary: false,
      shrinkWrap: true,
      // ===============================
      itemCount: todoList.length,
      separatorBuilder: (_, __) => Divider(
        color: Colors.grey,
      ),
      itemBuilder: (context, index) {
        // 좌우로 스크롤하여 항목을 삭제할 수 있도록 설정
        return Dismissible(
          key: ValueKey(todoList[index].id),
          background: showBackground(0),
          secondaryBackground: showBackground(1),
          onDismissed: (_) =>
              context.read<TodoList>().removeTodo(todoList[index]),
          // Run onDismissed function up to the value of Future<true, false>
          confirmDismiss: (_) => deletionCheck(context),
          child: TodoContainer(todo: todoList[index]),
        );
      },
    );
  }

  Future<bool?> deletionCheck(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      // 외부를 탭해도 확인창이 사라지지 않도록 설정
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Are you sure?'),
        content: Text('This item will be deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('NO')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('YES')),
        ],
      ),
    );
  }

  // Returning Container showed on the Background of Dismissible Widget
  Widget showBackground(int direction) {
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.symmetric(horizontal: 9),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: Icon(
        Icons.delete,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
