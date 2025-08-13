import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../network/dio_client.dart';
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/search_products.dart';
import '../../features/search/domain/usecases/get_recent_searches.dart';
import '../../features/search/domain/usecases/save_search_query.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
import '../../features/cart/data/datasources/cart_local_datasource.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/get_cart_items.dart';
import '../../features/cart/domain/usecases/add_to_cart.dart';
import '../../features/cart/domain/usecases/update_quantity.dart';
import '../../features/cart/domain/usecases/remove_from_cart.dart';
import '../../features/cart/domain/usecases/clear_cart.dart';
import '../../features/cart/domain/usecases/get_cart_total.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Core
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Search feature
  getIt.registerLazySingleton<SearchRemoteDataSource>(() => SearchRemoteDataSourceImpl(getIt<DioClient>()));

  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: getIt<SearchRemoteDataSource>(), database: getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton(() => SearchProducts(getIt<SearchRepository>()));
  getIt.registerLazySingleton(() => GetRecentSearches(getIt<SearchRepository>()));
  getIt.registerLazySingleton(() => SaveSearchQuery(getIt<SearchRepository>()));

  getIt.registerFactory(
    () =>
        SearchBloc(searchProducts: getIt<SearchProducts>(), getRecentSearches: getIt<GetRecentSearches>(), saveSearchQuery: getIt<SaveSearchQuery>()),
  );

  // Cart feature
  getIt.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl(getIt<AppDatabase>()));

  getIt.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(getIt<CartLocalDataSource>()));

  getIt.registerLazySingleton(() => GetCartItems(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => AddToCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => UpdateQuantity(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => RemoveFromCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => ClearCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => GetCartTotal(getIt<CartRepository>()));

  getIt.registerLazySingleton(
    () => CartBloc(
      getCartItems: getIt<GetCartItems>(),
      addToCart: getIt<AddToCart>(),
      updateQuantity: getIt<UpdateQuantity>(),
      removeFromCart: getIt<RemoveFromCart>(),
      clearCart: getIt<ClearCart>(),
      getCartTotal: getIt<GetCartTotal>(),
    ),
  );
}
