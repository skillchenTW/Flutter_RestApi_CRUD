import 'dart:convert';

import 'package:fastflutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'list.dart';

class MyForm extends StatefulWidget {
  final User user;
  MyForm({Key? key, required this.user}) : super(key: key);

  @override
  _MyFormState createState() => _MyFormState();
}

Future save(user) async {
  if (user.id == 0) {
    await http.post(Uri.parse('http://localhost:8000'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': user.name,
          'email': user.email,
          'password': user.password,
        }));
  } else {
    await http.put(Uri.parse('http://localhost:8000/' + user.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': user.name,
          'email': user.email,
          'password': user.password,
        }));
  }
}

Future delete(id) async {
  await http.delete(Uri.parse('http://localhost:8000/' + id));
}

class _MyFormState extends State<MyForm> {
  TextEditingController idController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      idController.text = this.widget.user.id.toString();
      nameController.text = this.widget.user.name;
      emailController.text = this.widget.user.email;
      passwordController.text = this.widget.user.password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Visibility(
                visible: false,
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'ID'),
                  controller: idController,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Enter Name'),
                controller: nameController,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(hintText: 'Enter Email'),
                controller: emailController,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(hintText: 'Enter Password'),
                controller: passwordController,
              ),
              SizedBox(height: 20),
              MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Submit'),
                  minWidth: double.infinity,
                  onPressed: () {
                    setState(() async {
                      await save(User(
                          int.parse(idController.text),
                          nameController.text,
                          emailController.text,
                          passwordController.text));
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Home(
                                    widgetName: MyList(),
                                    title: 'List',
                                    index: 0,
                                  )));
                    });
                  }),
              SizedBox(height: 20),
              Visibility(
                visible: int.parse(idController.text) != 0 ? true : false,
                child: MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('Delete'),
                    minWidth: double.infinity,
                    onPressed: () {
                      setState(() async {
                        await delete(idController.text);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Home(
                                      widgetName: MyList(),
                                      title: 'List',
                                      index: 0,
                                    )));
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
