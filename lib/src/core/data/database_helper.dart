import 'package:summoners_lift/src/features/workout_generator/data/workout.dart';
import 'package:summoners_lift/src/features/workout_generator/data/player_stats.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('summoners_lift.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE PlayerStats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        role TEXT,
        isMVP INTEGER,
        kills INTEGER,
        deaths INTEGER,
        assists INTEGER,
        teamKills INTEGER,
        creepScore INTEGER,
        visionScore INTEGER,
        gameDuration INTEGER,
        submitDate TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE Workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        exercise TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertPlayerStats(PlayerStats playerStats) async {
    final db = await instance.database;
    return await db.insert('PlayerStats', playerStats.toMap());
  }

  Future<int> insertWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.insert('Workouts', workout.toMap());
  }

  Future<List<PlayerStats>> getAllPlayerStats() async {
    final db = await instance.database;
    final result = await db.query('PlayerStats');
    return result.map((e) => PlayerStats.fromMap(e)).toList();
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await instance.database;
    final result = await db.query('Workouts');
    return result.map((e) => Workout.fromMap(e)).toList();
  }
}
