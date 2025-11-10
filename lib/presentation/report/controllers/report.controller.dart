import 'package:bayamsalam/domain/core/entities/year.dart';
import 'package:bayamsalam/infrastructure/dal/stores/report_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/year_store.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {
  final YearStore _yearStore = Get.find();
  final ReportStore _reportStore = Get.find();

  final isLoading = true.obs;
  final report = Rxn<MonthlyReport>();

  // Listes pour les Dropdowns
  final availableYears = <int>[].obs;
  final availableMonths = <String>[].obs;

  // État de la sélection
  final selectedYear = Rxn<int>();
  final selectedMonth = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _initializeAndLoadReport();
  }

  Future<void> _initializeAndLoadReport() async {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = DateFormat.MMMM('fr_FR').format(now);

    // Initialise les listes pour les sélecteurs
    final allYears = await Hive.box<Year>('years').values.toList();
    availableYears.assignAll(allYears.map((y) => y.year).toSet().toList()..sort((a,b)=>b.compareTo(a)));

    await changeYear(currentYear, shouldLoad: false);
    await changeMonth(currentMonth);
  }

  Future<void> changeYear(int? year, {bool shouldLoad = true}) async {
    if (year == null) return;
    selectedYear.value = year;
    
    final yearObject = await _yearStore.getByYearValue(year);
    if (yearObject != null) {
      availableMonths.assignAll(yearObject.months.map((m) => m.name).toSet().toList());
    }

    if (shouldLoad && availableMonths.isNotEmpty) {
      changeMonth(availableMonths.first);
    }
  }

  Future<void> changeMonth(String? monthName) async {
    if (selectedYear.value == null || monthName == null) return;
    selectedMonth.value = monthName;
    loadReport();
  }

  Future<void> loadReport() async {
    isLoading.value = true;
    report.value = null;
    try {
      final yearObject = await _yearStore.getByYearValue(selectedYear.value!);
      if (yearObject != null) {
        final monthObject = yearObject.months.firstWhere((m) => m.name == selectedMonth.value);
        report.value = _reportStore.generateReportForMonth(monthObject);
      }
    } catch (e) {
      // Pas de données, c'est normal. Pas besoin de snackbar.
    } finally {
      isLoading.value = false;
    }
  }
}
