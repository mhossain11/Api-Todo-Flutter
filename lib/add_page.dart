import 'dart:convert';

import 'package:apitodoapp/todo_service.dart';
import 'package:apitodoapp/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class AddTodoPage extends StatefulWidget {
  final Map? todo;
   AddTodoPage({super.key,this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todo = widget.todo;
    if(todo !=null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];

      titleController.text = title;
      descriptionController.text=description;
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children:[
           TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20,),
           TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(isEdit ? 'Update' : 'Submit'),
              )
          ),
        ],
      ),
    );
  }
  Future<void> updateData () async {
    //Get the Data form form
    final todo = widget.todo;
    if(todo == null){
      print("You can not Call Updated without todo data");
      return;
    }
    final id = todo['_id'];
    final isSuccess= await TodoService.updateTodo(id, body);

    // show success or fail message
    if(isSuccess){
      showSuccessMessage(context,message: 'Updation Success');

    }else{
      showErrorMessage(context,message: 'Updation Failed');
    }

  }

  Future<void> submitData() async{
    final isSuccess = await TodoService.addTodo(body);
    // show success or fail message
    if(isSuccess){
      titleController.text='';
      descriptionController.text='';

      showSuccessMessage(context, message:"Creation Success");

    }else{

      showErrorMessage(context, message:"Creation Failed");
    }

  }

  Map get body {
    //Get the Data form form
    final title = titleController.text;
    final description = descriptionController.text;
    return{
      "title": title,
      "description": description,
      "is_completed": false
    };
  }
}
