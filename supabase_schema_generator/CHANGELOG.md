## 0.0.6

* **BREAKING**: Replace Lean Builder with build_runner. Run `dart run build_runner build` or `dart run build_runner watch` to generate `.supabase.dart`, `.supabase.freezed.dart`, and `.supabase.g.dart` in one pipeline.
* **BREAKING**: Require Dart 3.11 or newer and analyzer `>=13.3.0 <15.0.0`; remove support for the previous analyzer 7–10 range.
* Require `supabase_schema` 0.0.4.
* Preserve AST-based field parsing so schemas can reference models that have not been generated yet on a clean build.
* Support analyzer 13.3 and 14.x without dependency overrides. Verify compatibility with analyzer 13.3.0, 14.0.0, and 14.3.0, including older build_runner and JSON Serializable releases.
* Add CI compatibility checks covering clean generation, cross-schema references, incremental updates, and unchanged-input builds.
* Update the example to Dart 3.13 and Freezed 4, regenerate its outputs, and document the single-command workflow.

## 0.0.5

* Generate an import of the source schema file in `.supabase.dart` outputs (for example, `user.supabase.dart` now imports `user.dart`) so source-defined types like enums are available.
* Add generated-file ignores for lint-only warnings (`type=lint`, `invalid_annotation_target`, `unused_import`) to avoid CI lint/format check failures on generated code.

## 0.0.4

* Bump `analyzer` constraint to `>=7.4.0 <11.0.0` (supports v10)
* Bump `lean_builder` to `^0.1.7`
* Bump `supabase_schema` dependency to `^0.0.3`

## 0.0.3

* Fix: Generate fields with nested generic types (e.g. `List<Map<String, dynamic>>`, `Map<String, dynamic>`, `List<String>?`) instead of silently dropping them.

## 0.0.2

* **BREAKING**: Removed `.empty()` factory constructor from generated ID extension types
* **BREAKING**: Changed ID extension type parameter from `id` to `value`
* Added `fromValue()` factory constructor to ID extension types for more explicit value creation
* Removed redundant `value` getter from ID extension types (now directly accessible as parameter)

## 0.0.1

* Initial release of the Supabase schema generator.
