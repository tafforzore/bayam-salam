import 'package:bayamsalam/domain/core/entities/year.dart';

abstract class YearRepositoryContract {
  Future<void> saveYear(Year year);
  Future<Year?> getYear(int year);
  Future<List<Year>> getAllYears();
  Future<void> updateYear(Year year);
  Future<void> deleteYear(String id);
}
