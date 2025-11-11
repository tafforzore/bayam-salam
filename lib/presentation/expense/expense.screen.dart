import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
        title: const Text(
          'Gestion des Dépenses',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
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
              margin: const EdgeInsets.all(16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildExpenseForm(context),
              ),
            ),

            // Séparateur stylisé
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(
                height: 32,
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ),

            // En-tête des dépenses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(Icons.receipt_long, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Dépenses du Mois',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: onSurfaceColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${controller.expenses.length} dépense(s)',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

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
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              controller.isEditing.value ? 'Modifier la dépense' : 'Nouvelle dépense',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: onSurfaceColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Champ description
        TextFormField(
          controller: controller.descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
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
            prefixIcon: Icon(Icons.description, color: primaryColor),
          ),
          style: TextStyle(color: onSurfaceColor),
        ),
        const SizedBox(height: 16),

        // Catégorie
        DropdownButtonFormField<ExpenseCategory>(
          value: controller.selectedCategory.value,
          hint: Text(
            'Catégorie',
            style: TextStyle(color: Colors.grey.shade600),
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
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getCategoryName(category),
                    style: TextStyle(color: onSurfaceColor),
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
          style: TextStyle(color: onSurfaceColor),
        ),
        const SizedBox(height: 16),

        // Montant
        TextFormField(
          controller: controller.amountController,
          decoration: InputDecoration(
            labelText: 'Montant',
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
            prefixIcon: Icon(Icons.money_outlined, color: primaryColor),
            suffixText: 'FCFA',
            suffixStyle: TextStyle(
              color: onSurfaceColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          keyboardType: TextInputType.number,
          style: TextStyle(color: onSurfaceColor),
        ),
        const SizedBox(height: 24),

        // Bouton d'action
        Container(
          width: double.infinity,
          height: 50,
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
            ),
            label: Text(
              controller.isEditing.value ? 'Modifier la dépense' : 'Ajouter la dépense',
              style: const TextStyle(
                color: surfaceColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
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
          const SizedBox(height: 12),
          TextButton.icon(
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Annuler'),
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
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune dépense ce mois-ci',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez votre première dépense',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        itemCount: controller.expenses.length,
        itemBuilder: (context, index) {
          final expense = controller.expenses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
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
              )
              ,
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
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Icône de la catégorie
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              getCategoryIcon(expense.category),
              color: errorColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          // ✅ Détails du texte (description, catégorie, date)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),

                // Catégorie en badge
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    getCategoryName(expense.category),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Date complète
                Text(
                  DateFormat('dd/MM/yyyy à HH:mm').format(expense.createdAt),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ✅ Montant + boutons d’action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${expense.amount.toStringAsFixed(2)} FCFA',
                style: TextStyle(
                  color: errorColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd/MM').format(expense.createdAt),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),

              // Boutons édition + suppression
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_note, color: warningColor, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => onEdit(expense),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: errorColor, size: 22),
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



  // Méthodes d'aide pour les catégories (à adapter selon votre implémentation)
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
    // Réinitialiser la catégorie à la valeur par défaut si nécessaire
    // controller.selectedCategory.value = ExpenseCategory.other;
  }

  void _showDeleteDialog(Expense expense) {
    Get.dialog(
      AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: errorColor),
            const SizedBox(width: 8),
            Text(
              'Confirmer la suppression',
              style: TextStyle(color: onSurfaceColor, overflow: TextOverflow.ellipsis, fontSize: 20),
            ),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer la dépense "${expense.description}" ?',
          style: TextStyle(color: onSurfaceColor),
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
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}