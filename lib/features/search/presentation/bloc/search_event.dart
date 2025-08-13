part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchProductsEvent extends SearchEvent {
  final String query;
  final int page;

  const SearchProductsEvent({required this.query, this.page = 1});

  @override
  List<Object?> get props => [query, page];
}

class LoadRecentSearchesEvent extends SearchEvent {
  const LoadRecentSearchesEvent();
}

class SaveSearchQueryEvent extends SearchEvent {
  final String query;

  const SaveSearchQueryEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}
