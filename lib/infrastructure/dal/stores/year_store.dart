import 'package:bayamsalam/domain/core/entities/year.dart';
import 'package:hive/hive.dart';

class YearStore {
  final Box<Year> _box;

  YearStore(this._box);

  Future<Year?> getByYearValue(int yearValue) async {
    try {
      return _box.values.firstWhere((y) => y.year == yearValue);
    } catch (e) {
      return null;
    }
  }

  Future<void> save(Year year) async {
    await _box.put(year.id, year);
  }

  Future<Year> getOrCreate(int yearValue) async {
    Year? year = await getByYearValue(yearValue);
    if (year == null) {
      final newYear = Year.create(year: yearValue);
      await save(newYear);
      return newYear;
    }
    return year;
  }
}
