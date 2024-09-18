// entity/person.dart

import 'package:floor/floor.dart';

@entity
class Person {
  @primaryKey
  final int id;
  int time;
  bool isOpen;
  bool isScreenVisible;

  Person(
    this.id,
    this.time,
    this.isOpen,
    this.isScreenVisible,
  );
}
