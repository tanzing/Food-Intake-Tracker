import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String temp = "";
  DateTime? x;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (ElevatedButton(
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
                                x = DateTime.tryParse(value.toString())!;
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
            })),
        if (x != null)
          Text(
            "${x?.day.toString() ?? ""}/${x?.month.toString() ?? ''}/${x?.year.toString() ?? ''}",
            style: TextStyle(color: Colors.teal.shade500),
          ),
        Center(
          child: Text(
            '\n\nCalories Taken By User',
            maxLines: 20,
            style: TextStyle(color: Colors.blueAccent, fontSize: 15),
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: TextFormField(
              showCursor: false,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: "",
                  labelStyle:
                      TextStyle(color: Colors.orangeAccent, fontSize: 15),
                  border: OutlineInputBorder())),
        )
      ],
    );
  }
}
