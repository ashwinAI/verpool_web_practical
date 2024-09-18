import 'dart:async';

import 'package:floor/floor.dart';
import 'package:practical/dao.dart';
import 'package:practical/person.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'databse.g.dart';

@Database(version: 1, entities: [Person])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;
}
