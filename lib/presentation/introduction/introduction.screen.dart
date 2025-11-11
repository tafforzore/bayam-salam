import 'package:bayamsalam/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionScreenPage extends StatelessWidget {
  const IntroductionScreenPage({super.key});

  // Palette de couleurs cohérente
  static const Color primaryColor = Color(0xFF4361EE);
  static const Color secondaryColor = Color(0xFF3A0CA3);
  static const Color accentColor = Color(0xFF4CC9F0);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF72585);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color onSurfaceColor = Color(0xFF212529);

  void _onIntroEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_intro', true);
    Get.offAllNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        color: onSurfaceColor,
      ),
      bodyTextStyle: const TextStyle(
        fontSize: 18.0,
        color: Color(0xFF666666),
        height: 1.5,
      ),
      bodyPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
      pageColor: surfaceColor,
      imagePadding: EdgeInsets.zero,
      contentMargin: const EdgeInsets.symmetric(horizontal: 16),
      titlePadding: const EdgeInsets.only(top: 40, bottom: 16),
    );

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: IntroductionScreen(
          globalBackgroundColor: surfaceColor,
          pages: [
            PageViewModel(
              title: "Gestion Simplifiée",
              body: "Enregistrez vos produits, suivez vos ventes et gérez vos dépenses en toute simplicité.",
              image: _buildPageImage(
                Icons.inventory_2_outlined,
                primaryColor,
                const Color(0xFFEFF6FF),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Suivi en Temps Réel",
              body: "Visualisez vos performances financières grâce à un tableau de bord intuitif et complet.",
              image: _buildPageImage(
                Icons.analytics_outlined,
                successColor,
                const Color(0xFFF0F9FF),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Bilans Détaillés",
              body: "Analysez vos résultats mois par mois et prenez des décisions éclairées pour votre activité.",
              image: _buildPageImage(
                Icons.assessment_outlined,
                warningColor,
                const Color(0xFFFFFBEB),
              ),
              decoration: pageDecoration,
            ),
          ],
          onDone: _onIntroEnd,
          showSkipButton: false,
          next: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Suivant',
              style: TextStyle(
                color: surfaceColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          done: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [successColor, const Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: successColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Commencer',
              style: TextStyle(
                color: surfaceColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: const Color(0xFFE0E0E0),
            activeSize: const Size(22.0, 10.0),
            activeColor: primaryColor,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          dotsContainerDecorator: const BoxDecoration(
            color: surfaceColor,
          ),
          skip: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Text(
              'Passer',
              style: TextStyle(
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          curve: Curves.fastEaseInToSlowEaseOut,
        ),
      ),
    );
  }

  Widget _buildPageImage(IconData icon, Color iconColor, Color backgroundColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle de fond
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
          ),
          // Icône principale
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  iconColor.withOpacity(0.9),
                  iconColor.withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: surfaceColor,
              size: 64,
            ),
          ),
          // Effet de brillance
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: surfaceColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}