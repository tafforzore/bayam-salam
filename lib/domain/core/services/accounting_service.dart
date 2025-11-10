import 'package:bayamsalam/domain/core/contracts/month_repository.contract.dart';
import 'package:bayamsalam/domain/core/contracts/year_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/year.dart';

class AccountingService {
  final YearRepositoryContract _yearRepository;
  final MonthRepositoryContract _monthRepository;

  AccountingService(this._yearRepository, this._monthRepository);

  Future<void> createNewYear(int year) async {
    // CORRECTION : Utilisation de la factory au lieu du constructeur direct
    final newYear = Year.create(year: year);
    await _yearRepository.saveYear(newYear);
  }

  Future<void> addMonthToYear(int year, Month month) async {
    final existingYear = await _yearRepository.getYear(year);
    if (existingYear != null) {
      existingYear.months.add(month);
      await _yearRepository.updateYear(existingYear);
    }
  }

  // Autres logiques liées à la comptabilité générale...
}
