## 0.0.3

* Bump `analyzer` constraint to `>=7.4.0 <11.0.0` (supports v10)
* Bump `lean_builder` to `^0.1.7`

## 0.0.2

* **BREAKING**: Removed `.empty()` factory constructor from generated ID extension types
* **BREAKING**: Changed ID extension type parameter from `id` to `value`
* Added `fromValue()` factory constructor to ID extension types for more explicit value creation
* Removed redundant `value` getter from ID extension types (now directly accessible as parameter)

## 0.0.1

* Initial release
