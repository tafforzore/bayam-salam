import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'controllers/transaction.controller.dart';

class TransactionScreen extends GetView<TransactionController> {
  const TransactionScreen({super.key});

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
          'Historique des Transactions',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: surfaceColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: surfaceColor),
        actions: [
          Obx(() => controller.filteredTransactions.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.file_download, size: 22.sp),
            onPressed: _showExportOptions,
            tooltip: 'Exporter',
          )
              : const SizedBox()),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec statistiques
          _buildHeader(),

          // Section Filtres avec nouveau design
          _buildFilterSection(),
          SizedBox(height: 0.3.h),

          // Liste des transactions
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                );
              }
              if (controller.filteredTransactions.isEmpty) {
                return _buildEmptyState();
              }
              return _buildTransactionList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      margin: EdgeInsets.fromLTRB(4.w,1.w,4.w,1.w),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor.withOpacity(0.1), accentColor.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.history, color: primaryColor, size: 20.sp),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Historique Complet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: onSurfaceColor,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Obx(() => Text(
                      '${controller.filteredTransactions.length} transaction(s)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    )),
                  ],
                ),
              ),
              Obx(() {
                final hasActiveFilters =
                    controller.periodFilter.value != PeriodFilter.month ||
                        controller.typeFilter.value != TypeFilter.all;

                return Row(
                  children: [
                    if (hasActiveFilters) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.filter_alt, color: warningColor, size: 14.sp),
                            SizedBox(width: 1.w),
                            Text(
                              'Filtres actifs',
                              style: TextStyle(
                                color: warningColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2.w),
                    ],
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getPeriodLabel(),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête des filtres avec bouton reset
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.tune, color: primaryColor, size: 18.sp),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Filtrer les transactions',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: onSurfaceColor,
                      ),
                    ),
                  ),
                  Obx(() {
                    final hasActiveFilters =
                        controller.periodFilter.value != PeriodFilter.month ||
                            controller.typeFilter.value != TypeFilter.all;

                    return AnimatedOpacity(
                      opacity: hasActiveFilters ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: InkWell(
                        onTap: hasActiveFilters ? _resetFilters : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.refresh, color: Colors.grey.shade600, size: 16.sp),
                              SizedBox(width: 1.w),
                              Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 1.h),

              // Filtre par période - Design horizontal moderne
              _buildPeriodFilter(),
              SizedBox(height: 1.h),

              // Filtre par type - Design horizontal moderne
              _buildTypeFilter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PÉRIODE',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          height: 4.5.h,
          child: Obx(() => ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(width: 1.w),
              _buildPeriodOption(PeriodFilter.day, 'Aujourd\'hui', Icons.today),
              SizedBox(width: 2.w),
              _buildPeriodOption(PeriodFilter.week, 'Cette Semaine', Icons.calendar_view_week),
              SizedBox(width: 2.w),
              _buildPeriodOption(PeriodFilter.month, 'Ce Mois', Icons.calendar_today),
              SizedBox(width: 1.w),
            ],
          )),
        ),
      ],
    );
  }

  Widget _buildPeriodOption(PeriodFilter filter, String label, IconData icon) {
    final isSelected = controller.periodFilter.value == filter;
    return GestureDetector(
      onTap: () => controller.setPeriodFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [primaryColor, primaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? surfaceColor : primaryColor,
              size: 18.sp,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? surfaceColor : onSurfaceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TYPE DE TRANSACTION',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          height: 4.5.h,
          child: Obx(() => ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(width: 1.w),
              _buildTypeOption(TypeFilter.all, 'Toutes', Icons.all_inclusive, primaryColor),
              SizedBox(width: 2.w),
              _buildTypeOption(TypeFilter.sales, 'Ventes', Icons.trending_up, successColor),
              SizedBox(width: 2.w),
              _buildTypeOption(TypeFilter.expenses, 'Dépenses', Icons.trending_down, errorColor),
              SizedBox(width: 1.w),
            ],
          )),
        ),
      ],
    );
  }

  Widget _buildTypeOption(TypeFilter filter, String label, IconData icon, Color color) {
    final isSelected = controller.typeFilter.value == filter;
    return GestureDetector(
      onTap: () => controller.setTypeFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.1.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? surfaceColor : color,
              size: 18.sp,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? surfaceColor : onSurfaceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: ListView.builder(
        itemCount: controller.filteredTransactions.length,
        itemBuilder: (context, index) {
          final item = controller.filteredTransactions[index];
          final isSale = controller.isSale(item);
          final date = controller.getTransactionDate(item);
          final color = isSale ? successColor : errorColor;
          final icon = isSale ? Icons.trending_up : Icons.trending_down;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 0.1.h, horizontal: 2.w),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: .5.h),
                  leading: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: surfaceColor, size: 20.sp),
                  ),
                  title: Text(
                    controller.getTransactionTitle(item),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: onSurfaceColor,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: Text(
                      DateFormat('EEE dd MMM yyyy • HH:mm').format(date),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        controller.getTransactionAmount(item),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isSale ? 'VENTE' : 'DÉPENSE',
                          style: TextStyle(
                            color: color,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.1), accentColor.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off, size: 40.sp, color: primaryColor),
          ),
          SizedBox(height: 3.h),
          Text(
            'Aucune transaction trouvée',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: onSurfaceColor,
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'Aucune transaction ne correspond aux critères de filtrage sélectionnés.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.setPeriodFilter(PeriodFilter.month);
                    controller.setTypeFilter(TypeFilter.all);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                  ),
                  icon: Icon(Icons.refresh, color: surfaceColor, size: 18.sp),
                  label: Text(
                    'Réinitialiser les filtres',
                    style: TextStyle(
                      color: surfaceColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    controller.setPeriodFilter(PeriodFilter.month);
    controller.setTypeFilter(TypeFilter.all);
  }

  void _showExportOptions() {
    Get.dialog(
      AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Row(
          children: [
            Icon(Icons.file_download, color: primaryColor, size: 24.sp),
            SizedBox(width: 3.w),
            Text(
              'Exporter l\'historique',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: onSurfaceColor,
              ),
            ),
          ],
        ),
        content: Text(
          'Choisissez le format d\'exportation pour vos transactions.',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [successColor, successColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                // TODO: Implémenter l'export
                Get.snackbar(
                  'Export réussi',
                  'Vos transactions ont été exportées',
                  backgroundColor: successColor,
                  colorText: surfaceColor,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Exporter en PDF',
                style: TextStyle(
                  color: surfaceColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPeriodLabel() {
    switch (controller.periodFilter.value) {
      case PeriodFilter.day:
        return 'Aujourd\'hui';
      case PeriodFilter.week:
        return 'Cette semaine';
      case PeriodFilter.month:
        return 'Ce mois';
      default:
        return 'Période';
    }
  }
}