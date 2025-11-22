# supabase_schema_generator

The code generator for the Supabase Schema Library. This package processes your schema definitions and generates type-safe Dart models (using `freezed`), strongly-typed IDs, and smart select statements.

## Installation

Add this package to your `dev_dependencies` in `pubspec.yaml`:

```yaml
dev_dependencies:
  supabase_schema_generator: latest_version
  build_runner: latest_version
  freezed: latest_version
  json_serializable: latest_version
```

## How it Works

1.  **Define Schema**: You define your schema using `supabase_schema` classes.
2.  **Run Builder**: You run `dart run build_runner build`.
3.  **Generate Code**: This generator reads your schema and produces a `.supabase.dart` file containing:
    *   **Freezed Models**: Immutable data classes with JSON serialization.
    *   **Typed IDs**: `extension type` wrappers around IDs (e.g., `UserId`) for type safety.
    *   **Constants**: Table names, column keys.
    *   **Select Columns**: A smart getter `selectColumns` that generates the correct Supabase select string, including nested joins.

## Generated Code Example

For a `User` model, it generates:

```dart
extension type UserId._(int id) {
  factory UserId.fromJson(dynamic value) => ...
  int toJson() => id;
}

@freezed
sealed class User with _$User {
  const factory User({
    @JsonKey(name: "id") required UserId id,
    @JsonKey(name: "name") required String name,
    // ...
  }) = _User;

  static const String tableName = "users";
  
  // Smart select string with joins
  static String get selectColumns => 'id,name,...';
}
```
