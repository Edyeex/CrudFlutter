import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BancoConnection {
  static final BancoConnection _instance = BancoConnection._internal();
  factory BancoConnection() => _instance;

  static Database? _database;

  BancoConnection._internal() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path;

    if (Platform.isWindows) {
      path = r'C:\temp\CrudFlutter\crud_flutter\database\CrudFlutter.db';
    } else {
      path = join(await getDatabasesPath(), 'CrudFlutter.db');
    }

    return await openDatabase(
      path,
      version: 1,
    );
  }



  Future<int> inserirUsuario(Map<String, dynamic> usuario) async {
    Database db = await database;
    return await db.insert('usuarios', usuario);
  }

  Future<List<Map<String, dynamic>>> listarUsuarios() async {
    Database db = await database;
    return await db.query(
      'usuarios',
      orderBy: 'data_cadastro DESC',
    );
  }

  Future<int> atualizarUsuario(Map<String, dynamic> usuario) async {
    Database db = await database;
    return await db.update(
      'usuarios',
      usuario,
      where: 'id = ?',
      whereArgs: [usuario['id']],
    );
  }

  Future<int> excluirUsuario(int id) async {
    Database db = await database;
    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> listarLogs() async {
    Database db = await database;
    return await db.query(
      'logs',
      orderBy: 'data_hora DESC',
    );
  }
}
