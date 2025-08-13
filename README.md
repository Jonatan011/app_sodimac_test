# 🏠 Sodimac Test App

Una aplicación Flutter completa que consume la API de Homecenter para buscar productos, con carrito de compras local y optimizaciones de performance.

## 📋 Características

### ✅ Funcionalidades Principales
- 🔍 **Búsqueda de productos** con infinite scroll
- 🛒 **Carrito de compras** persistente local
- 💾 **Caché inteligente** de peticiones HTTP
- 🌐 **Internacionalización** (Español/Inglés)
- 📱 **Diseño responsive** para móvil, tablet y desktop
- ⚡ **Optimizaciones de performance** con detección de janks

### 🏗️ Arquitectura
- **Clean Architecture** con separación clara de capas
- **BLoC Pattern** para gestión de estado
- **Dependency Injection** con GetIt
- **Repository Pattern** para acceso a datos
- **Use Cases** para lógica de negocio

## 🚀 Tecnologías Utilizadas

### Core
- **Flutter** 3.29.3
- **Dart** 3.5.0
- **BLoC** para state management
- **GetIt** para dependency injection
- **Dartz** para programación funcional

### Networking & Caching
- **Dio** para HTTP requests
- **dio_cache_interceptor** para caché HTTP
- **dio_cache_interceptor_hive_store** para almacenamiento

### Database
- **Drift** (SQLite) para base de datos local
- **sqlite3_flutter_libs** para soporte SQLite

### UI/UX
- **Material Design 3**
- **Google Fonts** para tipografía
- **Cached Network Image** para imágenes
- **Shimmer** para loading states
- **EasyLocalization** para i18n

### Code Generation
- **build_runner** para generación de código
- **json_serializable** para serialización JSON
- **freezed** para inmutabilidad
- **drift_dev** para generación de base de datos
- **injectable_generator** para DI

### Testing
- **flutter_test** para pruebas unitarias
- **bloc_test** para testing de BLoCs
- **mockito** para mocking
- **mocktail** para testing

## 📁 Estructura del Proyecto

```
lib/
├── core/
│   ├── constants/          # Constantes de la app
│   ├── errors/            # Manejo de errores
│   ├── extensions/        # Extensiones personalizadas
│   ├── network/           # Configuración de red
│   ├── database/          # Base de datos local
│   ├── theme/             # Temas de la app
│   ├── di/                # Dependency injection
│   └── usecases/          # Use cases base
├── features/
│   ├── search/            # Feature de búsqueda
│   │   ├── data/          # Data layer
│   │   ├── domain/        # Domain layer
│   │   └── presentation/  # Presentation layer
│   └── cart/              # Feature del carrito
│       ├── data/          # Data layer
│       ├── domain/        # Domain layer
│       └── presentation/  # Presentation layer
└── main.dart              # Entry point
```

## 🧪 Pruebas Unitarias

### 📊 Resultados de las Pruebas

```bash
flutter test
00:06 +41: All tests passed!
```

### ✅ Cobertura de Pruebas

#### **SearchBloc Tests (20 pruebas)**
- ✅ Búsqueda exitosa (primera página)
- ✅ Búsqueda exitosa (páginas siguientes)
- ✅ Búsqueda con caché
- ✅ Búsqueda vacía
- ✅ Búsqueda con menos de 40 items
- ✅ Búsqueda con 40+ items (hasMore = true)
- ✅ Errores de servidor/red
- ✅ Validación de queries vacías
- ✅ Carga de búsquedas recientes
- ✅ Guardado de consultas
- ✅ Limpieza de búsqueda
- ✅ Mapeo de errores

#### **CartRepositoryImpl Tests (21 pruebas)**
- ✅ Obtener items del carrito
- ✅ Obtener item específico
- ✅ Agregar al carrito
- ✅ Actualizar cantidad
- ✅ Remover del carrito
- ✅ Limpiar carrito
- ✅ Contar items
- ✅ Calcular total
- ✅ Manejo de errores de base de datos
- ✅ Operaciones costosas sin errores

