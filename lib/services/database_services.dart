import 'dart:async';
import 'dart:io';
import 'package:guideme/dto/tourplandetailsmodel.dart';
import 'package:guideme/dto/tourplanmodel.dart';
import 'package:path/path.dart' ;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBService {
  static final DBService instance = DBService._init();
  static Database? _database;

  factory DBService() => instance;

  DBService._init();

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = join(appDocDir.path, 'guideme.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const fkType = 'INTEGER';
    // final boolType = 'BOOLEAN NOT NULL';
    // final integerType = 'INTEGER NOT NULL';

    await db.execute('''CREATE TABLE $tableTourPlan (
      ${TourPlansField.id} $idType,
      ${TourPlansField.header} $textType,
      ${TourPlansField.name} $textType,
      ${TourPlansField.location} $textType
    )
    ''');
          await db.execute('''CREATE TABLE $tableTourPlanDetails (
      ${TourPlanDetailsField.id} $idType,
      ${TourPlanDetailsField.tourPlanID} $fkType,
      ${TourPlanDetailsField.activity} $textType,
      ${TourPlanDetailsField.desc} $textType,
      ${TourPlanDetailsField.detailLocation} $textType,
      FOREIGN KEY (${TourPlanDetailsField.tourPlanID}) REFERENCES $tableTourPlan(${TourPlansField.id}) ON DELETE CASCADE
    )''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const fkType = 'INTEGER NOT NULL';

    if (oldVersion < 2) {
      await db.execute('''CREATE TABLE $tableTourPlanDetails (
      ${TourPlanDetailsField.id} $idType,
      ${TourPlanDetailsField.tourPlanID} $fkType,
      ${TourPlanDetailsField.activity} $textType,
      ${TourPlanDetailsField.desc} $textType,
      ${TourPlanDetailsField.detailLocation} $textType,
      FOREIGN KEY (${TourPlanDetailsField.tourPlanID}) REFERENCES $tableTourPlan(${TourPlansField.id}) ON DELETE CASCADE
    )''');
    }
  }

  Future<TourPlan> createTourPlan(TourPlan tourPlan) async {
    final db = await instance.database;

    //Manual insert
    // final json = tourPlan.toJson();
    // final columns = '${TourPlansField.header}, ${TourPlansField.name}, ${TourPlansField.location}';
    // final values = '${json[TourPlansField.header]}, ${json[TourPlansField.name]}, ${json[TourPlansField.location]}';
    // final id = await db .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableTourPlan, tourPlan.toJson());
    return tourPlan.copy(id: id);
  }

  //Read 1 tour plan
  Future<TourPlan> readTourPlan(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTourPlan,
      columns: TourPlansField.values,
      where: '${TourPlansField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TourPlan.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  //Read semua tour plan
  Future<List<TourPlan>> readAllTourPlan() async {
    final db = await instance.database;
    // final version = await db.getVersion();
    // print(version.toString());
    // final orderBy = '${TourPlansField.id} ASC';
    //Manual query
    // final result = await db.rawQuery('SELECT * FROM $tableTourPlan ORDER BY $orderBy');
    final result = await db.query(
      tableTourPlan,
    );

    return result.map((json) => TourPlan.fromJson(json)).toList();
  }

  Future<int> updateTourPlan(TourPlan tourPlan) async {
    final db = await instance.database;
    return await db.update(
      tableTourPlan,
      tourPlan.toJson(),
      where: '${TourPlansField.id} = ?',
      whereArgs: [tourPlan.id],
    );
  }

  Future<int> deleteTourPlan(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableTourPlan,
      where: '${TourPlansField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<TourPlanDetails> createTourPlanDetails(
      TourPlanDetails tourPlanDetails) async {
    final db = await instance.database;

    final id = await db.insert(tableTourPlanDetails, tourPlanDetails.toJson());
    return tourPlanDetails.copy(id: id);
  }

  Future<List<TourPlanDetails>> readAllTourPlanDetails() async {
    final db = await instance.database;
    final result = await db.query(
      tableTourPlanDetails,
    );

    return result.map((json) => TourPlanDetails.fromJson(json)).toList();
  }

  Future<int> updateTourPlanDetails(TourPlanDetails tourPlanDetails) async {
    final db = await instance.database;

    return await db.update(
      tableTourPlanDetails,
      tourPlanDetails.toJson(),
      where: '${tourPlanDetails.id} = ?',
      whereArgs: [tourPlanDetails.id],
    );
  }

  Future<int> deleteTourPlanDetails(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTourPlanDetails,
      where: '${TourPlanDetailsField.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
