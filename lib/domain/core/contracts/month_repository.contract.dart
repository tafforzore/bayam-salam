import 'package:bayamsalam/domain/core/entities/month.dart';

abstract class MonthRepositoryContract {
  Future<void> saveMonth(Month month);
  Future<Month?> getMonth(String id);
  Future<void> updateMonth(Month month);
  Future<void> deleteMonth(String id);
}
