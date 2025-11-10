import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/domain/core/entities/year.dart';
import 'package:bayamsalam/infrastructure/dal/stores/dashboard_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/expense_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/month_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/product_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/report_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/sale_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/year_store.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Adapters
    Hive.registerAdapter(YearAdapter());
    Hive.registerAdapter(MonthAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(ProductSaleAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(ExpenseCategoryAdapter());

    // Boxes
    final yearBox = await Hive.openBox<Year>('years');
    await Hive.openBox<Month>('months');
    await Hive.openBox<Product>('products');
    await Hive.openBox<ProductSale>('product_sales');
    await Hive.openBox<Expense>('expenses');

    // Stores
    Get.put(YearStore(yearBox));
    Get.put(MonthStore());
    Get.put(ProductStore());
    Get.put(SaleStore());
    Get.put(ExpenseStore());
    Get.put(DashboardStore());
    Get.put(ReportStore()); // Ajout du nouveau store
  }
}
