import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'controllers/expense.controller.dart';

class ExpenseScreen extends GetView<ExpenseController> {
  const ExpenseScreen({super.key});

  // Utilisation de la même palette de couleurs que HomeScreen
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Gestion des Dépenses',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        iconTheme: const IconThemeData(color: surfaceColor),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        return Column(
          children: [
            // Formulaire avec carte
            Card(
              margin: EdgeInsets.all(4.w),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: _buildExpenseForm(context),
              ),
            ),

            // Séparateur stylisé
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Divider(
                height: 4.h,
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ),

            // En-tête des dépenses
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                children: [
                  Icon(Icons.receipt_long, color: primaryColor, size: 22.sp),
                  SizedBox(width: 2.w),
                  Text(
                    'Dépenses du Mois',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: onSurfaceColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${controller.expenses.length} dépense(s)',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            // Liste des dépenses
            Expanded(
              child: _buildExpensesList(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildExpenseForm(BuildContext context) {
    return Column(
      children: [
        // En-tête du formulaire
        Row(
          children: [
            Icon(
              controller.isEditing.value ? Icons.edit_note : Icons.add_circle,
              color: controller.isEditing.value ? warningColor : primaryColor,
              size: 24.sp,
            ),
            SizedBox(width: 2.w),
            Text(
              controller.isEditing.value ? 'Modifier la dépense' : 'Nouvelle dépense',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: onSurfaceColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Champ description
        TextFormField(
          controller: controller.descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
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
            prefixIcon: Icon(Icons.description, color: primaryColor, size: 20.sp),
          ),
          style: TextStyle(color: onSurfaceColor, fontSize: 14.sp),
        ),
        SizedBox(height: 2.h),

        // Catégorie
        DropdownButtonFormField<ExpenseCategory>(
          value: controller.selectedCategory.value,
          hint: Text(
            'Catégorie',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
          ),
          onChanged: (value) {
            if (value != null) {
              controller.selectedCategory.value = value;
            }
          },
          items: ExpenseCategory.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(category),
                    color: primaryColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _getCategoryName(category),
                    style: TextStyle(color: onSurfaceColor, fontSize: 14.sp),
                  ),
                ],
              ),
            );
          }).toList(),
          decoration: InputDecoration(
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
          dropdownColor: surfaceColor,
          style: TextStyle(color: onSurfaceColor, fontSize: 14.sp),
        ),
        SizedBox(height: 2.h),

        // Montant
        TextFormField(
          controller: controller.amountController,
          decoration: InputDecoration(
            labelText: 'Montant',
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
            prefixIcon: Icon(Icons.money_outlined, color: primaryColor, size: 20.sp),
            suffixText: 'FCFA',
            suffixStyle: TextStyle(
              color: onSurfaceColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          keyboardType: TextInputType.number,
          style: TextStyle(color: onSurfaceColor, fontSize: 14.sp),
        ),
        SizedBox(height: 3.h),

        // Bouton d'action
        Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: controller.isEditing.value
                  ? [warningColor, warningColor.withOpacity(0.8)]
                  : [successColor, successColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (controller.isEditing.value ? warningColor : successColor).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            icon: Icon(
              controller.isEditing.value ? Icons.edit : Icons.add,
              color: surfaceColor,
              size: 20.sp,
            ),
            label: Text(
              controller.isEditing.value ? 'Modifier la dépense' : 'Ajouter la dépense',
              style: TextStyle(
                color: surfaceColor,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            onPressed: () {
              controller.isEditing.value ? controller.updateExpense() : controller.addExpense();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // Bouton annuler en mode édition
        if (controller.isEditing.value) ...[
          SizedBox(height: 1.h),
          TextButton.icon(
            icon: Icon(Icons.cancel_outlined, size: 18.sp),
            label: Text(
              'Annuler',
              style: TextStyle(fontSize: 14.sp),
            ),
            onPressed: () => _cancelEditing(),
            style: TextButton.styleFrom(
              foregroundColor: errorColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExpensesList() {
    if (controller.expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.money_off,
              size: 70.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 2.h),
            Text(
              'Aucune dépense ce mois-ci',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Ajoutez votre première dépense',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: ListView.builder(
        itemCount: controller.expenses.length,
        itemBuilder: (context, index) {
          final expense = controller.expenses[index];
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: buildExpenseCard(
                expense: expense,
                primaryColor: primaryColor,
                errorColor: errorColor,
                warningColor: warningColor,
                onSurfaceColor: onSurfaceColor,
                getCategoryIcon: _getCategoryIcon,
                getCategoryName: _getCategoryName,
                onEdit: (exp) => controller.startEditing(exp),
                onDelete: (exp) => _showDeleteDialog(exp),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildExpenseCard({
    required Expense expense,
    required Color primaryColor,
    required Color errorColor,
    required Color warningColor,
    required Color onSurfaceColor,
    required IconData Function(ExpenseCategory category) getCategoryIcon,
    required String Function(ExpenseCategory category) getCategoryName,
    required Function(Expense expense) onEdit,
    required Function(Expense expense) onDelete,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône de la catégorie
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              getCategoryIcon(expense.category),
              color: errorColor,
              size: 20.sp,
            ),
          ),

          SizedBox(width: 3.w),

          // Détails du texte (description, catégorie, date)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 1.h),

                // Catégorie en badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    getCategoryName(expense.category),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                // Date complète
                Text(
                  DateFormat('dd/MM/yyyy à HH:mm').format(expense.createdAt),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 2.w),

          // Montant + boutons d'action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${expense.amount.toStringAsFixed(2)} FCFA',
                style: TextStyle(
                  color: errorColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                DateFormat('dd/MM').format(expense.createdAt),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(height: 1.h),

              // Boutons édition + suppression
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_note, color: warningColor, size: 20.sp),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => onEdit(expense),
                  ),
                  SizedBox(width: 1.w),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: errorColor, size: 20.sp),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => onDelete(expense),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Méthodes d'aide pour les catégories
  String _getCategoryName(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.supplies:
        return 'Fournitures';
      case ExpenseCategory.equipment:
        return 'Équipement';
      case ExpenseCategory.salary:
        return 'Salaire';
      case ExpenseCategory.rent:
        return 'Loyer';
      case ExpenseCategory.utilities:
        return 'Services publics';
      case ExpenseCategory.marketing:
        return 'Marketing';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.other:
        return 'Autre';
      default:
        return 'Autre';
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.supplies:
        return Icons.inventory_2;
      case ExpenseCategory.equipment:
        return Icons.computer;
      case ExpenseCategory.salary:
        return Icons.people;
      case ExpenseCategory.rent:
        return Icons.home;
      case ExpenseCategory.utilities:
        return Icons.bolt;
      case ExpenseCategory.marketing:
        return Icons.campaign;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.other:
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  // Méthode pour annuler l'édition
  void _cancelEditing() {
    controller.isEditing.value = false;
    controller.descriptionController.clear();
    controller.amountController.clear();
  }

  void _showDeleteDialog(Expense expense) {
    Get.dialog(
      AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: errorColor, size: 22.sp),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Confirmer la suppression',
                style: TextStyle(
                    color: onSurfaceColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer la dépense "${expense.description}" ?',
          style: TextStyle(color: onSurfaceColor, fontSize: 14.sp),
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
                colors: [errorColor, errorColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                controller.deleteExpense(expense);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Supprimer',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}