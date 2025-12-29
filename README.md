# Rick and Morty

Aplicación móvil desarrollada en Flutter que permite explorar personajes de la serie Rick and Morty. La app incluye funcionalidades de búsqueda, listado con scroll infinito, detalles de personajes y persistencia local para favoritos.

## Requisitos Previos

- **Flutter**: 3.35.5 (channel stable)
- **Dart**: 3.9.2
- **Plataformas soportadas**: Android e iOS

## Instrucciones de Ejecución

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd rick_and_morty
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar la aplicación

#### Android e iOS

```bash
# Modo debug
flutter run

# Modo release
flutter run --release
```

### 4. Construir APK/IPA

#### Android (APK)

```bash
flutter build apk --release
```

#### iOS (IPA)

```bash
flutter build ios --release
```

## Arquitectura

Este proyecto implementa **Clean Architecture** siguiendo los principios SOLID, organizando el código en tres capas principales que garantizan separación de responsabilidades y testabilidad:

### Capas de la Arquitectura

#### 1. Domain (Dominio)

Capa más interna que contiene la lógica de negocio pura, independiente de frameworks y librerías externas.

- **Entities**: Modelos de dominio que representan las entidades del negocio (`Character`, `DetailCharacter`)
- **Repositories**: Interfaces abstractas que definen los contratos para acceso a datos
- **Use Cases**: Casos de uso que encapsulan la lógica de negocio específica (`GetCharactersUseCase`, `ToggleFavoriteUseCase`)

#### 2. Data (Datos)

Capa que implementa las fuentes de datos y se comunica con APIs y almacenamiento local.

- **Data Sources**: Implementaciones concretas para fuentes remotas (`CharactersRemoteDataSource`) y locales (`FavoritesLocalDataSource`)
- **Models**: Modelos de datos que mapean respuestas de API a entidades de dominio (`CharacterModel`, `DetailCharacterModel`)
- **Repository Implementations**: Implementaciones concretas de los repositorios definidos en Domain

#### 3. Presentation (Presentación)

Capa de interfaz de usuario que maneja la visualización y la interacción del usuario.

- **BLoC**: Gestión de estado usando el patrón BLoC (`CharactersBloc`, `DetailCharactersBloc`)
- **Pages**: Pantallas principales de la aplicación (`CharactersPage`, `DetailCharactersPage`)
- **Widgets**: Componentes reutilizables de UI (`CharacterCard`)

### Flujo de Datos

```
Presentation (UI)
    ↓ (Eventos)
BLoC
    ↓ (Use Cases)
Domain (Lógica de Negocio)
    ↓ (Repositories)
Data (Data Sources)
    ↓
API / Local Storage
```

## Librerías Principales

### Gestión de Estado

- **flutter_bloc** (^9.1.1): Patrón BLoC para gestión de estado reactiva y predecible

### Networking

- **dio** (^5.9.0): Cliente HTTP robusto para realizar llamadas a la API de Rick and Morty

### Persistencia Local

- **sqflite** (^2.4.2): Base de datos SQLite para almacenar favoritos localmente
- **path** (^1.9.0): Utilidades para manejo de rutas de archivos en el sistema

### Utilidades

- **equatable** (^2.0.7): Facilita la comparación de objetos, especialmente útil para estados y entidades en BLoC

## Estructura del Proyecto

```
lib/
├── app/
│   ├── app_module.dart          # Inyección de dependencias
│   ├── routes.dart               # Configuración de rutas
│   └── theme/
│       └── app_theme.dart        # Configuración del tema oscuro
├── core/
│   ├── config/
│   │   └── environment.dart      # Configuración del entorno
│   ├── database/
│   │   └── database_helper.dart  # Helper para SQLite
│   ├── error/
│   │   ├── exceptions.dart       # Excepciones personalizadas
│   │   └── failures.dart         # Failures para manejo de errores
│   ├── network/
│   │   ├── dio_client.dart       # Cliente HTTP configurado
│   │   ├── app_interceptor.dart  # Interceptores HTTP
│   │   └── endpoints.dart        # Endpoints de la API
│   └── utils/
│       ├── character_helper.dart  # Utilidades para personajes
│       └── constans.dart         # Constantes de la app
└── features/
    ├── characteres/              # Feature de listado de personajes
    │   ├── data/
    │   │   ├── datasources/      # Fuentes de datos (remote/local)
    │   │   ├── models/           # Modelos de datos
    │   │   └── repositories/     # Implementaciones de repositorios
    │   ├── domain/
    │   │   ├── entities/         # Entidades de dominio
    │   │   ├── repositories/     # Interfaces de repositorios
    │   │   └── usecases/         # Casos de uso
    │   └── presentation/
    │       ├── bloc/             # BLoC para gestión de estado
    │       ├── pages/            # Pantallas
    │       └── widgets/          # Widgets reutilizables
    └── detail_characters/        # Feature de detalle de personajes
        ├── data/
        ├── domain/
        └── presentation/
```

## Información Técnica

- **Framework**: Flutter 3.35.5
- **Lenguaje**: Dart 3.9.2
- **Arquitectura**: Clean Architecture + SOLID Principles
- **Gestión de Estado**: BLoC Pattern
- **Plataformas**: Android e iOS
