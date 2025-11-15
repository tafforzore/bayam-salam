import 'package:bayamsalam/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

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
      titleTextStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: onSurfaceColor,
        height: 1.2,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16.sp,
        color: const Color(0xFF666666),
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
      bodyPadding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 0),
      pageColor: surfaceColor,
      imagePadding: EdgeInsets.zero,
      contentMargin: EdgeInsets.symmetric(horizontal: 2.w),
      titlePadding: EdgeInsets.only(top: 6.h, bottom: 2.h),
      footerPadding: EdgeInsets.symmetric(horizontal: 4.w),
    );

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: IntroductionScreen(
          globalBackgroundColor: surfaceColor,
          pages: [
            PageViewModel(
              title: "Gestion Simplifiée",
              body: "Enregistrez vos produits, suivez vos ventes et gérez vos dépenses en toute simplicité avec une interface intuitive conçue pour vous.",
              image: _buildEnhancedPageImage(
                Icons.inventory_2_outlined,
                primaryColor,
                const Color(0xFFEFF6FF),
                "01",
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Suivi en Temps Réel",
              body: "Visualisez vos performances financières grâce à un tableau de bord interactif qui vous donne une vision claire de votre activité.",
              image: _buildEnhancedPageImage(
                Icons.analytics_outlined,
                successColor,
                const Color(0xFFF0F9FF),
                "02",
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Bilans Détaillés",
              body: "Analysez vos résultats mois par mois et prenez des décisions éclairées pour développer votre activité efficacement.",
              image: _buildEnhancedPageImage(
                Icons.assessment_outlined,
                warningColor,
                const Color(0xFFFFFBEB),
                "03",
              ),
              decoration: pageDecoration,
            ),
          ],
          onDone: _onIntroEnd,
          showSkipButton: true,
          skip: _buildTextButton("Passer", const Color(0xFF666666)),
          next: _buildElevatedButton("Suivant", primaryColor),
          done: _buildGradientButton("Terminer", successColor),
          dotsDecorator: DotsDecorator(
            size: Size(3.w, 3.w),
            color: const Color(0xFFE0E0E0),
            activeSize: Size(8.w, 3.w),
            activeColor: primaryColor,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            spacing: EdgeInsets.symmetric(horizontal: 1.w),
          ),
          dotsContainerDecorator: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          curve: Curves.fastEaseInToSlowEaseOut,
          controlsMargin: EdgeInsets.all(4.w),
          controlsPadding: EdgeInsets.all(2.w),
        ),
      ),
    );
  }

  Widget _buildEnhancedPageImage(IconData icon, Color iconColor, Color backgroundColor, String stepNumber) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle de fond décoratif
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
          ),

          // Cercle principal avec gradient
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  iconColor,
                  Color.lerp(iconColor, Colors.white, 0.2)!,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Effet de brillance
                Positioned(
                  top: 10.w,
                  left: 10.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: surfaceColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Icône principale
                Center(
                  child: Icon(
                    icon,
                    color: surfaceColor,
                    size: 28.sp,
                  ),
                ),
              ],
            ),
          ),

          // Numéro d'étape
          Positioned(
            top: 2.h,
            right: 10.w,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: surfaceColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: surfaceColor,
          fontWeight: FontWeight.w700,
          fontSize: 15.sp,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            Color.lerp(color, Colors.white, 0.2)!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: surfaceColor,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}