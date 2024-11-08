# Fudo Challenge - Instrucciones de Instalación y Uso

## Requisitos Previos
- Flutter 3.x
- Dart 3.x
- Git

## Pasos de Instalación

1. Clonar el repositorio:
```bash
git clone <url-del-repositorio>
cd fudo_challenge
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Generar código necesario:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Ejecutar la aplicación:
```bash
flutter run
```

## Tests

Ejecutar todos los tests:
```bash
flutter test
```

Ejecutar tests con cobertura:
```bash
flutter test --coverage
```

