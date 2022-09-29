import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  File? file;

  @override
  Widget build(BuildContext context) {
    //Text controller and its corresponding variable.
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    String? name;
    String? phone;
    String? email;
    String? password;

    var formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("SignUp Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == "") {
                    return "Name cannot be empty";
                  }
                  return null;
                },
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter Your Name",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.length != 10 ||
                      value.length > 10) {
                    return "Enter 10 digit mobile number";
                  }
                  return null;
                },
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter Phone Number",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              ),
              TextFormField(
                validator: (value) {
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value!);
                  if (!emailValid) {
                    return "Enter valid email id.";
                  }
                  return null;
                },
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email-ID",
                    hintText: "Enter your Email-ID",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              ),
              TextFormField(
                validator: (value) {
                  bool passValid = RegExp(
                          r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#\$&*~]).{8,}$')
                      .hasMatch(value!);
                  if (!passValid) {
                    return "Enter valid password. Atleast 8 character(One uppercase,One numeric and One special character )";
                  }
                  return null;
                },
                obscureText: true,
                controller: passController,
                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your Password",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {

                    file = File(image!.path);


                  });
                },
                child: file != null? CircleAvatar(
                        foregroundImage: FileImage(file!),
                        radius: 100,
                        // child: file!=null ?Image.file(file!) : Image.asset('assets/user.png'),
                      )
                    : CircleAvatar(
                        foregroundImage:AssetImage('assets/avatar.jpg'),
                        radius: 100,
                      ),
                // child: Container(
                //
                //   padding: EdgeInsets.all(4),
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       border: Border.all(color: Colors.grey, width: 4)),
                //
                // ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: TextButton(
                    onPressed: () async {
                      bool isValid = formKey.currentState?.validate() ?? false;
                      if (isValid) {
                        name = nameController.text;
                        phone = phoneController.text;
                        email = emailController.text;
                        password = passController.text;
                        print(name);
                        print(phone);
                        print(email);
                        print(password);

                        var body = {
                          "name": name,
                          "phone": phone,
                          "email": email,
                          "password": password
                        };
                        var dio = Dio();
                        Response response = await dio.post(
                            "https://bazz.techdocklabs.com/api/register-testuser",
                            data: body);
                        print(response.statusMessage);
                      } //if body
                    },
                    child: const Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
