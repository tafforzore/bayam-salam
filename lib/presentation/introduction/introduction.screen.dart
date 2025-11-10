import 'package:bayamsalam/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionScreenPage extends StatelessWidget {
  const IntroductionScreenPage({super.key});

  void _onIntroEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_intro', true);
    Get.offAllNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 19.0),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Gestion Facile",
          body: "Enregistrez vos produits, ventes et dépenses en quelques secondes.",
          image: const Center(child: Icon(Icons.shopping_cart_outlined, size: 120.0, color: Colors.blue)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Suivi en Temps Réel",
          body: "Votre tableau de bord vous donne une vue d'ensemble de votre activité financière.",
          image: const Center(child: Icon(Icons.dashboard_outlined, size: 120.0, color: Colors.green)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Bilans Détaillés",
          body: "Analysez vos performances mois par mois pour prendre les meilleures décisions.",
          image: const Center(child: Icon(Icons.assessment_outlined, size: 120.0, color: Colors.orange)),
          decoration: pageDecoration,
        ),
      ],
      onDone: _onIntroEnd,
      // CORRECTION : Le bouton "Passer" est retiré
      showSkipButton: false,
      next: const Text('Suivant', style: TextStyle(fontWeight: FontWeight.w600)),
      done: const Text('Terminer', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
