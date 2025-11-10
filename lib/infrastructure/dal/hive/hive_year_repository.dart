import 'package:bayamsalam/domain/core/contracts/year_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/year.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart'; // You might need to add this dependency

class HiveYearRepository implements YearRepositoryContract {
  final Box<Year> _yearBox;

  HiveYearRepository(this._yearBox);

  @override
  Future<void> saveYear(Year year) async {
    await _yearBox.put(year.id, year);
  }

  @override
  Future<Year?> getYear(int year) async {
    // Use firstWhereOrNull from the 'collection' package for a cleaner implementation.
    // This is the most recommended modern approach.
    return _yearBox.values.firstWhereOrNull((y) => y.year == year);
  }

  @override
  Future<List<Year>> getAllYears() async {
    return _yearBox.values.toList();
  }

  @override
  Future<void> updateYear(Year year) async {
    await year.save();
  }

  @override
  Future<void> deleteYear(String id) async {
    await _yearBox.delete(id);
  }
}
