part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final List<Product> products;
  final String? query;
  final bool hasMore;
  final int currentPage;
  final bool isFromCache;

  const SearchState({this.products = const [], this.query, this.hasMore = false, this.currentPage = 1, this.isFromCache = false});

  @override
  List<Object?> get props => [products, query, hasMore, currentPage, isFromCache];
}

class SearchInitial extends SearchState {
  const SearchInitial() : super();
}

class SearchLoading extends SearchState {
  const SearchLoading() : super();
}

class SearchLoadingMore extends SearchState {
  const SearchLoadingMore({required super.products});
}

class SearchLoaded extends SearchState {
  const SearchLoaded({required super.products, required String super.query, required super.hasMore, required super.currentPage, super.isFromCache});
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message, super.products});

  @override
  List<Object?> get props => [message, ...super.props];
}

class RecentSearchesLoaded extends SearchState {
  final List<String> searches;

  const RecentSearchesLoaded({required this.searches}) : super();

  @override
  List<Object?> get props => [searches, ...super.props];
}

class SearchQuerySaved extends SearchState {
  const SearchQuerySaved();
}
