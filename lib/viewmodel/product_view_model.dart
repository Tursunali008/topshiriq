import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/servis/product_httpservis.dart';

class ProductViewModel {
  final productServices = ProductServices();
  List<Product> _products = [];

  Future<List<Product>> get products async {
    if (_products.isEmpty) {
      _products = await productServices.fetchProducts();
    }
    return [..._products];
  }

  Future<void> addProduct({
    required String title,
    required String imageUrl,
    required double price,
    required int amount,
  }) async {
    final newProduct = Product(
      id: title,
      title: title,
      imageUrl: imageUrl,
      price: price,
      amount: amount,
    );
    await productServices.addProduct(newProduct);
    _products.add(newProduct);
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      await productServices.updateProduct(id, updatedProduct);
      _products[prodIndex] = updatedProduct;
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex = _products.indexWhere((prod) => prod.id == id);
    if (existingProductIndex >= 0) {
      _products.removeAt(existingProductIndex);
      await productServices.deleteProduct(id);
      // Optionally, you can handle the deletion error by re-adding the product back to the list if the delete fails.
    }
  }

  Future<void> toggleFavoriteStatus(String id) async {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final product = _products[prodIndex];
      product.isFavorite = !product.isFavorite;
      await productServices.updateProduct(id, product);
    }
  }
}
