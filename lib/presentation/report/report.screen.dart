import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/infrastructure/dal/stores/report_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controllers/report.controller.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Bilan Mensuel',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: surfaceColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _showExportOptions(),
            tooltip: 'Exporter le rapport',
          ),
        ],
      ),
      body: Column(
        children: [
          // Sélecteurs de date améliorés
          _buildDateSelector(),
          const SizedBox(height: 8),

          // Affichage du rapport
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                );
              }
              if (controller.report.value == null) {
                return _buildEmptyState();
              }
              return _buildReportView(context);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Période du rapport',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButtonFormField<int>(
                    value: controller.selectedYear.value,
                    items: controller.availableYears.map((y) {
                      return DropdownMenuItem(
                        value: y,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month, color: primaryColor, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              y.toString(),
                              style: TextStyle(color: onSurfaceColor),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => controller.changeYear(val),
                    decoration: InputDecoration(
                      labelText: 'Année',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedMonth.value,
                    items: controller.availableMonths.map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Row(
                          children: [
                            Icon(Icons.date_range, color: primaryColor, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              m,
                              style: TextStyle(color: onSurfaceColor),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => controller.changeMonth(val),
                    decoration: InputDecoration(
                      labelText: 'Mois',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportView(BuildContext context) {
    final report = controller.report.value!;
    final netColor = report.netResult >= 0 ? successColor : errorColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Cartes de résumé
          _buildSummaryCards(report, netColor),
          const SizedBox(height: 24),

          // Section Ventes
          _buildSalesSection(report),
          const SizedBox(height: 24),

          // Section Dépenses
          _buildExpensesSection(report),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(MonthlyReport report, Color netColor) {
    return Column(
      children: [
        // Carte principale du bilan
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  netColor.withOpacity(0.1),
                  netColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: netColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          report.netResult >= 0 ? Icons.trending_up : Icons.trending_down,
                          color: netColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bilan Mensuel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              '${controller.selectedMonth.value} ${controller.selectedYear.value}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: onSurfaceColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: netColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${report.netResult >= 0 ? '+' : ''}${report.netResult.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            color: surfaceColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryItem(
                          title: 'Revenus',
                          value: report.totalRevenue,
                          color: successColor,
                          icon: Icons.arrow_upward,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryItem(
                          title: 'Dépenses',
                          value: report.totalExpenses,
                          color: errorColor,
                          icon: Icons.arrow_downward,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Cartes de statistiques détaillées
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Nombre de Ventes',
                value: report.sales.length.toString(),
                subtitle: 'Transactions',
                color: successColor,
                icon: Icons.shopping_cart,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Nombre de Dépenses',
                value: report.expenses.length.toString(),
                subtitle: 'Transactions',
                color: errorColor,
                icon: Icons.receipt_long,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesSection(MonthlyReport report) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.trending_up, color: successColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Revenus',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${report.sales.length} vente(s)',
                    style: TextStyle(
                      color: successColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (report.sales.isEmpty)
              _buildEmptyTransactionState('Aucune vente cette période', Icons.shopping_cart)
            else
              Column(
                children: report.sales.map((sale) => _buildTransactionTile(sale, true)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesSection(MonthlyReport report) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.trending_down, color: errorColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Dépenses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${report.expenses.length} dépense(s)',
                    style: TextStyle(
                      color: errorColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (report.expenses.isEmpty)
              _buildEmptyTransactionState('Aucune dépense cette période', Icons.receipt_long)
            else
              Column(
                children: report.expenses.map((expense) => _buildTransactionTile(expense, false)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(dynamic item, bool isSale) {
    final title = isSale ? 'Vente produit' : (item as Expense).description;
    final amount = isSale ? (item as ProductSale).salePrice : (item as Expense).amount;
    final date = isSale ? (item as ProductSale).saleDate : (item as Expense).createdAt;
    final color = isSale ? successColor : errorColor;
    final icon = isSale ? Icons.point_of_sale : Icons.receipt;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: onSurfaceColor,
            ),
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy à HH:mm').format(date),
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isSale ? '+' : '-'}${amount.toStringAsFixed(2)} €',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('dd/MM').format(date),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assessment, size: 48, color: primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune donnée disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: onSurfaceColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aucune transaction pour la période sélectionnée',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactionState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showExportOptions() {
    Get.dialog(
      AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.download, color: primaryColor),
            const SizedBox(width: 12),
            Text(
              'Exporter le rapport',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: onSurfaceColor,
              ),
            ),
          ],
        ),
        content: Text(
          'Choisissez le format d\'exportation pour le rapport de ${controller.selectedMonth.value} ${controller.selectedYear.value}',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [successColor, successColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                // TODO: Implémenter l'export PDF
                Get.snackbar(
                  'Export PDF',
                  'Fonctionnalité à implémenter',
                  backgroundColor: successColor,
                  colorText: surfaceColor,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'PDF',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pour les éléments de résumé
class _SummaryItem extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final IconData icon;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ReportScreen.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(2)} €',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Carte de statistiques
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}