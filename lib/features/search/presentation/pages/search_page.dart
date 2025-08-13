import 'package:app_sodimac_test/core/constants/app_colors.dart';
import 'package:app_sodimac_test/core/constants/app_text_styles.dart';
import 'package:app_sodimac_test/features/cart/domain/entities/cart_item.dart';
import 'package:app_sodimac_test/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:app_sodimac_test/features/search/presentation/widgets/error_widget.dart';
import 'package:app_sodimac_test/features/search/presentation/widgets/loading_shimmer.dart';
import 'package:app_sodimac_test/features/search/presentation/widgets/product_card.dart';
import 'package:app_sodimac_test/features/search/presentation/widgets/recent_searches.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/responsive_extensions.dart';
import '../bloc/search_bloc.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_suggestions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late SearchBloc _searchBloc;
  late CartBloc _cartBloc;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _searchBloc = getIt<SearchBloc>();
    _cartBloc = getIt<CartBloc>();
    _scrollController.addListener(_onScroll);

    // Load recent searches on init
    _searchBloc.add(const LoadRecentSearchesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final state = _searchBloc.state;
      if (state is SearchLoaded && state.hasMore && !_isLoadingMore) {
        _isLoadingMore = true;
        // Add a small delay to prevent multiple rapid calls
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _searchBloc.add(SearchProductsEvent(query: state.query ?? '', page: state.currentPage + 1));
          }
        });
      }
    }
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      _searchBloc.add(SearchProductsEvent(query: query));
      _searchBloc.add(SaveSearchQueryEvent(query: query));
    }
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _onSearch(suggestion);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('search.title'.tr()),
      actions: const [
        /*  IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            // Navigate to cart - this will be handled by the parent
          },
        ),*/
      ],
    ),
    body: Column(
      children: [
        // Search Bar
        Padding(
          padding: 4.p, // Padding responsive
          child: SearchBarWidget(controller: _searchController, onSearch: _onSearch, suggestions: AppConstants.searchSuggestions),
        ),

        // Content
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            bloc: _searchBloc,
            builder: (context, state) {
              // Reset loading flag when loading completes
              if (state is SearchLoaded) {
                _isLoadingMore = false;
              }
              if (state is SearchInitial) {
                return const RecentSearches();
              }

              if (state is SearchLoading || state is SearchLoadingMore) {
                return const LoadingShimmer();
              }

              if (state is SearchError) {
                return SearchErrorWidget(message: state.message, onRetry: () => _onSearch(_searchController.text));
              }

              if (state is SearchLoaded) {
                if (state.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: 16),
                        Text('app.no_results'.tr(), style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Results header
                    Padding(
                      padding: 4.ph, // Horizontal padding responsive
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${state.products.length} ${'search.products_found'.tr()}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 3.5.sp, // Font size responsive
                                ),
                              ),
                              if (state.isFromCache) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                  child: Text('Cached', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontSize: 2.5.sp)),
                                ),
                              ],
                            ],
                          ),
                          const Spacer(),
                          if (state.hasMore)
                            InkWell(
                              onTap: () => _searchBloc.add(SearchProductsEvent(query: state.query ?? '', page: state.currentPage + 1)),
                              child: Text(
                                'search.load_more'.tr(),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 3.sp, // Font size responsive
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Products grid
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Responsive grid configuration
                          final gridConfig = ResponsiveHelper.getGridConfig(context);

                          return GridView.builder(
                            key: PageStorageKey('search_products_grid${state.query}'),
                            controller: _scrollController,
                            padding: EdgeInsets.all(gridConfig.padding),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridConfig.crossAxisCount,
                              childAspectRatio: gridConfig.childAspectRatio,
                              crossAxisSpacing: gridConfig.spacing,
                              mainAxisSpacing: gridConfig.spacing,
                            ),
                            itemCount: state.products.length + (state.hasMore && !_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == state.products.length) {
                                return Container(padding: const EdgeInsets.all(16), child: const Center(child: CircularProgressIndicator()));
                              }

                              final product = state.products[index];
                              return ProductCard(
                                product: product,
                                onAddToCart: () {
                                  // Add to cart functionality
                                  _cartBloc.add(
                                    AddToCartEvent(
                                      item: CartItem(
                                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                                        productId: product.id,
                                        name: product.displayName,
                                        imageUrl: product.imageUrl ?? '',
                                        price: product.price,
                                        quantity: 1,
                                        addedAt: DateTime.now(),
                                      ),
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('messages.product_added'.tr()),
                                      backgroundColor: AppColors.success,
                                      action: SnackBarAction(
                                        label: 'cart.view_cart'.tr(),
                                        textColor: Colors.white,
                                        onPressed: () {
                                          // Navigate to cart - this will be handled by the parent
                                          // For now, just show a message
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(SnackBar(content: Text('cart.navigate_message'.tr()), backgroundColor: AppColors.info));
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              if (state is RecentSearchesLoaded) {
                return SearchSuggestions(suggestions: state.searches, onSuggestionTap: _onSuggestionTap);
              }

              return const LoadingShimmer();
            },
          ),
        ),
      ],
    ),
  );
}
