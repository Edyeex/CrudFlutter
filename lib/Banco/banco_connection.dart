import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BancoConnection {
  static final BancoConnection _instance = BancoConnection._internal();
  factory BancoConnection() => _instance;

  BancoConnection._internal() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _connectToExistingDatabase();
    return _database!;
  }

  Future<Database> _connectToExistingDatabase() async {
    String dbPath = await _getDatabasePath();

    final dbFile = File(dbPath);
    if (!await dbFile.exists()) {
      throw Exception('Banco de dados não encontrado');
    }

    return await openDatabase(dbPath, version: 1);
  }

  Future<String> _getDatabasePath() async {
    if (Platform.isWindows) {
      return r'C:\temp\CrudFlutter\banco\CrudFlutter.db'; // Talvez precise mudar dependendo do caminho onde salvou o projeto
    } else {
      throw Exception('Caminho do banco não configurado.');
    }
  }



  Future<int> inserirUsuario(Map<String, dynamic> usuario) async {
    Database db = await database;
    return await db.insert('usuarios', usuario);
  }

  Future<List<Map<String, dynamic>>> listarUsuarios() async {
    Database db = await database;
    return await db.query('usuarios', orderBy: 'data_cadastro DESC');
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
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> listarLogs() async {
    Database db = await database;
    return await db.query('logs', orderBy: 'data_hora DESC');
  }
}