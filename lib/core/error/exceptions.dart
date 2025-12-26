/// Excepciones base y específicas para el manejo de errores en la aplicación
/// Siguiendo el principio de responsabilidad única y abierto/cerrado

/// Excepción base para todas las excepciones de la aplicación
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Excepción para errores del servidor (4xx, 5xx)
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode, super.code});

  factory ServerException.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const ServerException(
          'Solicitud incorrecta, por favor revise su entrada.',
          statusCode: 400,
          code: 'BAD_REQUEST',
        );
      case 401:
        return const ServerException(
          'No autorizado, por favor revise sus credenciales.',
          statusCode: 401,
          code: 'UNAUTHORIZED',
        );
      case 403:
        return const ServerException(
          'Prohibido, no tienes permiso para acceder a este recurso.',
          statusCode: 403,
          code: 'FORBIDDEN',
        );
      case 404:
        return const ServerException(
          'Recurso no encontrado.',
          statusCode: 404,
          code: 'NOT_FOUND',
        );
      case 500:
        return const ServerException(
          'Error interno del servidor, por favor intente nuevamente más tarde.',
          statusCode: 500,
          code: 'INTERNAL_SERVER_ERROR',
        );
      case 503:
        return const ServerException(
          'Servicio no disponible, por favor intente nuevamente más tarde.',
          statusCode: 503,
          code: 'SERVICE_UNAVAILABLE',
        );
      default:
        return ServerException(
          'Error del servidor ocurrido, código de estado: $statusCode',
          statusCode: statusCode,
          code: 'SERVER_ERROR',
        );
    }
  }
}

/// Excepción para errores de red (conexión, timeout, etc.)
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});

  factory NetworkException.noConnection() {
    return const NetworkException(
      'No hay conexión a internet, por favor revise sus configuraciones de red.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      'Tiempo de espera agotado, por favor intente nuevamente.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.canceled() {
    return const NetworkException('Solicitud cancelada.', code: 'CANCELED');
  }
}

/// Excepción para errores de caché/local storage
class CacheException extends AppException {
  const CacheException(super.message, {super.code});

  factory CacheException.notFound() {
    return const CacheException(
      'Datos no encontrados en la caché.',
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheException.saveFailed() {
    return const CacheException(
      'Error al guardar datos en la caché.',
      code: 'CACHE_SAVE_FAILED',
    );
  }

  factory CacheException.deleteFailed() {
    return const CacheException(
      'Error al eliminar datos de la caché.',
      code: 'CACHE_DELETE_FAILED',
    );
  }
}

/// Excepción para errores de validación de datos
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}
