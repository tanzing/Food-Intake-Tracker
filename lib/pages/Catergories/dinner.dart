import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_tracker/main.dart';
import 'package:food_tracker/pages/Catergories/breakfast.dart';
import 'package:food_tracker/pages/user/dashboard.dart';
import 'package:food_tracker/services/firebase.dart';

class Food {
  String name;
  int calories;

  Food({required this.name, required this.calories});
}

class Dinner extends StatefulWidget {
  const Dinner({Key? key}) : super(key: key);

  @override
  _DinnerState createState() => _DinnerState();
}

class _DinnerState extends State<Dinner> {
  List<Food> entries = <Food>[];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dinner"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(""),
              FutureBuilder(
                  future:
                      firestoreServices.getCollections("users", uid, "Dinner"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final QuerySnapshot<Map<String, dynamic>> collectionData =
                          snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                      final List<QueryDocumentSnapshot> data =
                          collectionData.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              left: 30, top: 100, right: 30, bottom: 20),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              tileColor: Colors.orange[400],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return QuantityDialog(
                                        id: data[index].reference.id.toString(),
                                      );
                                    });
                              },
                              trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Delete"),
                                            content: Text(
                                                "Do you want to delete this record permenently?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async =>
                                                      Navigator.pop(context),
                                                  child: Text("Cancel")),
                                              TextButton(
                                                  onPressed: () async {
                                                    var x = collectionData
                                                        .docs[index]
                                                        .reference
                                                        .id
                                                        .toString();
                                                    final collection =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(uid)
                                                            .collection(
                                                                'Dinner');
                                                    await collection
                                                        .doc(x)
                                                        .delete();
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          ));
                                },
                                icon: Icon(Icons.delete_outline),
                              ),
                              title: Center(
                                  child: Center(
                                child: Text(
                                  '${(data[index].data() as Map<String, dynamic>)["name"]}',
                                ),
                              )),
                            );
                          });
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: "Item Name",
                                        border: OutlineInputBorder()),
                                    controller: _nameController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: "Calories",
                                        border: OutlineInputBorder()),
                                    controller: _caloriesController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      entries.add(Food(
                                          name: _nameController.text,
                                          calories: int.tryParse(
                                                  _caloriesController.text
                                                      .trim()) ??
                                              0));

                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(uid)
                                          .collection("Dinner")
                                          .doc()
                                          .set({
                                        'name': _nameController.text,
                                        'calories': int.tryParse(
                                            _caloriesController.text)
                                      });
                                    });
                                    _nameController.clear();
                                    _caloriesController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Save")),
                              TextButton(
                                  onPressed: () {
                                    _nameController.clear();
                                    _caloriesController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel")),
                            ],
                          );
                        });
                  },
                  child: Text("Add Item"))
            ],
          ),
        ));
  }
}

class QuantityDialog extends StatefulWidget {
  final String id;
  const QuantityDialog({Key? key, required this.id}) : super(key: key);

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  int _counter = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter != 1) _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    var docid = widget.id;

    return AlertDialog(
      title: Text("Qty"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("QTY:"),
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Row(
                  children: [
                    IconButton(
                        splashRadius: 15.0,
                        onPressed: () => _decrementCounter(),
                        tooltip: 'Decrement',
                        icon: Icon(Icons.remove)),
                    Text(
                      "$_counter",
                    ),
                    IconButton(
                        onPressed: _incrementCounter,
                        tooltip: "increment",
                        icon: Icon(Icons.add))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              setState(() async {
                var collectio = FirebaseFirestore.instance
                    .collection('users')
                    .doc(uids)
                    .collection('Date');
                var docSnapshot = await collectio.doc('$x').get();
                if (docSnapshot.exists) {
                  Map<String, dynamic>? data = docSnapshot.data();
                  calories = data!['calories'];
                }
                var collection = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .collection("Dinner")
                    .doc(docid)
                    .get();
                Map<String, dynamic>? data;

                if (collection.exists) {
                  data = collection.data();
                }

                var cal = data?['calories'];

                FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .collection("Date")
                    .doc(x)
                    .update({'calories': (cal * _counter) + calories!});

                Navigator.pop(context);
              });
            },
            child: Text(
              "Ok",
              style: Theme.of(context).textTheme.subtitle1,
            )),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text("Cancel", style: Theme.of(context).textTheme.subtitle1)),
      ],
    );
  }
}
