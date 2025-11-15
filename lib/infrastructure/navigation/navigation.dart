import 'package:bayamsalam/presentation/expense/bindings/expense.binding.dart';
import 'package:bayamsalam/presentation/expense/expense.screen.dart';
import 'package:bayamsalam/presentation/home/bindings/dashboard.binding.dart';
import 'package:bayamsalam/presentation/home/home.screen.dart';
import 'package:bayamsalam/presentation/info/info_screen.dart';
import 'package:bayamsalam/presentation/introduction/introduction.screen.dart';
import 'package:bayamsalam/presentation/product/bindings/product.binding.dart';
import 'package:bayamsalam/presentation/product/product.screen.dart';
import 'package:bayamsalam/presentation/report/bindings/report.binding.dart';
import 'package:bayamsalam/presentation/report/report.screen.dart';
import 'package:bayamsalam/presentation/sale/bindings/sale.binding.dart';
import 'package:bayamsalam/presentation/sale/sale.screen.dart';
import 'package:bayamsalam/presentation/splash/splash.screen.dart';
import 'package:bayamsalam/presentation/transaction/bindings/transaction.binding.dart';
import 'package:bayamsalam/presentation/transaction/transaction.screen.dart';
import 'package:get/get.dart';

import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
    GetPage(name: Routes.INTRODUCTION, page: () => const IntroductionScreenPage()),
    GetPage(name: Routes.INFO, page: () => const InfoScreen()),
    GetPage(name: Routes.HOME, page: () => const HomeScreen(), binding: DashboardBinding()),
    GetPage(name: Routes.PRODUCT, page: () => const ProductScreen(), binding: ProductControllerBinding()),
    GetPage(name: Routes.SALE, page: () => const SaleScreen(), binding: SaleControllerBinding()),
    GetPage(name: Routes.EXPENSE, page: () => const ExpenseScreen(), binding: ExpenseControllerBinding()),
    GetPage(name: Routes.REPORT, page: () => const ReportScreen(), binding: ReportControllerBinding()),
    GetPage(name: Routes.TRANSACTION, page: () => const TransactionScreen(), binding: TransactionControllerBinding(), transition: Transition.rightToLeftWithFade),
  ];
}
