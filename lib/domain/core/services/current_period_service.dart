import 'package:bayamsalam/domain/core/contracts/year_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/year.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Ce service est une source unique de vérité pour obtenir la période (Année/Mois) actuelle.
/// Il garantit de retourner un objet Month valide, en le créant si nécessaire.
class CurrentPeriodService {
  final YearRepositoryContract _yearRepository;

  CurrentPeriodService(this._yearRepository);

  /// Retourne l'objet [Month] correspondant au mois actuel.
  /// Cette méthode est garantie de ne jamais retourner null.
  Future<Month> getCurrentMonth() async {
    final now = DateTime.now();
    final int yearValue = now.year;
    final String monthName = DateFormat.MMMM('fr_FR').format(now);

    // 1. Obtenir ou créer l'année
    Year currentYear = await _getOrCreateYear(yearValue);

    // 2. Obtenir ou créer le mois à l'intérieur de cette année
    Month currentMonth = await _getOrCreateMonth(currentYear, monthName);

    return currentMonth;
  }

  Future<Year> _getOrCreateYear(int yearValue) async {
    Year? year = await _yearRepository.getYear(yearValue);
    if (year == null) {
      final newYear = Year.create(year: yearValue);
      await _yearRepository.saveYear(newYear);
      return newYear;
    }
    return year;
  }

  Future<Month> _getOrCreateMonth(Year year, String monthName) async {
    try {
      // Cherche un mois existant dans la liste de l'année
      return year.months.firstWhere((m) => m.name == monthName);
    } catch (e) {
      // Si le mois n'existe pas, on le crée
      final newMonth = Month.create(name: monthName);
      year.months.add(newMonth);
      await year.save(); // Sauvegarde l'objet Year pour persister la nouvelle relation
      return newMonth;
    }
  }
}
