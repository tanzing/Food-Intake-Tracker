import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_tracker/pages/user/user_main.dart';

import 'forgot_password.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Login Success");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login Successful"),
        backgroundColor: Colors.greenAccent,
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserMain(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("${e.code}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.black, Colors.black12],
                begin: Alignment.center,
                end: Alignment.center)
            .createShader(bounds),
        blendMode: BlendMode.darken,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.amber,
              image: DecorationImage(
                  image: NetworkImage(
                      'https://png.pngtree.com/background/20210712/original/pngtree-modern-double-color-futuristic-neon-background-picture-image_1181573.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Login"),
              backgroundColor: Colors.blue.shade800,
            ),
            body: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.black, Colors.black12],
                      begin: Alignment.bottomLeft,
                      end: Alignment.center)
                  .createShader(bounds),
              blendMode: BlendMode.darken,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    image: DecorationImage(
                        image: AssetImage('assets/back.jpg'),
                        fit: BoxFit.cover)),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 100, horizontal: 30),
                    child: ListView(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[600]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16)),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white,
                              ),
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              border: InputBorder.none,
                              errorStyle:
                                  TextStyle(color: Colors.red, fontSize: 18),
                            ),
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
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
                          decoration: BoxDecoration(
                              color: Colors.grey[600]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16)),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            autofocus: false,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              labelStyle: TextStyle(fontSize: 20.0),
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 18),
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
                        TextButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            )
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Forgot Password ?',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.redAccent)))),
                          onPressed: () {
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text;
                                password = passwordController.text;
                              });
                              userLogin();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an Account? ",
                                style: TextStyle(color: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: () => {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, a, b) =>
                                            Signup(),
                                        transitionDuration:
                                            Duration(seconds: 2000),
                                      ),
                                      (route) => false)
                                },
                                child: Text('Signup'),
                              ),
                              // TextButton(
                              //   onPressed: () => {
                              //     Navigator.pushAndRemoveUntil(
                              //         context,
                              //         PageRouteBuilder(
                              //           pageBuilder: (context, a, b) => UserMain(),
                              //           transitionDuration: Duration(seconds: 0),
                              //         ),
                              //         (route) => false)
                              //   },
                              //   child: Text('Dashboard'),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
