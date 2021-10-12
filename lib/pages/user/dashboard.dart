import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_tracker/main.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

int? calories;
final uids = FirebaseAuth.instance.currentUser!.uid.characters.toString();

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

Future<void> calorieFinder() async {
  var collection = FirebaseFirestore.instance
      .collection('users')
      .doc(uids)
      .collection('Date');
  var docSnapshot = await collection.doc('$x').get();
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    calories = data!['calories'];
  }
}

int check = 0;
void createDate(String m) {
  FirebaseFirestore.instance
      .collection("users")
      .doc(uids)
      .collection("Date")
      .doc('$x')
      .set({'calories': 0});
}

// ignore: non_constant_identifier_names
var Value = -99;
Future<void> checker() async {
  var collection = FirebaseFirestore.instance
      .collection('users')
      .doc(uids)
      .collection('Date');
  var docSnapshot = await collection.doc('$x').get();
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    Value = data!['calories'];
    print(Value);
    if (Value == -99) {
      check = 0;
      createDate(x!);
    } else {
      check = 1;
    }
  } else {
    createDate(x!);
    print(Value);
    check = 0;
  }
}

class _DashboardState extends State<Dashboard> {
  String temp = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tooltip(
          waitDuration: Duration(seconds: 1),
          showDuration: Duration(seconds: 2),
          textStyle: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
          message: 'Refresh to view calorie changes',
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.green),
          height: 20,
          child: IconButton(
              onPressed: () async {
                var collection = FirebaseFirestore.instance
                    .collection('users')
                    .doc(uids)
                    .collection('Date');
                var docSnapshot = await collection.doc('$x').get();
                setState(() {
                  if (docSnapshot.exists) {
                    Map<String, dynamic>? data = docSnapshot.data();
                    calories = data!['calories'];
                  }
                });
              },
              splashRadius: 15,
              padding: EdgeInsets.all(40),
              icon: Icon(Icons.refresh_outlined)),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
            child: Text("Date"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Date Picker"),
                      content: SizedBox(
                          height: 250,
                          width: 200,
                          child: SfDateRangePicker(
                            onSubmit: (Object value) {
                              setState(() {
                                String timeStamp = value.toString();
                                dateTime = DateTime.parse(timeStamp);
                                x = DateFormat("dd-MM-yyyy").format(dateTime!);

                                checker();
                                calorieFinder();
                              });

                              setState(() {
                                String timeStamp = value.toString();
                                dateTime = DateTime.parse(timeStamp);
                                x = DateFormat("dd-MM-yyyy").format(dateTime!);
                                checker();
                                calorieFinder();
                              });

                              Navigator.pop(context);
                            },
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            showActionButtons: true,
                          )),
                    );
                  });
            }),
        if (x != null)
          Text(
            "$x\n",
            style: TextStyle(color: Colors.teal.shade500, fontSize: 15),
          ),
        Center(
          child: Text(
            '\nCalories Taken By User',
            maxLines: 10,
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            autofocus: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                hintText: '$calories',
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
                border: InputBorder.none),
            readOnly: true,
            showCursor: false,
          ),
        )
      ],
    );
  }
}
