import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controllers/product.controller.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({super.key});

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
          'Gestion des Produits',
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

        return _buildProductListWithForm();
      }),
    );
  }

  Widget _buildProductListWithForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Formulaire d'ajout
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildProductForm(),
            ),
          ),
          const SizedBox(height: 16),

          // En-tête de la liste
          Row(
            children: [
              Icon(Icons.inventory_2, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Liste des Produits',
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
                  '${controller.products.length}',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Liste des produits
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.isEditing.value ? 'Modifier le produit' : 'Nouveau produit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            TextFormField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Nom du produit',
                labelStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(fontSize: 14, color: onSurfaceColor),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.purchasePriceController,
              decoration: InputDecoration(
                labelText: 'Prix d\'achat',
                labelStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                prefixText: '€ ',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 14, color: onSurfaceColor),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: controller.isEditing.value
                          ? [warningColor, const Color(0xFFFFB74D)]
                          : [successColor, const Color(0xFF66BB6A)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: (controller.isEditing.value ? warningColor : successColor).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      controller.isEditing.value ? Icons.edit : Icons.add,
                      size: 18,
                      color: surfaceColor,
                    ),
                    label: Text(
                      controller.isEditing.value ? 'Modifier' : 'Ajouter',
                      style: TextStyle(
                        color: surfaceColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () => controller.isEditing.value ? controller.updateProduct() : controller.addProduct(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductList() {
    if (controller.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Aucun produit enregistré',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez votre premier produit pour commencer',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
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
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.inventory_2, color: primaryColor, size: 20),
              ),
              title: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: onSurfaceColor,
                ),
              ),
              subtitle: Text(
                'Prix d\'achat: ${product.purchasePrice.toStringAsFixed(2)} €',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: primaryColor),
                    onPressed: () => _showProductDetailsDialog(context, product),
                    tooltip: 'Voir les détails',
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: warningColor),
                    onPressed: () => controller.startEditing(product),
                    tooltip: 'Modifier',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: errorColor),
                    onPressed: () => _showDeleteDialog(product),
                    tooltip: 'Supprimer',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProductDetailsDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: backgroundColor,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _buildProductDetailView(product),
        ),
      ),
    );
  }

  Widget _buildProductDetailView(Product product) {
    final stats = controller.productStats.value;
    final sortedSales = product.sales.toList()
      ..sort((a, b) => b.saleDate.compareTo(a.saleDate));

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: surfaceColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Détails du Produit',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: surfaceColor),
            onPressed: () {
              Get.back();
              controller.startEditing(product);
            },
            tooltip: 'Modifier le produit',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du produit
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor.withOpacity(0.1), accentColor.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.inventory_2, color: surfaceColor, size: 36),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: onSurfaceColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Produit enregistré',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Prix d\'achat: ${product.purchasePrice.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              color: surfaceColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Cartes de statistiques
            Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: onSurfaceColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Revenu Total',
                    value: '${stats.totalRevenue.toStringAsFixed(2)} €',
                    subtitle: 'Chiffre d\'affaires',
                    color: successColor,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Bénéfice Net',
                    value: '${stats.netProfit.toStringAsFixed(2)} €',
                    subtitle: 'Profit réalisé',
                    color: stats.netProfit >= 0 ? primaryColor : warningColor,
                    icon: stats.netProfit >= 0 ? Icons.attach_money : Icons.warning,
                  ),
                ),
                const SizedBox(width: 16),
                // Expanded(
                //   child: _StatCard(
                //     title: 'Nombre de Ventes',
                //     value: '${stats.salesCount}',
                //     subtitle: 'Transactions',
                //     color: secondaryColor,
                //     icon: Icons.shopping_cart,
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 32),

            // Section historique des ventes
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, color: primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Historique des Ventes',
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
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${stats.salesCount} vente(s)',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (sortedSales.isEmpty)
                    _buildEmptySales()
                  else
                    Column(
                      children: sortedSales.map((sale) => _SaleItem(sale: sale)).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySales() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.point_of_sale, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Aucune vente enregistrée',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les ventes de ce produit apparaîtront ici',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    Get.dialog(
      AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: errorColor),
            const SizedBox(width: 12),
            Text(
              'Supprimer le produit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: onSurfaceColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Êtes-vous sûr de vouloir supprimer définitivement le produit :',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.inventory_2, color: errorColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: onSurfaceColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cette action est irréversible.',
              style: TextStyle(
                color: errorColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
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
                controller.deleteProduct(product.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'Supprimer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ProductScreen.backgroundColor,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// Élément de vente
class _SaleItem extends StatelessWidget {
  final dynamic sale;

  const _SaleItem({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ProductScreen.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.point_of_sale,
              color: ProductScreen.successColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vente effectuée',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ProductScreen.onSurfaceColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy à HH:mm').format(sale.saleDate),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ProductScreen.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${sale.salePrice.toStringAsFixed(2)} €',
              style: TextStyle(
                color: ProductScreen.successColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}