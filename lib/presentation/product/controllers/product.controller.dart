import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:bayamsalam/infrastructure/dal/stores/month_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/product_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/year_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

// Classe simple pour contenir les statistiques du produit sélectionné
class ProductStats {
  final double totalRevenue;
  final int salesCount;
  final double totalCost;
  final double netProfit;

  ProductStats({
    this.totalRevenue = 0.0,
    this.salesCount = 0,
    this.totalCost = 0.0,
    this.netProfit = 0.0,
  });

  @override
  String toString() {
    return 'ProductStats(totalRevenue: $totalRevenue, salesCount: $salesCount, totalCost: $totalCost, netProfit: $netProfit)';
  }
}

class ProductController extends GetxController {
  final YearStore _yearStore = Get.find();
  final MonthStore _monthStore = Get.find();
  final ProductStore _productStore = Get.find();
  RxBool force = true.obs;

  final nameController = TextEditingController();
  final purchasePriceController = TextEditingController();

  final isLoading = true.obs;
  final products = <Product>[].obs;
  final isEditing = false.obs;
  
  final productStats = ProductStats().obs;

  late Month _currentMonth;
  Product? _editingProduct;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final now = DateTime.now();
      final year = await _yearStore.getOrCreate(now.year);
      _currentMonth = await _monthStore.getOrCreateInYear(
        year,
        DateFormat.MMMM('fr_FR').format(now),
      );

      products.assignAll(_currentMonth.products.toList());

      // 👇 Calculer les stats du premier produit (ou d’un produit spécifique)
      if (products.isNotEmpty) {
        calculateStatsFor(products.first);
      }
      force.value = true;
      print('information ${productStats.value.toString()}');
    } catch (e) {
      Get.snackbar(
        'Erreur Critique',
        'Impossible de charger les données: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }


  /// Calcule les statistiques pour un produit donné et met à jour l'état.
  void calculateStatsFor(Product product) {
    final revenue = product.sales.map((s) => s.salePrice).sum;
    final salesCount = product.sales.length;
    final cost = product.purchasePrice * salesCount;
    final profit = revenue - cost;

    productStats.value = ProductStats(
      totalRevenue: revenue,
      salesCount: salesCount,
      totalCost: cost,
      netProfit: profit,
    );
  }

  void startEditing(Product product) {
    _editingProduct = product;
    nameController.text = product.name;
    purchasePriceController.text = product.purchasePrice.toString();
    isEditing.value = true;
  }

  Future<void> addProduct() async {
    if (nameController.text.isNotEmpty && purchasePriceController.text.isNotEmpty) {
      final newProduct = await _productStore.addProductToMonth(
        _currentMonth,
        nameController.text,
        double.parse(purchasePriceController.text),
      );
      products.add(newProduct);
      _clearForm();
    }
  }

  Future<void> updateProduct() async {
    if (_editingProduct != null) {
      await _productStore.updateProduct(
        _editingProduct!,
        nameController.text,
        double.parse(purchasePriceController.text),
      );
      products.refresh(); 
      _clearForm();
    }
  }

  Future<void> deleteProduct(String id) async {
    if (_editingProduct?.id == id) {
      _clearForm();
    }

    final index = products.indexWhere((p) => p.id == id);
    if (index != -1) {
      await _productStore.deleteProductFromMonth(_currentMonth, products[index]);
      products.removeAt(index);
    }
  }

  void _clearForm() {
    nameController.clear();
    purchasePriceController.clear();
    isEditing.value = false;
    _editingProduct = null;
  }
}
