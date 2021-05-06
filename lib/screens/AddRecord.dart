import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/AlertBox.dart';
import 'package:flutter_application_1/Widgets/Heading.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/Widgets/MyAppBar.dart';
import 'package:flutter_application_1/Widgets/Drawer.dart';

// Zahid Ali Regestration Number 2018-CS-136

class AddRecord extends StatefulWidget {
  @override
  _AddRecord createState() => _AddRecord();
}

class _AddRecord extends State<AddRecord> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<Convert> message;

  postRecord() {
    String firstName = firstnameController.text;
    String lastName = lastnameController.text;
    String gender = genderController.text;
    String email = emailController.text;
    String phone = phoneController.text;

    setState(() {
      message = addRecord(firstName, lastName, gender, email, phone);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: DrawerWidget(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(20.0),
        child: (message == null)
            ? SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(25),
                        child: Heading(
                          label: "Add TS Provider",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          // autofocus: true,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'First Name'),
                          controller: firstnameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Last Name'),
                          controller: lastnameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'gender here'),
                          controller: genderController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email Address'),
                          controller: emailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Phone Number'),
                          controller: phoneController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            postRecord();
                          },
                          child: Text(
                            'Add Record',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : FutureBuilder<Convert>(
                future: message,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return AlertBox(message: snapshot.data.message);
                  } else if (snapshot.hasError) {
                    return AlertBox(message: "${snapshot.error}");
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
      ),
    );
  }
}

Future<Convert> addRecord(String firstName, String lastName, String gender,
    String email, String phone) async {
  var url = Uri.parse('https://pcc.edu.pk/ws/create/ts_providers.php');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "email": email,
      "phone": phone
    }),
  );

  if (response.statusCode == 200) {
    return Convert.fromJson(jsonDecode(response.body));
  } else {
    return Convert.fromJson(jsonDecode("{'message': 'Failed to Add Record.'}"));
  }
}

class Convert {
  final String message;

  Convert({this.message});

  factory Convert.fromJson(Map<String, dynamic> json) {
    return Convert(
      message: json['message'],
    );
  }
}

// Zahid Ali Regestration Number 2018-CS-136
