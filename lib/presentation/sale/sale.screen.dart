import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controllers/sale.controller.dart';

class SaleScreen extends GetView<SaleController> {
  const SaleScreen({super.key});

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
          'Gestion des Ventes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
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
            _buildSaleForm(context),
            const SizedBox(height: 16),
            _buildSalesList(),
          ],
        );
      }),
    );
  }

  Widget _buildSaleForm(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // En-tête du formulaire
            Row(
              children: [
                Icon(
                  controller.isEditing.value ? Icons.edit_note : Icons.add_shopping_cart,
                  color: controller.isEditing.value ? warningColor : primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  controller.isEditing.value ? 'Modifier la vente' : 'Nouvelle vente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sélection du produit
            DropdownButtonFormField<String>(
              value: controller.selectedProductId.value,
              hint: Text(
                'Sélectionnez un produit',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedProductId.value = value;
                }
              },
              items: controller.availableProducts.map((product) {
                return DropdownMenuItem(
                  value: product.id,
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2, color: primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        product.name,
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
                prefixIcon: Icon(Icons.search, color: primaryColor),
              ),
            ),
            const SizedBox(height: 16),

            // Prix de vente
            TextFormField(
              controller: controller.salePriceController,
              decoration: InputDecoration(
                labelText: 'Prix de vente',
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
                prefixIcon: Icon(Icons.euro, color: primaryColor),
                suffixText: 'FCFA',
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
                  controller.isEditing.value ? 'Modifier la Vente' : 'Ajouter la Vente',
                  style: const TextStyle(
                    color: surfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  controller.isEditing.value ? controller.updateSale() : controller.addSale();
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
        ),
      ),
    );
  }

  Widget _buildSalesList() {
    return Expanded(
      child: Column(
        children: [
          // En-tête de la liste
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.history, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Ventes du Mois',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${controller.sales.length} vente(s)',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Liste des ventes
          Expanded(
            child: _buildSalesListContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesListContent() {
    if (controller.sales.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_checkout,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune vente ce mois-ci',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez votre première vente',
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: controller.sales.length,
        itemBuilder: (context, index) {
          final sale = controller.sales[index];
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
                    color: successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.monetization_on_outlined,
                    color: successColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  'Vente de ${controller.getProductName(sale)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: onSurfaceColor,
                  ),
                ),
                subtitle: Text(
                  DateFormat('le dd/MM/yyyy à HH:mm').format(sale.saleDate),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${sale.salePrice.toStringAsFixed(2)} FCFA',
                          style: TextStyle(
                            color: successColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('dd/MM').format(sale.saleDate),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.edit_note, color: warningColor),
                      onPressed: () => controller.startEditing(sale),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: errorColor),
                      onPressed: () => _showDeleteDialog(sale),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _cancelEditing() {
    controller.isEditing.value = false;
    controller.salePriceController.clear();
    controller.selectedProductId.value = '';
  }

  void _showDeleteDialog(ProductSale sale) {
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
              style: TextStyle(color: onSurfaceColor),
            ),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer la vente de ${controller.getProductName(sale)} ?',
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
                controller.deleteSale(sale);
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