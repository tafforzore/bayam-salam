import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/infrastructure/dal/stores/report_store.dart';
import 'package:bayamsalam/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

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
        title: Text(
          'Bilan Mensuel',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: surfaceColor),
        actions: [
          IconButton(
            icon: Icon(Icons.download, size: 22.sp),
            onPressed: () => _showExportOptions(),
            tooltip: 'Exporter le rapport',
          ),
        ],
      ),
      body: Column(
        children: [
          // Sélecteurs de date améliorés
          _buildDateSelector(),
          SizedBox(height: 1.h),

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
      margin: EdgeInsets.all(4.w),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 2.h),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: primaryColor, size: 20.sp),
                SizedBox(width: 2.w),
                Text(
                  'Période du rapport',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
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
                            Icon(Icons.calendar_month, color: primaryColor, size: 18.sp),
                            SizedBox(width: 2.w),
                            Text(
                              y.toString(),
                              style: TextStyle(color: onSurfaceColor, fontSize: 14.sp),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => controller.changeYear(val),
                    decoration: InputDecoration(
                      labelText: 'Année',
                      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
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
                    style: TextStyle(fontSize: 14.sp),
                  )),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedMonth.value,
                    items: controller.availableMonths.map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Row(
                          children: [
                            Icon(Icons.date_range, color: primaryColor, size: 18.sp),
                            SizedBox(width: 2.w),
                            Text(
                              m,
                              style: TextStyle(color: onSurfaceColor, fontSize: 14.sp),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => controller.changeMonth(val),
                    decoration: InputDecoration(
                      labelText: 'Mois',
                      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
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
                    style: TextStyle(fontSize: 14.sp),
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
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Cartes de résumé
          _buildSummaryCards(report, netColor),
          SizedBox(height: 3.h),

          // Section Ventes
          _buildSalesSection(report),
          SizedBox(height: 3.h),

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
              padding: EdgeInsets.all(5.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: netColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          report.netResult >= 0 ? Icons.trending_up : Icons.trending_down,
                          color: netColor,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bilan Mensuel',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              '${controller.selectedMonth.value} ${controller.selectedYear.value}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: onSurfaceColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: netColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${report.netResult >= 0 ? '+' : ''}${report.netResult.toStringAsFixed(2)} FCFA',
                          style: TextStyle(
                            color: surfaceColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
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
                      SizedBox(width: 4.w),
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
        SizedBox(height: 2.h),

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
            SizedBox(width: 3.w),
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
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.trending_up, color: successColor, size: 18.sp),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Revenus',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${report.sales.length} vente(s)',
                    style: TextStyle(
                      color: successColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

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
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.trending_down, color: errorColor, size: 18.sp),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Dépenses',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${report.expenses.length} dépense(s)',
                    style: TextStyle(
                      color: errorColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

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
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: buildTransactionCard(
          icon: isSale ? Icons.point_of_sale : Icons.receipt_long_rounded,
          title: title,
          date: date,
          amount: amount,
          isSale: isSale,
          color: isSale ? Colors.green : Colors.red,
          onSurfaceColor: Colors.black87,
        ),
      ),
    );
  }

  Widget buildTransactionCard({
    required IconData icon,
    required String title,
    required DateTime date,
    required double amount,
    required bool isSale,
    required Color color,
    required Color onSurfaceColor,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône à gauche
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18.sp),
          ),

          SizedBox(width: 3.w),

          // Titre + date principale
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: onSurfaceColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy à HH:mm').format(date),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${isSale ? '+' : '-'}${amount.toStringAsFixed(2)} FCFA',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assessment, size: 40.sp, color: primaryColor),
          ),
          SizedBox(height: 3.h),
          Text(
            'Aucune donnée disponible',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: onSurfaceColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Aucune transaction pour la période sélectionnée',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactionState(String message, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            children: [
              Icon(icon, size: 50.sp, color: Colors.grey.shade300),
              SizedBox(height: 2.h),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showExportOptions() {
    Get.dialog(
      AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.download, color: primaryColor, size: 22.sp),
            SizedBox(width: 3.w),
            Text(
              'Exporter le rapport',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: onSurfaceColor,
              ),
            ),
          ],
        ),
        content: Text(
          'Choisissez le format d\'exportation pour le rapport de ${controller.selectedMonth.value} ${controller.selectedYear.value}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
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
              child: Text(
                'PDF',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
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
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: ReportScreen.backgroundColor,
        borderRadius: BorderRadius.circular(5),
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
              Icon(icon, color: color, size: 14.sp),
              SizedBox(width: 1.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            '${value.toStringAsFixed(2)} FCFA',
            style: TextStyle(
              fontSize: 14.sp,
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
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey,
                    fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}