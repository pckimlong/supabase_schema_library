import 'package:meta/meta.dart';

export 'package:freezed_annotation/freezed_annotation.dart';

// -------------------------
// Schema annotation
// -------------------------
class Schema {
  final String tableName;
  final String? className;

  /// Optional base model
  final String? baseModelName;

  /// Mixins to apply to the base model (and inherited by all DTOs)
  final List<Type> mixins;

  const Schema({
    required this.tableName,
    this.className,
    this.baseModelName,
    this.mixins = const [],
  });
}

// -------------------------
// Core field model
// -------------------------
abstract class BaseField<T> {
  final String? key;
  const BaseField({required this.key});
}

/// Simple typed field pointing to a storage key/column.
class Field<T> extends BaseField<T> {
  const Field(String key) : super(key: key);

  // Convenience helpers for IDs and joins.
  static IdField<int> intId([String key = 'id']) => IdField<int>(key);
  static IdField<String> stringId([String key = 'id']) => IdField<String>(key);
  static JoinField<U> join<U>() => const JoinField();
}

/// Identifier field with optional generated wrapper/type name.
class IdField<T> extends BaseField<T> {
  final String? generatedName; // if null, generator infers <ClassName>Id
  const IdField(String key) : generatedName = null, super(key: key);
  const IdField._(String key, this.generatedName) : super(key: key);

  /// Override the generated Id type/class name.
  @useResult
  IdField<T> named([String? idClassName]) => IdField._(key!, idClassName);
}

/// Join/reference field with optional FK/CK hints (for AST only).
class JoinField<T> extends BaseField<T> {
  final String? foreignKey;
  final String? candidateKey;

  const JoinField({this.foreignKey, this.candidateKey}) : super(key: null);

  @useResult
  JoinField<T> withForeignKey(String key) =>
      JoinField(foreignKey: key, candidateKey: candidateKey);

  @useResult
  JoinField<T> withCandidateKey(String key) =>
      JoinField(foreignKey: foreignKey, candidateKey: key);
}

// -------------------------
// DTO field decorator: per-DTO overrides (nullable/required/default/alias)
// -------------------------
class ModelField<T> {
  final BaseField<T> field;
  final String? alias; // alternate name in DTO/model
  /// Make it nullable it do nothing if base field is already nullable
  /// otherwise, it makes it nullable in the DTO
  final bool isNullable;

  const ModelField(this.field, {this.alias, this.isNullable = false});

  /// Alias the field in the DTO/model
  /// e.g. base field is 'id' but you want 'userId' in the DTO
  @useResult
  ModelField<T> aliasAs(String name) =>
      ModelField<T>(field, alias: name, isNullable: isNullable);

  @useResult
  ModelField<T> nullable() =>
      ModelField<T>(field, alias: alias, isNullable: true);
}

extension DtoFieldOps<T> on BaseField<T> {
  @useResult
  ModelField<T> asDto() => ModelField<T>(this);
  @useResult
  ModelField<T> nullable() => ModelField<T>(this).nullable();
  @useResult
  ModelField<T> aliasAs(String name) => ModelField<T>(this).aliasAs(name);
}

// -------------------------
// Model: collects base fields + DTO overrides
// -------------------------
class Model {
  final String _name;
  // Base field selection (typed, not decorated)
  final List<BaseField> _fields;
  // Per-DTO decorated fields
  final List<ModelField> _dtoFields;
  final bool _inherited; // inherit from base schema
  final List<BaseField> _excepts; // fields to omit from inheritance
  final String? _tableName; // optional table binding
  final List<Type> _mixins; // additional mixins for this model
  final List<Type>
  _excludedMixins; // Schema-level mixins to exclude from this model

  const Model._(
    this._name,
    this._fields,
    this._dtoFields,
    this._inherited,
    this._excepts,
    this._tableName,
    this._mixins,
    this._excludedMixins,
  );

  factory Model(String name) => Model._(
    name,
    const [],
    const [],
    false,
    const [],
    null,
    const [],
    const [],
  );

  // -------- Base selection APIs --------

  /// Mark that this model inherits fields from the base schema (generator resolves actual list).
  @useResult
  Model inheritAllFromBase({List<BaseField> excepts = const []}) => Model._(
    _name,
    _fields,
    _dtoFields,
    true,
    [...excepts],
    _tableName,
    _mixins,
    _excludedMixins,
  );

  /// Select the fields for this model. Accepts BaseField and ModelField.
  @useResult
  Model fields(Iterable<Object> fields) {
    final base = <BaseField>[];
    final deco = <ModelField>[];
    for (final f in fields) {
      if (f is ModelField) deco.add(f);
      if (f is BaseField) base.add(f);
    }
    return Model._(
      _name,
      [..._fields, ...base],
      [..._dtoFields, ...deco],
      _inherited,
      _excepts,
      _tableName,
      _mixins,
      _excludedMixins,
    );
  }

  // -------- Bindings --------

  /// Bind model to a concrete table (e.g., for Supabase CRUD)
  @useResult
  Model table([String? tableName]) => Model._(
    _name,
    _fields,
    _dtoFields,
    _inherited,
    _excepts,
    tableName,
    _mixins,
    _excludedMixins,
  );

  // -------- Mixins --------

  /// Add a mixin to this model (merges with Schema-level mixins)
  @useResult
  Model withMixin(Type mixin) => Model._(
    _name,
    _fields,
    _dtoFields,
    _inherited,
    _excepts,
    _tableName,
    [..._mixins, mixin],
    _excludedMixins,
  );

  /// Add multiple mixins to this model (merges with Schema-level mixins)
  @useResult
  Model withMixins(List<Type> mixins) => Model._(
    _name,
    _fields,
    _dtoFields,
    _inherited,
    _excepts,
    _tableName,
    [..._mixins, ...mixins],
    _excludedMixins,
  );

  /// Exclude a Schema-level mixin from this model
  @useResult
  Model withoutMixin(Type mixin) => Model._(
    _name,
    _fields,
    _dtoFields,
    _inherited,
    _excepts,
    _tableName,
    _mixins,
    [..._excludedMixins, mixin],
  );

  /// Exclude multiple Schema-level mixins from this model
  @useResult
  Model withoutMixins(List<Type> mixins) => Model._(
    _name,
    _fields,
    _dtoFields,
    _inherited,
    _excepts,
    _tableName,
    _mixins,
    [..._excludedMixins, ...mixins],
  );
}

// -------------------------
// Schema base
// -------------------------
abstract class SupabaseSchema {
  /// Additional models to generate from this schema (DTOs/views/etc.)
  List<Model> get models => const [];
}
