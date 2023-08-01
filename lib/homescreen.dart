import 'dart:convert';

import 'package:apitodoapp/add_page.dart';
import 'package:apitodoapp/todo_service.dart';
import 'package:apitodoapp/utils/snackbar_helper.dart';
import 'package:apitodoapp/widget/todo_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
List items =[];
bool isLoading=true;
  @override
  void initState() {
    fetchTodo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo App'),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage,
          label: const Text('Add ToDo'),),


      body: Visibility(
        visible: isLoading,
          child: Center(child: CircularProgressIndicator(),),
        replacement:  RefreshIndicator(
          onRefresh: fetchTodo,

          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text('No Todo Item',
                style: Theme.of(context).textTheme.displaySmall),
            ),
            child: ListView.builder(
              itemCount: items.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context,index){
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return TodoCard(
                      index: index,
                      item: item,
                      navigateEdit: navigateToEditPage,
                      deleteById: deleteById
                  );
                }
            ),
          ),
        ),
      ),

        );
  }
Future <void> navigateToEditPage(Map item) async{
  final route = MaterialPageRoute(builder: (context) =>
      AddTodoPage(todo :item),);
  await Navigator.push(context, route);
  setState(() {
    isLoading = true;
  });
  fetchTodo();

}
   Future <void> navigateToAddPage() async {
      final route = MaterialPageRoute(builder: (context) =>
          AddTodoPage(),);
      await Navigator.push(context, route);
      setState(() {
        isLoading = true;
      });
      fetchTodo();

  }
Future<void> deleteById(String id) async {
  final isSuccess = await TodoService.deleteById(id);

  if(isSuccess){
    //Remove item from the list
    final filtered = items.where((element) => element['_id'] !=id).toList();
    setState(() {
      items = filtered;
    });
  }else{
    //show error
    showErrorMessage(context, message:"Deletion Failed");
  }


}

  Future<void> fetchTodo() async{
    final response = await TodoService.fetchTodos();
    if(response != null){
      setState(() {
        items = response;
      });
    }else{
      showErrorMessage(context, message:"Something went wrong");
    }
    setState(() {
      isLoading =false;
    });
  }


}


