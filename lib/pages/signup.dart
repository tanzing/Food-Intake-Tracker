import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class Food {
  String name;
  int calories;

  Food({required this.name, required this.calories});
}

List<Food> lunch = <Food>[
  Food(name: 'Curd Rice', calories: 120),
  Food(name: 'Papad/Appalam', calories: 50),
  Food(name: 'Rasam', calories: 160),
  Food(name: 'Sambar ', calories: 150),
  Food(name: 'Gobi/French Fries', calories: 120),
  Food(name: 'Chips', calories: 65),
  Food(name: 'Veg Briyani', calories: 241)
];

List<Food> snacks = <Food>[
  Food(name: 'Sundal', calories: 111),
  Food(name: 'Tea', calories: 80),
  Food(name: 'Milk', calories: 75),
  Food(name: 'Fried Peanuts', calories: 250),
  Food(name: 'Veg Roll', calories: 105),
  Food(name: 'Samosa', calories: 262),
];

List<Food> dinner = <Food>[
  Food(name: 'Gobi', calories: 120),
  Food(name: 'Kal Dosai', calories: 170),
  Food(name: 'Roti & Sabji', calories: 95),
  Food(name: 'Ghee Rice', calories: 225),
  Food(name: 'Idli & Sabji', calories: 52),
  Food(name: 'Chicken', calories: 212),
  Food(name: 'Sambar Rice', calories: 225),
];

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  var confirmPassword = "";
  List<Food> breakfast = <Food>[
    Food(name: 'Dosa', calories: 120),
    Food(name: 'Idli', calories: 80),
    Food(name: 'Pongal', calories: 222),
    Food(name: 'Poori', calories: 170),
    Food(name: 'Masala Dosa', calories: 100),
    Food(name: "Tea", calories: 90),
  ];
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  registration() async {
    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Registered Successfully. Please Login..",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
        final uid =
            FirebaseAuth.instance.currentUser!.uid.characters.toString();
        for (var i = 0; i < 6; i++) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("BreakFast")
              .doc((i + 1).toString())
              .set({
            'name': breakfast[i].name,
            'calories': breakfast[i].calories
          });
        }

        for (var i = 0; i < 7; i++) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("Lunch")
              .doc((i + 1).toString())
              .set({'name': lunch[i].name, 'calories': lunch[i].calories});
        }

        for (var i = 0; i < 7; i++) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("Dinner")
              .doc((i + 1).toString())
              .set({'name': dinner[i].name, 'calories': dinner[i].calories});
        }

        for (var i = 0; i < 6; i++) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("Snacks")
              .doc((i + 1).toString())
              .set({'name': snacks[i].name, 'calories': snacks[i].calories});
        }

        FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("Info");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print("Password Provided is too Weak");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          print("Account Already exists");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        }
      }
    } else {
      print("Password and Confirm Password doesn't match");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Password and Confirm Password doesn't match",
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User SignUp"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Email: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    } else if (!value.contains('@')) {
                      return 'Please Enter Valid Email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                            confirmPassword = confirmPasswordController.text;
                          });
                          registration();
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account? "),
                    TextButton(
                        onPressed: () => {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          Login(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              )
                            },
                        child: Text('Login'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
