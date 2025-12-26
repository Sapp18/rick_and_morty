import 'package:equatable/equatable.dart';
import 'exceptions.dart';

/// Clases de fallos (failures) que representan errores en el dominio
/// Siguiendo el patrón de Either/Result para manejo funcional de errores

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

/// Fallo del servidor
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode, super.code});

  factory ServerFailure.fromException(ServerException exception) {
    return ServerFailure(
      exception.message,
      statusCode: exception.statusCode,
      code: exception.code,
    );
  }
}

/// Fallo de red
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(exception.message, code: exception.code);
  }
}

/// Fallo de caché
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(exception.message, code: exception.code);
  }
}

/// Fallo de validación
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});

  factory ValidationFailure.fromException(ValidationException exception) {
    return ValidationFailure(exception.message, code: exception.code);
  }
}
