import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'package:league_of_logs/src/workout_generator/workout_generator_service.dart';
import 'package:league_of_logs/src/workout_generator/player_stats.dart';
import 'package:league_of_logs/src/utils/constants.dart';

class PostMatchStatsForm extends StatefulWidget {
  @override
  _PostMatchStatsFormState createState() => _PostMatchStatsFormState();

  static const routeName = '/';
}

class _PostMatchStatsFormState extends State<PostMatchStatsForm> {
  final _formKey = GlobalKey<FormState>();
  final _playerNameController = TextEditingController();
  final _killsController = TextEditingController();
  final _deathsController = TextEditingController();
  final _assistsController = TextEditingController();
  final _teamKillsController = TextEditingController();
  final _creepScoreController = TextEditingController();
  final _visionScoreController = TextEditingController();
  final _gameDurationController = TextEditingController();

  String _role = 'ADC';

  bool _isMVP = false;

  final WorkoutGeneratorService _workoutService = WorkoutGeneratorService();

  String workoutResult = '';

  void _onSubmit() {
    final playerStats = PlayerStats(
      name: _playerNameController.text,
      role: _role,
      isMVP: _isMVP,
      kills: int.parse(_killsController.text),
      deaths: int.parse(_deathsController.text),
      assists: int.parse(_assistsController.text),
      teamKills: int.parse(_teamKillsController.text),
      creepScore: int.parse(_creepScoreController.text),
      visionScore: int.parse(_visionScoreController.text),
      gameDuration: int.parse(_gameDurationController.text),
    );

    workoutResult = _workoutService.generateWorkout(playerStats: playerStats);
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _killsController.dispose();
    _deathsController.dispose();
    _assistsController.dispose();
    _teamKillsController.dispose();
    _creepScoreController.dispose();
    _visionScoreController.dispose();
    _gameDurationController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post-Match Stats'),
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
            constraints: const BoxConstraints(maxWidth: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withAlpha((0.8 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _playerNameController,
                            decoration: InputDecoration(labelText: 'Player Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter player name';
                              }
                              return null;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: _role,
                            onChanged: (value) {
                              setState(() {
                                _role = value!;
                              });
                            },
                            items: ['ADC', 'Support', 'Middle', 'Jungle', 'Top']
                                .map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            decoration: const InputDecoration(labelText: 'Role'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a role';
                              }
                              return null;
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('MVP'),
                            value: _isMVP,
                            onChanged: (bool? value) {
                              setState(() {
                                _isMVP = value ?? false;
                              });
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 90)
                          ),
                          TextFormField(
                            controller: _killsController,
                            decoration: InputDecoration(labelText: 'Kills'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number of kills';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _deathsController,
                            decoration: InputDecoration(labelText: 'Deaths'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number of deaths';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _assistsController,
                            decoration: InputDecoration(labelText: 'Assists'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number of assists';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _teamKillsController,
                            decoration: InputDecoration(labelText: 'Total Team Kills'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter total team kills';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _creepScoreController,
                            decoration: InputDecoration(labelText: 'CS'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter CS';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _visionScoreController,
                            decoration: InputDecoration(labelText: 'Vision Score'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter vision score';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _gameDurationController,
                            decoration: InputDecoration(labelText: 'Game Duration (Minutes)'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter game duration';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onSubmit();
                                showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Workout Generated'),
                                    content: Text(workoutResult),
                                    actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text('Generate Workout'),
                          ),
                        ],
                      ),
                    ),
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