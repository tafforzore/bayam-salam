import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'controllers/dashboard.controller.dart';

class HomeScreen extends GetView<DashboardController> {
  const HomeScreen({super.key});

  // Palette de couleurs cohérente
  static const Color primaryColor = Color(0xFF4361EE); // Bleu moderne
  static const Color secondaryColor = Color(0xFF3A0CA3); // Bleu foncé
  static const Color accentColor = Color(0xFF4CC9F0); // Bleu clair
  static const Color successColor = Color(0xFF4CAF50); // Vert
  static const Color warningColor = Color(0xFFFF9800); // Orange
  static const Color errorColor = Color(0xFFF72585); // Rose/Rouge
  static const Color backgroundColor = Color(0xFFF8F9FA); // Gris très clair
  static const Color surfaceColor = Color(0xFFFFFFFF); // Blanc
  static const Color onSurfaceColor = Color(0xFF212529); // Gris foncé

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Tableau de Bord',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: surfaceColor, size: 22.sp),
            onPressed: () => controller.loadDashboard(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.stats.value.recentTransactions.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        return RefreshIndicator(
          backgroundColor: primaryColor,
          color: surfaceColor,
          onRefresh: controller.loadDashboard,
          child: ListView(
            padding: EdgeInsets.all(2.h),
            children: [
              // En-tête du mois
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: primaryColor, size: 22.sp),
                    SizedBox(width: 3.w),
                    Text(
                      'Résumé de ${controller.currentMonthName.value}',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: onSurfaceColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.h),

              // Cartes de résumé
              _buildSummaryCards(),
              SizedBox(height: 2.h),

              // Section Actions Rapides
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.rocket_launch,
                          color: primaryColor,
                          size: 22.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Actions Rapides',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: onSurfaceColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.3.h),
                    _buildQuickActions(),
                  ],
                ),
              ),
              SizedBox(height: 0.9.h),

              // Section Transactions Récentes
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long, color: primaryColor, size: 22.sp),
                        SizedBox(width: 2.w),
                        Text(
                          'Transactions Récentes',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: onSurfaceColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    _buildRecentTransactions(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards() {
    final stats = controller.stats.value;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 2.w,
      mainAxisSpacing: 1.5.h,
      childAspectRatio: 1.4,
      children: [
        _SummaryCard(
          title: 'Revenus',
          amount: stats.totalIncome,
          icon: Icons.arrow_upward,
          color: successColor,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          ),
        ),
        _SummaryCard(
          title: 'Dépenses',
          amount: stats.totalExpenses,
          icon: Icons.arrow_downward,
          color: errorColor,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF72585), Color(0xFFF06292)],
          ),
        ),
        _SummaryCard(
          title: 'Bénéfice Net',
          amount: stats.netProfit,
          icon: Icons.monetization_on,
          color: stats.netProfit >= 0 ? primaryColor : warningColor,
          gradient: stats.netProfit >= 0
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4361EE), Color(0xFF4CC9F0)],
          )
              : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          ),
        ),
        _SummaryCard(
          title: 'Produit acheté',
          amount: stats.totalProductCost,
          icon: Icons.monetization_on,
          color: stats.netProfit >= 0 ? errorColor : warningColor,
          gradient: stats.netProfit >= 0
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4361EE), Color(0xFF4CC9F0)],
          )
              : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF72695B), Color(0xFF5FDD04)],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GridView(
          padding: EdgeInsets.all(4.w),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
          ),
          children: [
            _QuickActionButton(
              icon: Icons.add_shopping_cart,
              label: 'Vente',
              onPressed: () => Get.toNamed(Routes.SALE),
              color: primaryColor,
            ),
            _QuickActionButton(
              icon: Icons.inventory_2,
              label: 'Produits',
              onPressed: () => Get.toNamed(Routes.PRODUCT),
              color: secondaryColor,
            ),
            _QuickActionButton(
              icon: Icons.post_add,
              label: 'Dépense',
              onPressed: () => Get.toNamed(Routes.EXPENSE),
              color: warningColor,
            ),
            _QuickActionButton(
              icon: Icons.assessment,
              label: 'Bilan',
              onPressed: () => Get.toNamed(Routes.REPORT),
              color: successColor,
            ),
            _QuickActionButton(
              icon: Icons.history_toggle_off_rounded,
              label: 'Historique',
              onPressed: () => Get.toNamed(Routes.TRANSACTION),
              color: successColor,
            ),
            _QuickActionButton(
              icon: Icons.info,
              label: 'Info',
              onPressed: () => Get.toNamed(Routes.INFO),
              color: successColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = controller.stats.value.recentTransactions;
    if (transactions.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Column(
              children: [
                Icon(Icons.receipt, size: 70.sp, color: Colors.grey.shade300),
                SizedBox(height: 2.h),
                Text(
                  'Aucune transaction ce mois-ci',
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16.sp
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final item = transactions[index];
        final isSale = controller.isSale(item);
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: buildTransactionCard(
              item: item,
              isSale: isSale,
              successColor: Colors.green,
              errorColor: Colors.red,
              onSurfaceColor: Colors.black87,
              controller: controller,
            ),
          ),
        );
      },
    );
  }
}

Widget buildTransactionCard({
  required dynamic item,
  required bool isSale,
  required Color successColor,
  required Color errorColor,
  required Color onSurfaceColor,
  required controller,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 0.5.h),
    padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 0.5.h),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône transaction
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: (isSale ? successColor : errorColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSale ? Icons.point_of_sale : Icons.receipt_long_rounded,
                color: isSale ? successColor : errorColor,
                size: 20.sp,
              ),
            ),

            SizedBox(width: 3.w),

            // Texte principal (titre + date)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.getTransactionTitle(item),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: onSurfaceColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                ],
              ),
            ),
          ],
        ),
        // Montant
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              controller.getTransactionAmount(item),
              style: TextStyle(
                color: isSale ? successColor : errorColor,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat(
                "le dd/MM/yyyy à HH:mm",
              ).format(controller.getTransactionDate(item)),
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    ),
  );
}

// Widgets internes améliorés
class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final Gradient gradient;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20.sp),
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${amount.toString()} FCFA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.7.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
            icon: Icon(icon, size: 20.sp),
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: HomeScreen.onSurfaceColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}