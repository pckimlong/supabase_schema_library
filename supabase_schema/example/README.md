# Supabase Schema Example

This example demonstrates how to use the supabase_schema_library to generate type-safe models from your Supabase database schema.

## Building the Example

To generate the code for this example, run the following commands in sequence:

```bash
# Step 1: Generate the base schema file
dart run lean_builder build

# Step 2: Generate the freezed models and other nested code
dart run build_runner build
```

Or for development, you can run both in watch mode:

```bash
# Terminal 1: Watch for schema changes
dart run lean_builder watch

# Terminal 2: Watch for generated file changes
dart run build_runner watch
```

## Generated Files

The build process will generate:
- `schema.supabase.dart` - Base schema with typed IDs and constants
- `schema.supabase.freezed.dart` - Freezed model implementations
- `schema.supabase.g.dart` - JSON serialization code