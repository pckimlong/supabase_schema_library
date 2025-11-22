# Supabase Schema Library

A powerful Flutter/Dart code generator for Supabase that automates the creation of type-safe model classes, IDs, and select statements directly from your schema definitions.

## Features

- **Type-Safe Models**: Automatically generate `freezed` Dart classes from your schema.
- **Type-Safe IDs**: Generate strongly-typed IDs (using `extension type`) to prevent mixing up IDs from different tables.
- **Smart Select Statements**: Generate type-safe select statements, including nested joins with correct Supabase syntax.
- **Flexible Models**: Define multiple models (e.g., `User`, `CreateUserModel`) from a single schema definition.
- **Performance**: Built on `lean_builder` for fast code generation.

## Packages

This repository contains the following packages:

| Package | Description |
| --- | --- |
| [`supabase_schema`](./supabase_schema) | The core annotation package for defining schemas. |
| [`supabase_schema_generator`](./supabase_schema_generator) | The code generator that produces the model code. |

## Installation

Add the dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  supabase_schema: latest_version
  lean_builder: latest_version
  freezed_annotation: latest_version
  json_annotation: latest_version
  # ... other dependencies

dev_dependencies:
  build_runner: latest_version
  supabase_schema_generator: latest_version
  freezed: latest_version
  json_serializable: latest_version
  # ... other dev dependencies
```

## Usage

### 1. Define your Schema

Create a file (e.g., `schema.dart`) and define your database schema by extending `SupabaseSchema` and using the `@Schema` annotation.

```dart
import 'package:supabase_schema/supabase_schema.dart';
import 'schema.supabase.dart'; // This will be generated

@Schema(tableName: 'users', baseModelName: 'User')
class UserSchema extends SupabaseSchema {
  final id = Field.intId().aliasAs('UserId');
  final name = Field<String>('name');
  final email = Field<String>('email');
  final createdAt = Field<DateTime>('created_at');

  // Define relationships
  final joinUserId = Field.join<User>().withForeignKey('join_user_id');

  @override
  List<Model> get models => [
    // Default model is generated automatically based on baseModelName
    
    // You can define additional models with specific fields
    Model('CreateUserModel').fields([
      id,
      name,
      email,
      createdAt,
    ]),
  ];
}
```

### 2. Run the Generator

Run the build runner to generate the code:

```bash
dart run build_runner build
```

Or watch for changes:

```bash
dart run build_runner watch
```

### 3. Use the Generated Code

The generator produces a `.supabase.dart` file containing your models and helper constants.

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'schema.supabase.dart'; // Generated file

void main() async {
  final supabase = Supabase.instance.client;

  // Type-safe select with nested joins
  final users = await supabase
      .from(User.tableName)
      .select(User.selectColumns)
      .withConverter((data) => data.map(User.fromJson).toList());

  for (var user in users) {
    print('User: ${user.name} (ID: ${user.id})');
  }
}
```

## Why `lean_builder`?

We use `lean_builder` to ensure fast and efficient code generation. It separates the build process, allowing for better performance and compatibility with other code generators like `freezed`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.