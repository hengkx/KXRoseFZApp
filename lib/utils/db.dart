import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rose_fz/models/databases/request_log.dart';

class DBUtil {
  static final DBUtil _instance = new DBUtil.internal();

  factory DBUtil() => _instance;

  final String tableNote = 'note11Table';
  final String pointID = 'pointid';
  final String image = 'image';
  final String contractId = 'contractId';
  final String publicationId = 'publicationId';
  final String pointLat = 'pointLat';
  final String pointLng = 'pointLng';

  static Database _db;

  DBUtil.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await init();

    return _db;
  }

  init() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'rose.db');
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE request_log(
        id INTEGER PRIMARY KEY autoincrement, 
        url TEXT, 
        params TEXT, 
        response TEXT, 
        result INTEGER,
        resultStr TEXT,
        uin INTEGER,
        time TEXT
      )''');
  }

  Future<int> addRequestLog(RequestLog log) async {
    var dbClient = await db;
    var result = await dbClient.insert('request_log', log.toMap());
    return result;
  }

  Future<List<RequestLog>> getAllRequestLogs({int limit, int offset}) async {
    var dbClient = await db;
    var result = await dbClient.query(
      'request_log',
      columns: [
        'id',
        'url',
        'params',
        'response',
        'result',
        'resultStr',
        'uin',
        'time'
      ],
      limit: limit,
      offset: offset,
      where: 'result != 0',
      orderBy: 'time DESC',
    );

    return result.map((val) => RequestLog.fromMap(val)).toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM request_log'));
  }

  Future<RequestLog> getRequestLog(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('request_log',
        columns: ['id', 'url', 'params', 'response', 'time'],
        where: 'id = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return new RequestLog.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteNote(String images) async {
    var dbClient = await db;
    return await dbClient
        .delete('request_log', where: '$image = ?', whereArgs: [images]);
  }

  Future<int> updateNote(RequestLog note) async {
    var dbClient = await db;
    return await dbClient.update(tableNote, note.toMap(),
        where: "$pointID = ?", whereArgs: [note.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
