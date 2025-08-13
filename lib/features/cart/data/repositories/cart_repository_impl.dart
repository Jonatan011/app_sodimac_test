import 'dart:async';
import 'dart:isolate';

import 'package:app_sodimac_test/core/errors/exceptions.dart';
import 'package:app_sodimac_test/features/cart/domain/entities/cart_item.dart';
import 'package:app_sodimac_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  const CartRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      // Simular operación costosa de procesamiento (solo en modo debug)
      if (kDebugMode) {
        // ❌ VERSIÓN QUE CAUSA JANKS (para demostrar el problema)
        await _simulateHeavyProcessing();

        // ✅ VERSIÓN OPTIMIZADA (comentada para comparación)
        // unawaited(_simulateHeavyProcessing()); // Esto NO bloquearía la UI
      }

      final items = await localDataSource.getCartItems();
      return Right(items.map((item) => item.toDomain()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartItem?>> getCartItem(String productId) async {
    try {
      final item = await localDataSource.getCartItem(productId);
      return Right(item?.toDomain());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItem item) async {
    try {
      // Simular operación costosa de validación y procesamiento (solo en modo debug)
      if (kDebugMode) {
        unawaited(_simulateHeavyValidation(item));
      }

      final cartItemModel = CartItemModel.fromDomain(item);
      await localDataSource.addToCart(cartItemModel);

      // Simular operación costosa de actualización de estadísticas (background)
      if (kDebugMode) {
        unawaited(_simulateStatisticsUpdate());
      }

      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(String productId, int quantity) async {
    try {
      // Simular operación costosa de validación (solo en modo debug)
      if (kDebugMode) {
        unawaited(_simulateQuantityValidation(quantity));
      }

      await localDataSource.updateQuantity(productId, quantity);

      // Simular operación costosa de recálculo (background)
      if (kDebugMode) {
        unawaited(_simulateRecalculation());
      }

      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String productId) async {
    try {
      await localDataSource.removeFromCart(productId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      // Simular operación costosa de limpieza (solo en modo debug)
      if (kDebugMode) {
        unawaited(_simulateHeavyCleanup());
      }

      await localDataSource.clearCart();
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCartItemCount() async {
    try {
      final count = await localDataSource.getCartItemCount();
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getCartTotal() async {
    try {
      // Simular operación costosa de cálculo (solo en modo debug)
      if (kDebugMode) {
        unawaited(_simulateHeavyCalculation());
      }

      final total = await localDataSource.getCartTotal();
      return Right(total);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  // ===== MÉTODOS DE OPTIMIZACIÓN DE PERFORMANCE =====

  /// Simula una operación costosa de procesamiento
  Future<void> _simulateHeavyProcessing() async {
    // Simular procesamiento pesado (ej: análisis de datos, cálculos complejos)
    await Future.delayed(const Duration(milliseconds: 50));

    // Simular operaciones intensivas de CPU (reducidas para no bloquear)
    for (int i = 0; i < 10000; i++) {
      // Simular cálculos complejos
      final result = i * i * i;
      if (result % 1000 == 0) {
        // Pequeña pausa para no bloquear completamente el hilo principal
        await Future.delayed(const Duration(microseconds: 1));
      }
    }
  }

  /// Simula validación costosa de un item del carrito
  Future<void> _simulateHeavyValidation(CartItem item) async {
    // Simular validaciones complejas
    await Future.delayed(const Duration(milliseconds: 30));

    // Simular verificación de stock, precios, disponibilidad, etc.
    for (int i = 0; i < 5000; i++) {
      final validation = i % 2 == 0;
      if (validation && i % 1000 == 0) {
        await Future.delayed(const Duration(microseconds: 1));
      }
    }
  }

  /// Simula actualización costosa de estadísticas
  Future<void> _simulateStatisticsUpdate() async {
    // Simular actualización de estadísticas en background
    unawaited(_performStatisticsUpdateInBackground());
  }

  /// Ejecuta actualización de estadísticas en un isolate separado
  Future<void> _performStatisticsUpdateInBackground() async {
    try {
      await Isolate.run(() {
        // Simular procesamiento pesado en isolate separado
        for (int i = 0; i < 10000; i++) {
          // Cálculos complejos que no afectan la UI
          final result = i * i * i * i;
        }
      });
    } catch (e) {
      // Manejar errores silenciosamente para no afectar la UI
      print('Background statistics update failed: $e');
    }
  }

  /// Simula validación costosa de cantidad
  Future<void> _simulateQuantityValidation(int quantity) async {
    await Future.delayed(const Duration(milliseconds: 20));

    // Simular validaciones de stock, límites, etc.
    for (int i = 0; i < 2000; i++) {
      final isValid = quantity > 0 && quantity <= 999;
      if (isValid && i % 500 == 0) {
        await Future.delayed(const Duration(microseconds: 1));
      }
    }
  }

  /// Simula recálculo costoso
  Future<void> _simulateRecalculation() async {
    // Simular recálculo de totales, descuentos, impuestos, etc.
    await Future.delayed(const Duration(milliseconds: 25));

    for (int i = 0; i < 3000; i++) {
      final calculation = i * 1.19 * 0.95; // Simular cálculos de impuestos y descuentos
      if (i % 1000 == 0) {
        await Future.delayed(const Duration(microseconds: 1));
      }
    }
  }

  /// Simula limpieza costosa del carrito
  Future<void> _simulateHeavyCleanup() async {
    await Future.delayed(const Duration(milliseconds: 40));

    // Simular limpieza de datos temporales, caché, etc.
    for (int i = 0; i < 5000; i++) {
      final cleanup = i % 3 == 0;
      if (cleanup && i % 1000 == 0) {
        await Future.delayed(const Duration(microseconds: 1));
      }
    }
  }

  /// Simula cálculo costoso del total
  Future<void> _simulateHeavyCalculation() async {
    await Future.delayed(const Duration(milliseconds: 35));

    // Simular cálculos complejos de totales, descuentos, impuestos, etc.
    for (int i = 0; i < 4000; i++) {
      final calculation = i * 1.19 * 0.95 * 1.05; // Impuestos + descuentos + comisiones
      if (i % 1000 == 0) {
        await Future.delayed(const Duration(microseconds: 1));
      }
    }
  }
}
