import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/infrastructure/dal/stores/month_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/sale_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/year_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SaleController extends GetxController {
  final YearStore _yearStore = Get.find();
  final MonthStore _monthStore = Get.find();
  final SaleStore _saleStore = Get.find();

  final salePriceController = TextEditingController();

  final isLoading = true.obs;
  final isEditing = false.obs;

  final sales = <ProductSale>[].obs;
  final availableProducts = <Product>[].obs;
  final selectedProductId = Rxn<String>();

  late Month _currentMonth;
  ProductSale? _editingSale;

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

      availableProducts.assignAll(_currentMonth.products);

      List<ProductSale> allSales = [];
      for (var product in _currentMonth.products) {
        allSales.addAll(product.sales);
      }
      // Trie les ventes de la plus récente à la plus ancienne
      allSales.sort((a, b) => b.saleDate.compareTo(a.saleDate));
      sales.assignAll(allSales);

    } catch (e) {
      Get.snackbar('Erreur Critique', 'Impossible de charger l\'environnement des ventes: ${e.toString()}');
      return;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSale() async {
    final productId = selectedProductId.value;
    if (productId == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un produit.');
      return;
    }

    final product = availableProducts.firstWhere((p) => p.id == productId);
    final salePrice = double.tryParse(salePriceController.text);

    if (salePrice != null) {
      final newSale = await _saleStore.addSale(product, salePrice);
      sales.insert(0, newSale); // Ajoute au début de la liste
      _clearForm();
    }
  }

  void startEditing(ProductSale sale) {
    final parentProduct = availableProducts.firstWhere((p) => p.sales.contains(sale));
    selectedProductId.value = parentProduct.id;
    salePriceController.text = sale.salePrice.toString();
    isEditing.value = true;
    _editingSale = sale;
  }

  Future<void> updateSale() async {
    if (_editingSale != null && salePriceController.text.isNotEmpty) {
      final newPrice = double.parse(salePriceController.text);
      await _saleStore.updateSale(_editingSale!, newPrice);
      
      // Rafraîchir la liste UI
      final index = sales.indexWhere((s) => s.id == _editingSale!.id);
      if (index != -1) {
        sales[index] = _editingSale!;
        sales.refresh();
      }
      _clearForm();
    }
  }

  Future<void> deleteSale(ProductSale sale) async {
    await _saleStore.deleteSale(_currentMonth, sale);
    sales.removeWhere((s) => s.id == sale.id);
  }

  String getProductName(ProductSale sale) {
    for (var product in availableProducts) {
      if (product.sales.any((s) => s.id == sale.id)) {
        return product.name;
      }
    }
    return 'Produit inconnu';
  }

  void _clearForm() {
    salePriceController.clear();
    selectedProductId.value = null;
    isEditing.value = false;
    _editingSale = null;
  }

  @override
  void onClose() {
    salePriceController.dispose();
    super.onClose();
  }
}
