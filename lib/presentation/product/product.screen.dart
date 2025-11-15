import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
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
        title: Text(
          'Gestion des Produits',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: surfaceColor,
            fontSize: 18.sp,
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
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: _buildProductForm(),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Icon(Icons.inventory_2, color: primaryColor, size: 20.sp),
              SizedBox(width: 2.w),
              Text(
                'Liste des Produits',
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
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${controller.products.length}',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
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
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Nom du produit',
            labelStyle: TextStyle(fontSize: 14.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: controller.purchasePriceController,
          decoration: InputDecoration(
            labelText: 'Prix d\'achat',
            labelStyle: TextStyle(fontSize: 14.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixText: 'FCFA ',
            prefixStyle: TextStyle(fontSize: 14.sp),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(height: 2.h),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: Icon(
              controller.isEditing.value ? Icons.edit : Icons.add,
              color: surfaceColor,
              size: 18.sp,
            ),
            label: Text(
              controller.isEditing.value ? 'Modifier' : 'Ajouter',
              style: TextStyle(color: surfaceColor, fontSize: 14.sp),
            ),
            onPressed: () => controller.isEditing.value
                ? controller.updateProduct()
                : controller.addProduct(),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              controller.isEditing.value ? warningColor : successColor,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    if (controller.products.isEmpty) {
      return Center(
        child: Text(
          'Aucun produit enregistré',
          style: TextStyle(fontSize: 16.sp),
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return Card(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
              padding: EdgeInsets.all(3.w),
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
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.inventory_2, color: Colors.blueGrey, size: 18.sp),
                  ),

                  SizedBox(width: 3.w),

                  // Informations du produit
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showProductDetailsDialog(context, product),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Prix d\'achat : ${product.purchasePrice.toStringAsFixed(0)} FCFA',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
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
                        icon: Icon(Icons.edit_note, size: 20.sp),
                        color: warningColor,
                        tooltip: 'Modifier',
                        onPressed: () => controller.startEditing(product),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, size: 20.sp),
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
          icon: Icon(Icons.close, color: surfaceColor, size: 22.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Détails du Produit',
          style: TextStyle(color: surfaceColor, fontSize: 18.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Produit
            Row(
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.inventory_2,
                      color: surfaceColor, size: 20.sp),
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nom :${product.name}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: onSurfaceColor,
                      ),
                    ),
                    Text(
                      "Prix achat :${product.purchasePrice.toString()} FCFA",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: onSurfaceColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // Statistiques (mise à jour automatique)
            Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: onSurfaceColor,
              ),
            ),
            SizedBox(height: 2.h),
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
                  SizedBox(width: 4.w),
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

            SizedBox(height: 4.h),
            Text(
              'Historique des ventes',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: onSurfaceColor,
              ),
            ),
            SizedBox(height: 2.h),
            if (sortedSales.isEmpty)
              _buildEmptySales()
            else
              Column(
                children: sortedSales.map((s) => _SaleItem(sale: s)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySales() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Text(
          'Aucune vente enregistrée',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Supprimer le produit',
          style: TextStyle(fontSize: 16.sp),
        ),
        content: Text(
          'Voulez-vous supprimer "${product.name}" ?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: Text('Annuler', style: TextStyle(fontSize: 14.sp))
          ),
          TextButton(
            onPressed: () {
              controller.deleteProduct(product.id);
              Get.back();
            },
            child: Text(
                'Supprimer',
                style: TextStyle(color: errorColor, fontSize: 14.sp)
            ),
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
      padding: EdgeInsets.all(4.w),
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
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
              ),
              Icon(icon, color: color, size: 20.sp),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11.sp),
          ),
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
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Icon(Icons.point_of_sale, color: ProductScreen.successColor, size: 18.sp),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Vendu pour ${sale.salePrice.toStringAsFixed(0)} FCFA - '
                  '${DateFormat('dd/MM/yyyy').format(sale.saleDate)}',
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}