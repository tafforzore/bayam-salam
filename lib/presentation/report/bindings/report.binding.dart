import 'package:get/get.dart';
import '../controllers/report.controller.dart';

class ReportControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(
      () => ReportController(),
    );
  }
}
