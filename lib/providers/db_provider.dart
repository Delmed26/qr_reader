import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  //TODO: Make null safecty

  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database?> initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final stringPath = path.join(documentsDirectory.path, 'ScansDB.db');
    // print(stringPath);

    return await openDatabase(
      stringPath,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {

        await db.execute(
          '''
            CREATE TABLE Scans(
              id INTEGER PRIMARY KEY,
              tipo TEXT,
              valor TEXT
            )
          '''
        );

      }
    );


  }

  Future<int> newScanRaw(ScanModel newScan) async {

    final id    = newScan.id;
    final tipo  = newScan.tipo;
    final valor = newScan.valor;

    // Verify database
    final db = await database;

    final res = await db!.rawInsert('''
      INSERT INTO Scans(id, tipo, valor)
        VALUES($id, '$tipo', '$valor')
    ''');

    return res;

  }

  Future<int> newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db!.insert('Scans', newScan.toJson());
    return res;
  }

  Future<ScanModel?> getScanById(int id) async {

    final db = await database;
    final res = await db!.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>?> getScans() async {

    final db = await database;
    final res = await db!.query('Scans');

    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<List<ScanModel>?> getScansByType(String tipo) async {

    final db = await database;
    final res = await db!.query('Scans', where: 'tipo = ?', whereArgs: [tipo]);

    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan (ScanModel scan) async {
    final db = await database;
    final res = await db!.update('Scans', scan.toJson(), where: 'id = ?', whereArgs: [scan.id]);
    return res;
  }

  Future<int> deleteScan (int id) async {
    final db = await database;
    final res = await db!.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteScans () async {
    final db = await database;
    final res = await db!.delete('Scans');
    return res;
  }

}