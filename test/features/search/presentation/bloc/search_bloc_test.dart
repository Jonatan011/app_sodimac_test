import 'package:app_sodimac_test/core/errors/failures.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_sodimac_test/features/search/domain/entities/product.dart';
import 'package:app_sodimac_test/features/search/domain/usecases/get_recent_searches.dart';
import 'package:app_sodimac_test/features/search/domain/usecases/save_search_query.dart';
import 'package:app_sodimac_test/features/search/domain/usecases/search_products.dart';
import 'package:app_sodimac_test/features/search/presentation/bloc/search_bloc.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchProducts, GetRecentSearches, SaveSearchQuery])
void main() {
  late SearchBloc searchBloc;
  late MockSearchProducts mockSearchProducts;
  late MockGetRecentSearches mockGetRecentSearches;
  late MockSaveSearchQuery mockSaveSearchQuery;

  setUp(() {
    mockSearchProducts = MockSearchProducts();
    mockGetRecentSearches = MockGetRecentSearches();
    mockSaveSearchQuery = MockSaveSearchQuery();
    searchBloc = SearchBloc(searchProducts: mockSearchProducts, getRecentSearches: mockGetRecentSearches, saveSearchQuery: mockSaveSearchQuery);
  });

  tearDown(() {
    searchBloc.close();
  });

  group('SearchBloc', () {
    final testProducts = [
      const Product(id: '1', displayName: 'Test Product 1', price: 100.0, imageUrl: 'https://example.com/image1.jpg'),
      const Product(id: '2', displayName: 'Test Product 2', price: 200.0, imageUrl: 'https://example.com/image2.jpg'),
    ];

    final testSearchResult = SearchProductsResult(products: testProducts, isFromCache: false);

    test('initial state should be SearchInitial', () {
      expect(searchBloc.state, const SearchInitial());
    });

    group('SearchProductsEvent', () {
      test('should emit SearchInitial when query is empty', () {
        const event = SearchProductsEvent(query: '', page: 1);

        expectLater(searchBloc.stream, emitsInOrder([const SearchInitial()]));

        searchBloc.add(event);
      });

      test('should emit SearchInitial when query is only whitespace', () {
        const event = SearchProductsEvent(query: '   ', page: 1);

        expectLater(searchBloc.stream, emitsInOrder([const SearchInitial()]));

        searchBloc.add(event);
      });

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoading, SearchLoaded] when search is successful for first page',
        build: () {
          when(mockSearchProducts(any)).thenAnswer((_) async => Right(testSearchResult));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchProductsEvent(query: 'test', page: 1)),
        expect:
            () => [const SearchLoading(), SearchLoaded(products: testProducts, query: 'test', hasMore: false, currentPage: 1, isFromCache: false)],
        verify: (_) {
          verify(mockSearchProducts(any)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoadingMore, SearchLoaded] when search is successful for subsequent pages',
        build: () {
          when(mockSearchProducts(any)).thenAnswer((_) async => Right(testSearchResult));
          return searchBloc;
        },
        seed: () => SearchLoaded(products: [testProducts[0]], query: 'test', hasMore: true, currentPage: 1, isFromCache: false),
        act: (bloc) => bloc.add(const SearchProductsEvent(query: 'test', page: 2)),
        expect:
            () => [
              SearchLoadingMore(products: [testProducts[0]]),
              SearchLoaded(products: [testProducts[0], ...testProducts], query: 'test', hasMore: false, currentPage: 2, isFromCache: false),
            ],
        verify: (_) {
          verify(mockSearchProducts(any)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoading, SearchError] when search fails for first page',
        build: () {
          when(mockSearchProducts(any)).thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchProductsEvent(query: 'test', page: 1)),
        expect: () => [const SearchLoading(), const SearchError(message: 'Server error')],
        verify: (_) {
          verify(mockSearchProducts(any)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoadingMore, SearchError] when search fails for subsequent pages',
        build: () {
          when(mockSearchProducts(any)).thenAnswer((_) async => const Left(NetworkFailure(message: 'Network error')));
          return searchBloc;
        },
        seed: () => SearchLoaded(products: [testProducts[0]], query: 'test', hasMore: true, currentPage: 1, isFromCache: false),
        act: (bloc) => bloc.add(const SearchProductsEvent(query: 'test', page: 2)),
        expect:
            () => [
              SearchLoadingMore(products: [testProducts[0]]),
              SearchError(message: 'Network error', products: [testProducts[0]]),
            ],
        verify: (_) {
          verify(mockSearchProducts(any)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should handle cache responses correctly',
        build: () {
          final cachedResult = SearchProductsResult(products: testProducts, isFromCache: true);
          when(mockSearchProducts(any)).thenAnswer((_) async => Right(cachedResult));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchProductsEvent(query: 'test', page: 1)),
        expect: () => [const SearchLoading(), SearchLoaded(products: testProducts, query: 'test', hasMore: false, currentPage: 1, isFromCache: true)],
      );

      blocTest<SearchBloc, SearchState>(
        'should set hasMore to false when products list is empty',
        build: () {
          final emptyResult = SearchProductsResult(products: [], isFromCache: false);
          when(mockSearchProducts(any)).thenAnswer((_) async => Right(emptyResult));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchProductsEvent(query: 'test', page: 1)),
        expect: () => [const SearchLoading(), const SearchLoaded(products: [], query: 'test', hasMore: false, currentPage: 1, isFromCache: false)],
      );

      blocTest<SearchBloc, SearchState>(
        'should set hasMore to false when products list has less than 40 items',
        build: () {
          final smallResult = SearchProductsResult(products: [testProducts[0]], isFromCache: false);
          when(mockSearchProducts(any)).thenAnswer((_) async => Right(smallResult));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchProductsEvent(query: 'test', page: 1)),
        expect:
            () => [
              const SearchLoading(),
              SearchLoaded(products: [testProducts[0]], query: 'test', hasMore: false, currentPage: 1, isFromCache: false),
            ],
      );

      blocTest<SearchBloc, SearchState>(
        'should set hasMore to true when products list has 40 or more items',
        build: () {
          // Crear una lista de 40 productos para simular una página completa
          final manyProducts = List.generate(
            40,
            (index) => Product(
              id: '${index + 1}',
              displayName: 'Test Product ${index + 1}',
              price: 100.0 + index,
              imageUrl: 'https://example.com/image${index + 1}.jpg',
            ),
          );
          final fullResult = SearchProductsResult(products: manyProducts, isFromCache: false);
          when(mockSearchProducts(any)).thenAnswer((_) async => Right(fullResult));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchProductsEvent(query: 'test', page: 1)),
        expect:
            () => [
              const SearchLoading(),
              SearchLoaded(
                products: List.generate(
                  40,
                  (index) => Product(
                    id: '${index + 1}',
                    displayName: 'Test Product ${index + 1}',
                    price: 100.0 + index,
                    imageUrl: 'https://example.com/image${index + 1}.jpg',
                  ),
                ),
                query: 'test',
                hasMore: true,
                currentPage: 1,
                isFromCache: false,
              ),
            ],
      );
    });

    group('LoadRecentSearchesEvent', () {
      final testSearches = ['search1', 'search2', 'search3'];

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoading, RecentSearchesLoaded] when successful',
        build: () {
          when(mockGetRecentSearches(any)).thenAnswer((_) async => Right(testSearches));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const LoadRecentSearchesEvent()),
        expect: () => [const SearchLoading(), RecentSearchesLoaded(searches: testSearches)],
        verify: (_) {
          verify(mockGetRecentSearches(any)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoading, SearchError] when fails',
        build: () {
          when(mockGetRecentSearches(any)).thenAnswer((_) async => const Left(DatabaseFailure(message: 'Database error')));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const LoadRecentSearchesEvent()),
        expect: () => [const SearchLoading(), const SearchError(message: 'Error inesperado')],
        verify: (_) {
          verify(mockGetRecentSearches(any)).called(1);
        },
      );
    });

    group('SaveSearchQueryEvent', () {
      blocTest<SearchBloc, SearchState>(
        'should emit SearchQuerySaved when successful',
        build: () {
          when(mockSaveSearchQuery(any)).thenAnswer((_) async => const Right(null));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SaveSearchQueryEvent(query: 'test query')),
        expect: () => [const SearchQuerySaved()],
        verify: (_) {
          verify(mockSaveSearchQuery(any)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit SearchError when fails',
        build: () {
          when(mockSaveSearchQuery(any)).thenAnswer((_) async => const Left(DatabaseFailure(message: 'Save error')));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SaveSearchQueryEvent(query: 'test query')),
        expect: () => [const SearchError(message: 'Error inesperado')],
        verify: (_) {
          verify(mockSaveSearchQuery(any)).called(1);
        },
      );
    });

    group('ClearSearchEvent', () {
      blocTest<SearchBloc, SearchState>(
        'should emit SearchInitial',
        build: () => searchBloc,
        act: (bloc) => bloc.add(const ClearSearchEvent()),
        expect: () => [const SearchInitial()],
      );
    });

    group('Failure mapping', () {
      test('should map ServerFailure correctly', () {
        const failure = ServerFailure(message: 'Server error');
        final message = searchBloc.mapFailureToMessage(failure);
        expect(message, 'Server error');
      });

      test('should map NetworkFailure correctly', () {
        const failure = NetworkFailure(message: 'Network error');
        final message = searchBloc.mapFailureToMessage(failure);
        expect(message, 'Network error');
      });

      test('should map CacheFailure correctly', () {
        const failure = CacheFailure(message: 'Cache error');
        final message = searchBloc.mapFailureToMessage(failure);
        expect(message, 'Cache error');
      });

      test('should return default message for unknown failure', () {
        const failure = ValidationFailure(message: 'Validation error');
        final message = searchBloc.mapFailureToMessage(failure);
        expect(message, 'Error inesperado');
      });
    });
  });
}
