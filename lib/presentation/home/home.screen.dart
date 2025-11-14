import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
        title: const Text(
          'Tableau de Bord',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: surfaceColor),
            onPressed: () => controller.loadDashboard(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.stats.value.recentTransactions.isEmpty) {
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
            padding: const EdgeInsets.all(10.0),
            children: [
              // En-tête du mois
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    Icon(Icons.calendar_today, color: primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Résumé de ${controller.currentMonthName.value}',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: onSurfaceColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Cartes de résumé
              _buildSummaryCards(),
              const SizedBox(height: 8),

              // Section Actions Rapides
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        Icon(Icons.rocket_launch, color: primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Actions Rapides',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: onSurfaceColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildQuickActions(),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Section Transactions Récentes
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        Icon(Icons.receipt_long, color: primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Transactions Récentes',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: onSurfaceColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Icon(Icons.receipt, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'Aucune transaction ce mois-ci',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
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
          margin: const EdgeInsets.only(bottom: 5),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child:  buildTransactionCard(
              item: item,
              isSale: isSale,
              successColor: Colors.green,
              errorColor: Colors.red,
              onSurfaceColor: Colors.black87,
              controller: controller,
            )
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
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.fromLTRB(6, 6, 6, 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône transaction
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isSale ? successColor : errorColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSale ? Icons.point_of_sale : Icons.receipt_long_rounded,
                color: isSale ? successColor : errorColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // Texte principal (titre + date)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.getTransactionTitle(item),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: onSurfaceColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
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
                fontSize: 15,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat("le dd/MM/yyyy à HH:mm")
                  .format(controller.getTransactionDate(item)),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${amount.toString()} FCFA',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
            icon: Icon(icon, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: HomeScreen.onSurfaceColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}