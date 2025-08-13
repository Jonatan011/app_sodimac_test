class AppConstants {
  // API URLs
  static const String baseUrl = 'https://www.homecenter.com.co';
  static const String searchEndpoint = '/s/search/v1/soco/';
  static const String priceGroup = '10';

  // Search suggestions
  static const List<String> searchSuggestions = ['Taladros', 'Humedad', 'Cascos', 'botas de seguridad', 'tornillos'];

  // Cache configuration
  static const Duration cacheDuration = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // Pagination
  static const int itemsPerPage = 20;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  // Error messages
  static const String networkErrorMessage = 'Error de conexión. Verifica tu internet.';
  static const String serverErrorMessage = 'Error del servidor. Intenta más tarde.';
  static const String unknownErrorMessage = 'Error desconocido. Intenta nuevamente.';

  // Success messages
  static const String productAddedToCart = 'Producto agregado al carrito';
  static const String productRemovedFromCart = 'Producto removido del carrito';
}
