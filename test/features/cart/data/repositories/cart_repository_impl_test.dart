import 'package:app_sodimac_test/core/errors/exceptions.dart';
import 'package:app_sodimac_test/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_sodimac_test/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:app_sodimac_test/features/cart/data/models/cart_item_model.dart';
import 'package:app_sodimac_test/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:app_sodimac_test/features/cart/domain/entities/cart_item.dart';

import 'cart_repository_impl_test.mocks.dart';

@GenerateMocks([CartLocalDataSource])
void main() {
  late CartRepositoryImpl repository;
  late MockCartLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockCartLocalDataSource();
    repository = CartRepositoryImpl(mockLocalDataSource);
  });

  group('CartRepositoryImpl', () {
    final testDateTime = DateTime(2024, 1, 1, 12, 0, 0);

    final testCartItem = CartItem(
      id: '1',
      productId: 'product1',
      name: 'Test Product',
      imageUrl: 'https://example.com/image.jpg',
      price: 100.0,
      quantity: 2,
      addedAt: testDateTime,
    );

    final testCartItemModel = CartItemModel(
      id: '1',
      productId: 'product1',
      name: 'Test Product',
      imageUrl: 'https://example.com/image.jpg',
      price: 100.0,
      quantity: 2,
      addedAt: testDateTime,
    );

    group('getCartItems', () {
      test('should return list of cart items when successful', () async {
        // arrange
        when(mockLocalDataSource.getCartItems()).thenAnswer((_) async => [testCartItemModel]);

        // act
        final result = await repository.getCartItems();

        // assert
        expect(result.isRight(), true);
        expect(result.fold((l) => null, (r) => r.length), 1);
        verify(mockLocalDataSource.getCartItems()).called(1);
      });

      test('should return DatabaseFailure when DatabaseException occurs', () async {
        // arrange
        when(mockLocalDataSource.getCartItems()).thenThrow(const DatabaseException(message: 'Database error'));

        // act
        final result = await repository.getCartItems();

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Database error')));
        verify(mockLocalDataSource.getCartItems()).called(1);
      });

      test('should return DatabaseFailure when other exception occurs', () async {
        // arrange
        when(mockLocalDataSource.getCartItems()).thenThrow(Exception('Unexpected error'));

        // act
        final result = await repository.getCartItems();

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Exception: Unexpected error')));
        verify(mockLocalDataSource.getCartItems()).called(1);
      });
    });

    group('getCartItem', () {
      test('should return cart item when successful', () async {
        // arrange
        when(mockLocalDataSource.getCartItem('product1')).thenAnswer((_) async => testCartItemModel);

        // act
        final result = await repository.getCartItem('product1');

        // assert
        expect(result, Right(testCartItem));
        verify(mockLocalDataSource.getCartItem('product1')).called(1);
      });

      test('should return null when item not found', () async {
        // arrange
        when(mockLocalDataSource.getCartItem('product1')).thenAnswer((_) async => null);

        // act
        final result = await repository.getCartItem('product1');

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.getCartItem('product1')).called(1);
      });

      test('should return DatabaseFailure when DatabaseException occurs', () async {
        // arrange
        when(mockLocalDataSource.getCartItem('product1')).thenThrow(const DatabaseException(message: 'Database error'));

        // act
        final result = await repository.getCartItem('product1');

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Database error')));
        verify(mockLocalDataSource.getCartItem('product1')).called(1);
      });
    });

    group('addToCart', () {
      test('should return void when successful', () async {
        // arrange
        when(mockLocalDataSource.addToCart(any)).thenAnswer((_) async => 1);

        // act
        final result = await repository.addToCart(testCartItem);

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.addToCart(any)).called(1);
      });

      test('should return DatabaseFailure when DatabaseException occurs', () async {
        // arrange
        when(mockLocalDataSource.addToCart(any)).thenThrow(const DatabaseException(message: 'Database error'));

        // act
        final result = await repository.addToCart(testCartItem);

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Database error')));
        verify(mockLocalDataSource.addToCart(any)).called(1);
      });
    });

    group('updateQuantity', () {
      test('should return void when successful', () async {
        // arrange
        when(mockLocalDataSource.updateQuantity('product1', 3)).thenAnswer((_) async => 1);

        // act
        final result = await repository.updateQuantity('product1', 3);

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.updateQuantity('product1', 3)).called(1);
      });

      test('should return DatabaseFailure when DatabaseException occurs', () async {
        // arrange
        when(mockLocalDataSource.updateQuantity('product1', 3)).thenThrow(const DatabaseException(message: 'Database error'));

        // act
        final result = await repository.updateQuantity('product1', 3);

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Database error')));
        verify(mockLocalDataSource.updateQuantity('product1', 3)).called(1);
      });
    });

    group('removeFromCart', () {
      test('should return void when successful', () async {
        // arrange
        when(mockLocalDataSource.removeFromCart('product1')).thenAnswer((_) async => 1);

        // act
        final result = await repository.removeFromCart('product1');

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.removeFromCart('product1')).called(1);
      });

      test('should return DatabaseFailure when DatabaseException occurs', () async {
        // arrange
        when(mockLocalDataSource.removeFromCart('product1')).thenThrow(const DatabaseException(message: 'Database error'));

        // act
        final result = await repository.removeFromCart('product1');

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Database error')));
        verify(mockLocalDataSource.removeFromCart('product1')).called(1);
      });
    });

    group('clearCart', () {
      test('should return void when successful', () async {
        // arrange
        when(mockLocalDataSource.clearCart()).thenAnswer((_) async => 1);

        // act
        final result = await repository.clearCart();

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.clearCart()).called(1);
      });

      test('should return DatabaseFailure when DatabaseException occurs', () async {
        // arrange
        when(mockLocalDataSource.clearCart()).thenThrow(const DatabaseException(message: 'Database error'));

        // act
        final result = await repository.clearCart();

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Database error')));
        verify(mockLocalDataSource.clearCart()).called(1);
      });
    });

    group('getCartItemCount', () {
      test('should return count when successful', () async {
        // arrange
        when(mockLocalDataSource.getCartItemCount()).thenAnswer((_) async => 5);

        // act
        final result = await repository.getCartItemCount();

        // assert
        expect(result, const Right(5));
        verify(mockLocalDataSource.getCartItemCount()).called(1);
      });

      test('should return DatabaseFailure when DatabaseException occurs', () async {
        // arrange
        when(mockLocalDataSource.getCartItemCount()).thenThrow(const DatabaseException(message: 'Database error'));

        // act
        final result = await repository.getCartItemCount();

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Database error')));
        verify(mockLocalDataSource.getCartItemCount()).called(1);
      });
    });

    group('getCartTotal', () {
      test('should return total when successful', () async {
        // arrange
        when(mockLocalDataSource.getCartTotal()).thenAnswer((_) async => 250.0);

        // act
        final result = await repository.getCartTotal();

        // assert
        expect(result, const Right(250.0));
        verify(mockLocalDataSource.getCartTotal()).called(1);
      });

      test('should return DatabaseFailure when DatabaseException occurs', () async {
        // arrange
        when(mockLocalDataSource.getCartTotal()).thenThrow(const DatabaseException(message: 'Database error'));

        // act
        final result = await repository.getCartTotal();

        // assert
        expect(result, const Left(DatabaseFailure(message: 'Database error')));
        verify(mockLocalDataSource.getCartTotal()).called(1);
      });
    });

    group('Performance simulation', () {
      test('should handle heavy processing without throwing errors', () async {
        // arrange
        when(mockLocalDataSource.getCartItems()).thenAnswer((_) async => [testCartItemModel]);

        // act
        final result = await repository.getCartItems();

        // assert
        expect(result.isRight(), true);
        expect(result.fold((l) => null, (r) => r.length), 1);
        // La operación costosa se ejecuta internamente sin afectar el resultado
      });

      test('should handle heavy validation without throwing errors', () async {
        // arrange
        when(mockLocalDataSource.addToCart(any)).thenAnswer((_) async => 1);

        // act
        final result = await repository.addToCart(testCartItem);

        // assert
        expect(result, const Right(null));
        // La validación costosa se ejecuta internamente sin afectar el resultado
      });

      test('should handle heavy calculation without throwing errors', () async {
        // arrange
        when(mockLocalDataSource.getCartTotal()).thenAnswer((_) async => 250.0);

        // act
        final result = await repository.getCartTotal();

        // assert
        expect(result, const Right(250.0));
        // El cálculo costoso se ejecuta internamente sin afectar el resultado
      });
    });
  });
}
