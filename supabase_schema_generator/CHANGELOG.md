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
