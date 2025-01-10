import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summoners_lift/src/features/settings/presentation/settings_view.dart';
import 'package:summoners_lift/src/core/utils/constants.dart';
import 'package:summoners_lift/src/features/workout_generator/presentation/workout_generator_view.dart';
import 'package:summoners_lift/src/features/workout_stats/presentation/workout_stat_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _playerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    Future.delayed(Duration(seconds: 2), () {
      _showDisclaimerDialog();
    });
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('saveNameAndRole') ?? false) {
      _playerNameController.text = prefs.getString('savedName') ?? '';
    }
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
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDarkMode
              ? darkThemeBackgroundImage
              : lightThemeBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 375, maxHeight: 200),
            child: Container(
              decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withAlpha((0.8 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Summoners Lift!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: TextFormField(
                          controller: _playerNameController,
                          decoration: InputDecoration(labelText: 'Player Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter player name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PostMatchStatsForm()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              ),
                              child: Text(
                                'Start Workout',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutStatView()
                                  )
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              ),
                              child: Text(
                                'View Stats',
                                style: TextStyle(fontSize: 16),
                              )
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}