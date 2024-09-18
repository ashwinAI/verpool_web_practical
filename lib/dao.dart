// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:practical/person.dart';

@dao
abstract class PersonDao {
  // Insert a new person
  @insert
  Future<void> insertPerson(Person person);

  // Retrieve all persons
  @Query('SELECT * FROM Person')
  Future<List<Person>> findAllPersons();

  // Update a person
  @update
  Future<void> updatePerson(Person person);

  // Delete a person
  @delete
  Future<void> deletePerson(Person person);

  @Query('SELECT * FROM Person WHERE id = :id LIMIT 1')
  Future<Person?> findEntityById(int id);
}
