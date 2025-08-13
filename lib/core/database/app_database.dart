import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// Cart table
class CartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productId => text()();
  TextColumn get name => text()();
  TextColumn get imageUrl => text().nullable()();
  RealColumn get price => real()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}

// Search history table
class SearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  DateTimeColumn get searchedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [CartItems, SearchHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Cart operations
  Future<List<CartItem>> getAllCartItems() => select(cartItems).get();

  Future<CartItem?> getCartItem(String productId) => (select(cartItems)..where((item) => item.productId.equals(productId))).getSingleOrNull();

  Future<int> addToCart(CartItemsCompanion item) => into(cartItems).insert(item);

  Future<int> updateCartItemQuantity(String productId, int quantity) =>
      (update(cartItems)..where((item) => item.productId.equals(productId))).write(CartItemsCompanion(quantity: Value(quantity)));

  Future<int> removeFromCart(String productId) => (delete(cartItems)..where((item) => item.productId.equals(productId))).go();

  Future<int> clearCart() => delete(cartItems).go();

  Future<int> getCartItemCount() => select(cartItems).get().then((items) => items.length);

  Future<double> getCartTotal() async {
    final items = await select(cartItems).get();
    double total = 0.0;
    for (final item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Search history operations
  Future<List<SearchHistoryData>> getRecentSearches({int limit = 10}) =>
      (select(searchHistory)
            ..orderBy([(t) => OrderingTerm.desc(t.searchedAt)])
            ..limit(limit))
          .get();

  Future<int> addSearchHistory(String query) => into(searchHistory).insert(SearchHistoryCompanion(query: Value(query)));

  Future<int> clearSearchHistory() => delete(searchHistory).go();
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
  return NativeDatabase.createInBackground(file);
});