### 🎯 Casos Cubiertos
- **Casos de éxito** ✅
- **Casos de error** ✅
- **Operaciones costosas** ✅
- **Validaciones** ✅
- **Manejo de excepciones** ✅

## ⚡ Optimizaciones de Performance

### 🚀 Operaciones Costosas Simuladas (Solo Debug)
- **`_simulateHeavyProcessing()`** - 10K iteraciones (✅ **DEMOSTRACIÓN DE JANKS**)
- **`_simulateHeavyValidation()`** - 5K iteraciones (background)
- **`_simulateStatisticsUpdate()`** - Isolates para procesamiento pesado
- **`_simulateQuantityValidation()`** - 2K iteraciones (async)
- **`_simulateRecalculation()`** - 3K iteraciones (background)
- **`_simulateHeavyCleanup()`** - 5K iteraciones (no bloqueante)
- **`_simulateHeavyCalculation()`** - 4K iteraciones (async)

### 🎯 Cumplimiento del Requerimiento
- ✅ **Simula operación costosa** - `_simulateHeavyProcessing()` con `await`
- ✅ **UI se ve afectada** - Causa janks reales en modo debug
- ✅ **Identifica el problema** - Operación bloqueante en hilo principal
- ✅ **Aplica solución** - Otros métodos usan `unawaited()` e Isolates

### 🔧 Optimizaciones Implementadas
- **Solo en modo debug** - No afectan la app en producción
- **Operaciones no bloqueantes** - Usando `unawaited()` y `kDebugMode`
- **Isolates** para procesamiento pesado en background
- **Micro-pausas** para no bloquear el hilo principal
- **Manejo de errores** silencioso para no afectar la UI

### 📊 Widget de Performance (Opcional)
- **`PerformanceMonitor`** - Monitoreo de FPS y detección de janks
- **`PerformanceMixin`** - Mixin para widgets que necesitan monitoreo
- **Detección automática** de frames que tardan más de 16ms
- **Deshabilitado por defecto** - Solo se activa cuando se necesita

## 🛠️ Instalación y Configuración

### Prerrequisitos
- Flutter 3.29.3 o superior
- Dart 3.5.0 o superior
- Android Studio / VS Code

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd app_sodimac_test
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Generar código**
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

### Ejecutar Pruebas
```bash
# Todas las pruebas
flutter test

# Pruebas específicas
flutter test test/features/search/presentation/bloc/search_bloc_test.dart
flutter test test/features/cart/data/repositories/cart_repository_impl_test.dart
```

## 🌐 API Endpoints

### Búsqueda de Productos
```
GET https://www.homecenter.com.co/s/search/v1/soco/
Query Parameters:
- priceGroup: 10
- q: {search_term}
- currentpage: {page_number}
```

### Respuesta
```json
{
  "products": [
    {
      "id": "string",
      "displayName": "string",
      "price": "number",
      "imageUrl": "string"
    }
  ]
}
```

## 🎨 Características de UI/UX

### Responsive Design
- **Mobile**: 2 columnas, aspect ratio 0.6
- **Tablet**: 3 columnas, aspect ratio 0.65
- **Desktop**: 4 columnas, aspect ratio 0.7

### Temas
- **Light Theme**: Colores claros y modernos
- **Dark Theme**: Colores oscuros para mejor experiencia nocturna

### Internacionalización
- **Español**: Idioma por defecto
- **Inglés**: Soporte completo
- **Traducciones**: Todas las cadenas de texto localizadas

## 🔧 Configuración de Caché

### HTTP Cache
- **Duración**: 1 hora por defecto
- **Política**: `CachePolicy.forceCache`
- **Almacenamiento**: Hive en directorio temporal
- **Claves únicas**: Por query + página

### Base de Datos Local
- **SQLite** con Drift
- **Tablas**: CartItems, SearchHistory
- **Persistencia**: Datos del carrito y búsquedas recientes

## 📱 Funcionalidades del Carrito

