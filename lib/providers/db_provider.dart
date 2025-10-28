import 'package:keypressapp/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  //-------------------------------------------------------------------------
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  //-------------------------------------------------------------------------
  Future<Database> initDB() async {
    // Path de donde almacenaremos la base de datos
    final path = join(await getDatabasesPath(), 'NotificationsDB.db');

    // Crear base de datos
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Notifications(id INTEGER PRIMARY KEY AUTOINCREMENT,messageId INTEGER,sentDate TEXT,title TEXT,body TEXT,user TEXT,imageUrl TEXT,readed BOOL)',
        );
      },
    );
  }

  //-------------------------------------------------------------------------
  Future<int?> newNotificationRaw(PushMessage newNotification) async {
    final messageId = newNotification.messageId;
    final sentDate = newNotification.sentDate;
    final title = newNotification.title;
    final body = newNotification.body;
    final user = newNotification.user;
    final imageUrl = newNotification.imageUrl;
    final readed = newNotification.readed;

    // Verificar la base de datos
    final db = await database;

    final res = await db?.rawInsert('''
      INSERT INTO Notifications( messageId,sentDate, title, body, user, imageUrl,readed )
        VALUES( '$messageId', '$sentDate', '$title','$body', '$user', '$imageUrl', '$readed' )
    ''');
    return res;
  }

  //-------------------------------------------------------------------------
  Future<PushMessage?> getNotificationById(int id) async {
    final db = await database;
    final res = await db!.query(
      'Notifications',
      where: 'id = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? PushMessage.fromJson(res.first) : null;
  }

  //-------------------------------------------------------------------------
  Future<PushMessage?> getNotificatonByMessageId(String messageId) async {
    final db = await database;
    final res = await db!.query(
      'Notifications',
      where: 'messageId = ?',
      whereArgs: [messageId],
    );

    return res.isNotEmpty ? PushMessage.fromJson(res.first) : null;
  }

  //-------------------------------------------------------------------------
  Future<List<PushMessage>> getAllNotificationsByUser(String user) async {
    final db = await database;
    final res = await db!.query(
      'Notifications',
      where: 'LOWER(user) = LOWER(?)',
      whereArgs: [user],
    );

    return res.isNotEmpty
        ? res.map((s) => PushMessage.fromJson(s)).toList()
        : [];
  }

  //-------------------------------------------------------------------------
  Future<int?> updateNotification(PushMessage notification) async {
    final db = await database;
    final res = await db?.update(
      'Notifications',
      notification.toJson(),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
    return res;
  }

  //-------------------------------------------------------------------------
  Future<int?> markAsRead(int notificationId) async {
    final db = await database;
    final res = await db?.update(
      'Notifications',
      {'readed': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );

    return res;
  }

  //-------------------------------------------------------------------------
  Future<int?> deleteNotification(int id) async {
    final db = await database;
    final res = await db?.delete(
      'Notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res;
  }

  //-------------------------------------------------------------------------
  Future<int?> deleteAllNotifications() async {
    final db = await database;
    final res = await db?.rawDelete('''
      DELETE FROM Notifications    
    ''');
    return res;
  }
}
