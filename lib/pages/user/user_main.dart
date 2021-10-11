import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_tracker/pages/Catergories/breakfast.dart';
import 'package:food_tracker/pages/Catergories/dinner.dart';
import 'package:food_tracker/pages/Catergories/lunch.dart';
import 'package:food_tracker/pages/Catergories/snacks.dart';
import 'package:food_tracker/pages/login.dart';
import 'package:food_tracker/pages/user/profile.dart';
import 'change_password.dart';
import 'dashboard.dart';

class UserMain extends StatefulWidget {
  UserMain({Key? key}) : super(key: key);

  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Profile(),
    ChangePassword(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent.shade100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Welcome To Your Diet Tracker"),
              ElevatedButton(
                onPressed: () async => {
                  await FirebaseAuth.instance.signOut(),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                      (route) => false)
                },
                child: Text('Logout'),
                style:
                    ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
              )
            ],
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.blue,
              ),
              label: 'Dashboard',
              backgroundColor: Colors.deepOrange,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.deepOrange,
              ),
              label: 'My Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.teal,
              ),
              label: 'Change Password',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.pink,
          onTap: _onItemTapped,
        ),
        floatingActionButton: FabCircularMenu(
          fabOpenIcon: Icon(Icons.add),
          ringColor: Colors.blue.shade400,
          fabColor: Colors.blue.shade200,
          fabElevation: 5.0,
          children: [
            Tooltip(
              message: "Breakfast",
              child: IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Breakfast())),
                icon: Icon(
                  Icons.free_breakfast_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            Tooltip(
              message: "Lunch",
              child: IconButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Lunch())),
                icon: Icon(
                  Icons.lunch_dining_outlined,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            Tooltip(
              message: "Eve Snacks",
              child: IconButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Snacks())),
                icon: Icon(
                  Icons.restaurant_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Tooltip(
              message: "Dinner",
              child: IconButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dinner())),
                icon: Icon(
                  Icons.dinner_dining_outlined,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
          animationCurve: Curves.easeInOutBack,
        ));
  }
}
