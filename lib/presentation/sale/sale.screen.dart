import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

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
        title: Text(
          'Gestion des Ventes',
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

        return Column(
          children: [
            _buildSaleForm(context),
            SizedBox(height: 2.h),
            _buildSalesList(),
          ],
        );
      }),
    );
  }

  Widget _buildSaleForm(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.w),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            // En-tête du formulaire
            Row(
              children: [
                Icon(
                  controller.isEditing.value ? Icons.edit_note : Icons.add_shopping_cart,
                  color: controller.isEditing.value ? warningColor : primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  controller.isEditing.value ? 'Modifier la vente' : 'Nouvelle vente',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Sélection du produit
            DropdownButtonFormField<String>(
              value: controller.selectedProductId.value,
              hint: Text(
                'Sélectionnez un produit',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
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
                      Icon(Icons.inventory_2, color: primaryColor, size: 18.sp),
                      SizedBox(width: 2.w),
                      Text(
                        product.name,
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
                prefixIcon: Icon(Icons.search, color: primaryColor, size: 20.sp),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 2.h),

            // Prix de vente
            TextFormField(
              controller: controller.salePriceController,
              decoration: InputDecoration(
                labelText: 'Prix de vente',
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
                prefixIcon: Icon(Icons.euro, color: primaryColor, size: 20.sp),
                suffixText: 'FCFA',
                suffixStyle: TextStyle(fontSize: 14.sp),
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
                  controller.isEditing.value ? 'Modifier la Vente' : 'Ajouter la Vente',
                  style: TextStyle(
                    color: surfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
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
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              children: [
                Icon(Icons.history, color: primaryColor, size: 20.sp),
                SizedBox(width: 2.w),
                Text(
                  'Ventes du Mois',
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
                    '${controller.sales.length} vente(s)',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

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
              size: 70.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 2.h),
            Text(
              'Aucune vente ce mois-ci',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Ajoutez votre première vente',
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
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        itemCount: controller.sales.length,
        itemBuilder: (context, index) {
          final sale = controller.sales[index];
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.monetization_on_outlined,
                            color: successColor,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                'Vente de ${controller.getProductName(sale)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: onSurfaceColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Text(
                              DateFormat('le dd/MM/yyyy à HH:mm').format(sale.saleDate),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: errorColor, size: 20.sp),
                              onPressed: () => _showDeleteDialog(sale),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${sale.salePrice.toStringAsFixed(2)} FCFA',
                          style: TextStyle(
                            color: successColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    )
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
            Icon(Icons.warning, color: errorColor, size: 22.sp),
            SizedBox(width: 2.w),
            Text(
              'Confirmer la suppression',
              style: TextStyle(color: onSurfaceColor, fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer la vente de ${controller.getProductName(sale)} ?',
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
                controller.deleteSale(sale);
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