# Supabase Schema Example

This example demonstrates how to use the supabase_schema_library to generate type-safe models from your Supabase database schema.

## Building the Example

Run this command from the example directory:

```bash
dart run build_runner build
```

For development, one watcher handles every stage:

```bash
dart run build_runner watch
```

## Generated Files

The build process will generate:
- `schema.supabase.dart` - Base schema with typed IDs and constants
- `schema.supabase.freezed.dart` - Freezed model implementations
- `schema.supabase.g.dart` - JSON serialization code