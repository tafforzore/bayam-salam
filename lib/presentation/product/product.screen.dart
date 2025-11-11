import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/core/entities/product_sale.dart';
import 'controllers/product.controller.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({super.key});

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
          Expanded(child: _buildProductList()),
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
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Nom du produit',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.purchasePriceController,
          decoration: InputDecoration(
            labelText: 'Prix d\'achat',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixText: 'FCFA ',
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: Icon(
              controller.isEditing.value ? Icons.edit : Icons.add,
              color: surfaceColor,
            ),
            label: Text(
              controller.isEditing.value ? 'Modifier' : 'Ajouter',
              style: const TextStyle(color: surfaceColor),
            ),
            onPressed: () => controller.isEditing.value
                ? controller.updateProduct()
                : controller.addProduct(),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              controller.isEditing.value ? warningColor : successColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    if (controller.products.isEmpty) {
      return const Center(
        child: Text('Aucun produit enregistré'),
      );
    }

    return ListView.builder(
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return Card(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône principale
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.inventory_2, color: Colors.blueGrey),
                ),

                const SizedBox(width: 12),

                // Informations du produit
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showProductDetailsDialog(context, product),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Prix d\'achat : ${product.purchasePrice.toStringAsFixed(0)} FCFA',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_note),
                      color: warningColor,
                      tooltip: 'Modifier',
                      onPressed: () => controller.startEditing(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: errorColor,
                      tooltip: 'Supprimer',
                      onPressed: () => _showDeleteDialog(product),
                    ),
                  ],
                ),
              ],
            ),
          )

        );
      },
    );
  }

  void _showProductDetailsDialog(BuildContext context, Product product) {
    // Force le recalcul des stats juste avant d'afficher la vue
    controller.calculateStatsFor(product);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: backgroundColor,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _buildProductDetailView(product),
        ),
      ),
    );
  }

  Widget _buildProductDetailView(Product product) {
    final sortedSales = product.sales.toList()
      ..sort((a, b) => b.saleDate.compareTo(a.saleDate));

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: surfaceColor),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Détails du Produit',
          style: TextStyle(color: surfaceColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Produit
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.inventory_2,
                      color: surfaceColor, size: 20),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nom :${product.name}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: onSurfaceColor,
                      ),
                    ),
                    Text(
                     "Prix achat :${product.purchasePrice.toString()} FCFA",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: onSurfaceColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistiques (mise à jour automatique)
            Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: onSurfaceColor,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final stats = controller.productStats.value;
              return Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Revenu Total',
                      value: '${stats.totalRevenue.toStringAsFixed(0)} FCFA',
                      subtitle: 'Chiffre d\'affaires',
                      color: successColor,
                      icon: Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Bénéfice Net',
                      value: '${stats.netProfit.toStringAsFixed(0)} FCFA',
                      subtitle: 'Profit réalisé',
                      color: stats.netProfit >= 0 ? primaryColor : warningColor,
                      icon: stats.netProfit >= 0
                          ? Icons.attach_money
                          : Icons.warning,
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 32),
            Text(
              'Historique des ventes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: onSurfaceColor,
              ),
            ),
            const SizedBox(height: 12),
            if (sortedSales.isEmpty)
              _buildEmptySales()
            else
              Column(
                children:                sortedSales.map((s) => _SaleItem(sale: s)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySales() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Text('Aucune vente enregistrée'),
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    Get.dialog(
      AlertDialog(
        title: const Text('Supprimer le produit'),
        content: Text('Voulez-vous supprimer "${product.name}" ?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              controller.deleteProduct(product.id);
              Get.back();
            },
            child: const Text('Supprimer', style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProductScreen.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }
}

class _SaleItem extends StatelessWidget {
  final ProductSale sale;
  const _SaleItem({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.point_of_sale, color: ProductScreen.successColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Vendu pour ${sale.salePrice.toStringAsFixed(0)} FCFA - '
                  '${DateFormat('dd/MM/yyyy').format(sale.saleDate)}',
            ),
          ),
        ],
      ),
    );
  }
}
