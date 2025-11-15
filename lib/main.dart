import 'package:bayamsalam/infrastructure/dal/di.dart';
import 'package:bayamsalam/infrastructure/navigation/navigation.dart';
import 'package:bayamsalam/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisations cruciales dans l'ordre
  await Hive.initFlutter();
  await DependencyInjection.init();
  await initializeDateFormatting('fr_FR', null);

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false, // Petite amélioration esthétique
        // La route de démarrage est maintenant le splash screen
        initialRoute: Routes.SPLASH,
        getPages: Nav.routes,
      );}
    );
  }
}
