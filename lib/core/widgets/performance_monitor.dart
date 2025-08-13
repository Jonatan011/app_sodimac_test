import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enabled = false, // Deshabilitado por defecto
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  int _frameCount = 0;
  int _lastFrameTime = 0;
  final List<double> _frameTimes = [];
  bool _showOverlay = false;
  DateTime? _lastJankWarning;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      WidgetsBinding.instance.addPersistentFrameCallback(_onFrame);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onFrame(Duration timeStamp) {
    if (!widget.enabled) return;

    final currentTime = timeStamp.inMilliseconds;
    if (_lastFrameTime > 0) {
      final frameTime = currentTime - _lastFrameTime;
      _frameTimes.add(frameTime.toDouble());

      // Mantener solo los últimos 60 frames
      if (_frameTimes.length > 60) {
        _frameTimes.removeAt(0);
      }

      // Detectar janks (frames que tardan más de 33ms - menos sensible)
      if (frameTime > 33 && mounted) {
        _showJankWarning(frameTime);
      }
    }
    _lastFrameTime = currentTime;
    _frameCount++;
  }

  void _showJankWarning(int frameTime) {
    if (mounted) {
      // Evitar múltiples notificaciones en un corto período
      final now = DateTime.now();
      if (_lastJankWarning == null || now.difference(_lastJankWarning!).inSeconds > 5) {
        _lastJankWarning = now;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ Jank detectado: ${frameTime}ms'),
            backgroundColor: AppColors.warning,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ocultar',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  double get _averageFrameTime {
    if (_frameTimes.isEmpty) return 0.0;
    return _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
  }

  double get _fps => _averageFrameTime > 0 ? (1000 / _averageFrameTime) : 0;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      widget.child,
      if (widget.enabled && _showOverlay)
        Positioned(
          top: 50,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FPS: ${_fps.toStringAsFixed(1)}',
                  style: AppTextStyles.bodySmall.copyWith(color: _fps < 50 ? AppColors.error : AppColors.success),
                ),
                Text('Frames: $_frameCount', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                Text('Avg: ${_averageFrameTime.toStringAsFixed(1)}ms', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ),
      if (widget.enabled)
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.small(
            onPressed: () {
              setState(() {
                _showOverlay = !_showOverlay;
              });
            },
            backgroundColor: AppColors.primary,
            child: Icon(_showOverlay ? Icons.visibility_off : Icons.visibility, color: Colors.white),
          ),
        ),
    ],
  );
}

/// Mixin para widgets que necesitan monitoreo de performance
mixin PerformanceMixin<T extends StatefulWidget> on State<T> {
  bool _performanceEnabled = false;

  void enablePerformanceMonitoring() {
    _performanceEnabled = true;
  }

  void disablePerformanceMonitoring() {
    _performanceEnabled = false;
  }

  Widget wrapWithPerformanceMonitor(Widget child) => PerformanceMonitor(enabled: _performanceEnabled, child: child);
}