### Operaciones Soportadas
- ✅ Agregar productos
- ✅ Actualizar cantidades
- ✅ Remover productos
- ✅ Limpiar carrito completo
- ✅ Calcular total
- ✅ Contar items

### Persistencia
- **Local**: SQLite con Drift
- **Sincronización**: Automática entre pantallas
- **Recuperación**: Datos persistentes entre sesiones

## 🚀 Performance Monitoring

### Métricas Monitoreadas
- **FPS**: Frames por segundo en tiempo real
- **Janks**: Detección de frames lentos (>16ms)
- **Operaciones costosas**: Simuladas para testing
- **Memory usage**: Optimización de memoria

### Indicadores Visuales
- **Loading states**: Shimmer effects
- **Progress indicators**: Para operaciones costosas
- **Error handling**: Mensajes informativos
- **Cache indicators**: Badges para datos cacheados

## 🔍 Búsqueda y Filtrado

### Características
- **Infinite scroll**: Carga automática de más productos
- **Caché inteligente**: Evita peticiones duplicadas
- **Sugerencias**: Búsquedas recientes
- **Validación**: Queries vacías y whitespace

### Paginación
- **Tamaño de página**: 40 productos
- **Indicador hasMore**: Basado en cantidad de resultados
- **Scroll position**: Mantenida durante carga

## 📊 Estadísticas del Proyecto

### Código
- **Líneas de código**: ~3,000+
- **Archivos**: 50+
- **Features**: 2 principales (Search, Cart)
- **Layers**: 3 por feature (Data, Domain, Presentation)

### Testing
- **Pruebas totales**: 41 ✅
- **Cobertura**: BLoC + Repository
- **Casos de éxito**: 100% cubiertos
- **Casos de error**: 100% cubiertos

### Performance
- **Operaciones costosas**: 7 simuladas
- **Optimizaciones**: 4 implementadas
- **Isolates**: 1 para background processing
- **Detección de janks**: Automática

## 🎯 Principios SOLID Aplicados

### Single Responsibility Principle (SRP)
- Cada clase tiene una responsabilidad específica
- BLoCs manejan solo su estado
- Repositorios manejan solo acceso a datos

### Open/Closed Principle (OCP)
- Extensiones sin modificar código existente
- Nuevos features sin afectar los existentes

### Liskov Substitution Principle (LSP)
- Implementaciones intercambiables
- Interfaces bien definidas

### Interface Segregation Principle (ISP)
- Interfaces específicas por feature
- No dependencias innecesarias

### Dependency Inversion Principle (DIP)
- Dependencias inyectadas
- Abstracciones sobre implementaciones

## 🏆 Clean Code Practices

### Naming Conventions
- **Clases**: PascalCase
- **Métodos**: camelCase
- **Constantes**: UPPER_SNAKE_CASE
- **Archivos**: snake_case

### Code Organization
- **Separación de capas**: Clara y consistente
- **Archivos pequeños**: Una responsabilidad por archivo
- **Comentarios**: Solo cuando es necesario
- **Documentación**: Completa y actualizada

### Error Handling
- **Either type**: Para manejo funcional de errores
- **Custom exceptions**: Específicas por dominio
- **User-friendly messages**: Traducidas y claras

## 🔮 Próximas Mejoras

### Funcionalidades
- [ ] Filtros avanzados de productos
- [ ] Wishlist de productos
- [ ] Historial de compras
- [ ] Notificaciones push
- [ ] Modo offline completo

### Performance
- [ ] Lazy loading de imágenes
- [ ] Compresión de datos
- [ ] Background sync
- [ ] Analytics de performance

### Testing
- [ ] Widget tests
- [ ] Integration tests
- [ ] Performance tests
- [ ] E2E tests

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👥 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Contacto

- **Desarrollador**: [Tu Nombre]
- **Email**: [tu.email@ejemplo.com]
- **LinkedIn**: [tu-linkedin]

---

**¡Gracias por revisar este proyecto!** 🚀
#   a p p _ s o d i m a c _ t e s t  
 