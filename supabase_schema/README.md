# supabase_schema

The core annotation package for the Supabase Schema Library. This package provides the annotations and base types used to define your Supabase database schema in Dart.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  supabase_schema: latest_version
```

## Usage

Define your schema by extending `SupabaseSchema` and annotating it with `@Schema`.

### Basic Schema

```dart
import 'package:supabase_schema/supabase_schema.dart';

@Schema(tableName: 'todos', baseModelName: 'Todo')
class TodoSchema extends SupabaseSchema {
  // Define fields using the Field class
  final id = Field.intId();
  final title = Field<String>('title');
  final isCompleted = Field<bool>('is_completed');

  @override
  List<Model> get models => [
    // Define the models you want to generate
    Model('Todo'), // Generates a Todo class with all fields by default
  ];
}
```

### Fields

Use the `Field` class to define columns:

-   `Field<Type>('column_name')`: Standard field.
-   `Field.intId()`: Integer primary key.
-   `Field.stringId()`: String primary key.
-   `Field.uuid()`: UUID field.

### Relationships

Use `Field.join<TargetModel>()` to define relationships:

```dart
final user = Field.join<User>().withForeignKey('user_id');
```

### Multiple Models

You can define multiple models from the same schema, useful for different views or operations (e.g., Creation vs. Display):

```dart
@override
List<Model> get models => [
  Model('Todo'), // Full model
  Model('CreateTodo').fields([title, isCompleted]), // Model for creation (no ID)
];
```