import 'package:get/get.dart';
import '../controllers/sale.controller.dart';

class SaleControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleController>(
      () => SaleController(),
    );
  }
}
