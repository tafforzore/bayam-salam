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
}

class ProductController extends GetxController {
  final YearStore _yearStore = Get.find();
  final MonthStore _monthStore = Get.find();
  final ProductStore _productStore = Get.find();

  final nameController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final isEditing = false.obs;
  var editingProductId = '';

  final isLoading = true.obs;
  final products = <Product>[].obs;

  // NOUVEAU: Suivi du produit sélectionné et de ses statistiques
  final selectedProduct = Rxn<Product>();
  final productStats = ProductStats().obs;

  late Month _currentMonth;

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
      _currentMonth = await _monthStore.getOrCreateInYear(year, DateFormat.MMMM('fr_FR').format(now));
      products.assignAll(_currentMonth.products.toList());
    } catch (e) {
      Get.snackbar('Erreur Critique', 'Impossible de charger les données: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Dans votre ProductController
  void startEditing(Product product) {
    isEditing.value = true;
    selectedProduct.value = product;
    nameController.text = product.name;
    purchasePriceController.text = product.purchasePrice.toStringAsFixed(2);
    editingProductId = product.id; // Vous aurez besoin de cette variable dans votre controller
  }

  // NOUVEAU: Logique de sélection de produit
  void selectProduct(Product product) {
    // Si le même produit est cliqué, on le désélectionne
    if (selectedProduct.value == product) {
      _clearSelection();
      return;
    }

    selectedProduct.value = product;
    _calculateStatsFor(product);

    // Pré-remplir le formulaire pour l'édition
    nameController.text = product.name;
    purchasePriceController.text = product.purchasePrice.toString();
    isEditing.value = true;
  }

  void _calculateStatsFor(Product product) {
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
    final productToUpdate = selectedProduct.value;
    if (productToUpdate != null) {
      await _productStore.updateProduct(
        productToUpdate,
        nameController.text,
        double.parse(purchasePriceController.text),
      );
      products.refresh(); // Rafraîchit la liste pour montrer les changements
      _clearForm();
      _clearSelection();
    }
  }

  Future<void> deleteProduct(String id) async {
    // Si le produit à supprimer est celui qui est sélectionné, on efface la sélection
    if (selectedProduct.value?.id == id) {
      _clearSelection();
    }

    final index = products.indexWhere((p) => p.id == id);
    if (index != -1) {
      await _productStore.deleteProductFromMonth(_currentMonth, products[index]);
      products.removeAt(index);
    }
  }

  // NOUVEAU: Effacer le formulaire et la sélection
  void _clearForm() {
    nameController.clear();
    purchasePriceController.clear();
    isEditing.value = false;
  }

  void _clearSelection() {
    selectedProduct.value = null;
    _clearForm();
  }
}
