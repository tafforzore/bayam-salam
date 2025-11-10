import 'package:get/get.dart';
import '../controllers/expense.controller.dart';

class ExpenseControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseController>(
      () => ExpenseController(),
    );
  }
}
