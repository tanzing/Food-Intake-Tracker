import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid.characters;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationDay =
      FirebaseAuth.instance.currentUser!.metadata.creationTime!.day;
  final creationMonth =
      FirebaseAuth.instance.currentUser!.metadata.creationTime!.month;
  final creationYear =
      FirebaseAuth.instance.currentUser!.metadata.creationTime!.year;

  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Verification Email has been sent',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage:
                NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
            radius: 50,
          ),
          Text(
            'User ID: $uid',
            style: TextStyle(fontSize: 16.0),
          ),
          Row(
            children: [
              Text(
                'Email: $email',
                style: TextStyle(fontSize: 16.0, color: Colors.blueAccent),
              ),
              user!.emailVerified
                  ? Text(
                      'verified',
                      style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                    )
                  : TextButton(
                      onPressed: () => {verifyEmail()},
                      child: Text('Verify Email'))
            ],
          ),
          Text(
            'Created: $creationDay / $creationMonth / $creationYear',
            style: TextStyle(fontSize: 16.0, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
