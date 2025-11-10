import 'package:bayamsalam/domain/core/contracts/month_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:hive/hive.dart';

class HiveMonthRepository implements MonthRepositoryContract {
  final Box<Month> _monthBox;

  HiveMonthRepository(this._monthBox);

  @override
  Future<void> saveMonth(Month month) async {
    await _monthBox.put(month.id, month);
  }

  @override
  Future<Month?> getMonth(String id) async {
    return _monthBox.get(id);
  }

  @override
  Future<void> updateMonth(Month month) async {
    await month.save();
  }

  @override
  Future<void> deleteMonth(String id) async {
    await _monthBox.delete(id);
  }
}
