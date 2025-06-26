// lib/services/analytics/analytics_helper.dart
// ✅ HELPER PARA ANALYTICS - USAR QUANDO AnalyticsIntegration NÃO ESTIVER DISPONÍVEL

import 'package:clashup/core/utils/logger.dart';

/// Helper para analytics quando AnalyticsIntegration não está disponível
class AnalyticsHelper {
  /// Log de evento genérico
  static Future<void> logEvent(
    String eventName,
    Map<String, dynamic> parameters,
  ) async {
    try {
      // Por enquanto, apenas logar - pode ser substituído por implementação real
      AppLogger.info('📊 Analytics Event: $eventName', data: parameters);

      // TODO: Implementar integração real com Firebase Analytics
      // await FirebaseAnalytics.instance.logEvent(
      //   name: eventName,
      //   parameters: parameters,
      // );
    } catch (e) {
      AppLogger.warning('⚠️ Erro ao enviar analytics', data: {
        'event': eventName,
        'error': e.toString(),
      });
    }
  }

  /// Log de performance
  static Future<void> logPerformance(
    String metricName,
    int durationMs,
    Map<String, dynamic> metadata,
  ) async {
    await logEvent('performance_metric', {
      'metric_name': metricName,
      'duration_ms': durationMs,
      ...metadata,
    });
  }

  /// Log de erro
  static Future<void> logError(
    String errorName,
    String errorMessage,
    Map<String, dynamic>? metadata,
  ) async {
    await logEvent('error_occurred', {
      'error_name': errorName,
      'error_message': errorMessage,
      if (metadata != null) ...metadata,
    });
  }
}

// ✅ CLASSE PLACEHOLDER PARA AnalyticsIntegration SE NÃO EXISTIR
class AnalyticsIntegration {
  static Future<void> logEvent(
    String eventName,
    Map<String, dynamic> parameters,
  ) async {
    return AnalyticsHelper.logEvent(eventName, parameters);
  }

  static Future<void> track(
    String eventName,
    Map<String, dynamic> parameters,
  ) async {
    return logEvent(eventName, parameters);
  }
}
