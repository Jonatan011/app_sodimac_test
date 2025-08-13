import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<CartItemModel?> getCartItem(String productId);
  Future<void> addToCart(CartItemModel item);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
  Future<int> getCartItemCount();
  Future<double> getCartTotal();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final AppDatabase database;

  const CartLocalDataSourceImpl(this.database);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final items = await database.getAllCartItems();
      return items.map((item) => CartItemModel.fromDatabase(item)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Error al obtener items del carrito: $e');
    }
  }

  @override
  Future<CartItemModel?> getCartItem(String productId) async {
    try {
      final item = await database.getCartItem(productId);
      return item != null ? CartItemModel.fromDatabase(item) : null;
    } catch (e) {
      throw DatabaseException(message: 'Error al obtener item del carrito: $e');
    }
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    try {
      await database.addToCart(item.toDatabaseCompanion());
    } catch (e) {
      throw DatabaseException(message: 'Error al agregar al carrito: $e');
    }
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      await database.updateCartItemQuantity(productId, quantity);
    } catch (e) {
      throw DatabaseException(message: 'Error al actualizar cantidad: $e');
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    try {
      await database.removeFromCart(productId);
    } catch (e) {
      throw DatabaseException(message: 'Error al remover del carrito: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await database.clearCart();
    } catch (e) {
      throw DatabaseException(message: 'Error al limpiar carrito: $e');
    }
  }

  @override
  Future<int> getCartItemCount() async {
    try {
      return await database.getCartItemCount();
    } catch (e) {
      throw DatabaseException(message: 'Error al obtener cantidad de items: $e');
    }
  }

  @override
  Future<double> getCartTotal() async {
    try {
      return await database.getCartTotal();
    } catch (e) {
      throw DatabaseException(message: 'Error al obtener total del carrito: $e');
    }
  }
}
