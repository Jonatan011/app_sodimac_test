import 'package:app_sodimac_test/core/usecases/usecase.dart';
import 'package:app_sodimac_test/features/search/domain/usecases/get_recent_searches.dart';
import 'package:app_sodimac_test/features/search/domain/usecases/save_search_query.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/search_products.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProducts searchProducts;
  final GetRecentSearches getRecentSearches;
  final SaveSearchQuery saveSearchQuery;

  SearchBloc({required this.searchProducts, required this.getRecentSearches, required this.saveSearchQuery}) : super(const SearchInitial()) {
    on<SearchProductsEvent>(_onSearchProducts);
    on<LoadRecentSearchesEvent>(_onLoadRecentSearches);
    on<SaveSearchQueryEvent>(_onSaveSearchQuery);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchProducts(SearchProductsEvent event, Emitter<SearchState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }

    if (event.page == 1) {
      emit(const SearchLoading());
    } else {
      emit(SearchLoadingMore(products: state.products));
    }

    final result = await searchProducts(SearchProductsParams(query: event.query, page: event.page));

    result.fold(
      (failure) {
        if (event.page == 1) {
          emit(SearchError(message: mapFailureToMessage(failure)));
        } else {
          emit(SearchError(message: mapFailureToMessage(failure), products: state.products));
        }
      },
      (result) {
        final allProducts = event.page == 1 ? result.products : [...state.products, ...result.products];
        final hasMore = result.products.isNotEmpty && result.products.length >= 40; // Assuming 40 items per page

        emit(
          SearchLoaded(
            products: allProducts,
            query: event.query,
            hasMore: hasMore,
            currentPage: event.page,
            isFromCache: result.isFromCache, // Use actual cache information
          ),
        );
      },
    );
  }

  Future<void> _onLoadRecentSearches(LoadRecentSearchesEvent event, Emitter<SearchState> emit) async {
    emit(const SearchLoading());

    final result = await getRecentSearches(const NoParams());

    result.fold((failure) => emit(SearchError(message: mapFailureToMessage(failure))), (searches) => emit(RecentSearchesLoaded(searches: searches)));
  }

  Future<void> _onSaveSearchQuery(SaveSearchQueryEvent event, Emitter<SearchState> emit) async {
    final result = await saveSearchQuery(SaveSearchQueryParams(query: event.query));

    result.fold((failure) => emit(SearchError(message: mapFailureToMessage(failure))), (_) => emit(const SearchQuerySaved()));
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(const SearchInitial());
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return failure.message;
      case const (NetworkFailure):
        return failure.message;
      case const (CacheFailure):
        return failure.message;
      default:
        return 'Error inesperado';
    }
  }
}
