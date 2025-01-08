import 'package:flutter/material.dart';
import 'package:league_of_logs/src/utils/constants.dart';
import 'package:league_of_logs/src/workout_generator/workout_generator_form.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      _showDisclaimerDialog();
    });
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Disclaimer'),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 500,
            ),
            child: Text(disclaimer)
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PostMatchStatsForm()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(isDarkMode
                ? darkThemeBackgroundImage
                : lightThemeBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          // child: Center(
          //   child: Column(
          //     children: [
          //       Text(
          //         appTitle,
          //         style: TextStyle(
          //           fontSize: 30,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //       Text(
          //         'Welcome to Summoners Lift!',
          //         style: TextStyle(
          //           fontSize: 20,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   )
          // ),
        )
      ),
    );
  }
}