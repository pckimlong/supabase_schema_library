import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:lean_builder/builder.dart';
import 'package:lean_builder/element.dart';
import 'package:recase/recase.dart';
import 'package:supabase_schema/supabase_schema.dart';

import 'ir.dart';

@LeanGenerator({'.supabase.dart'})
class SupabaseTableGenerator extends GeneratorForAnnotatedClass<Schema> {
  @override
  FutureOr<Iterable<String>> generateForClass(
    BuildStep buildStep,
    ClassElement element,
    ElementAnnotation annotation,
  ) {
    final schemaIR = parseSchema(element, annotation);
    final metadataBanner = _buildMetadataBanner(schemaIR);

    final pieces = <String>[
      '// GENERATED CODE - DO NOT MODIFY BY HAND',
      '// dart format width=80',
      '',
      '// **************************************************************************',
      '// SupabaseTableGenerator',
      '// **************************************************************************',
      '',
      metadataBanner,
      '// ignore_for_file: invalid_annotation_target',
      '',
      ..._collectLibraryImports(element),
      _buildPartDirective(element, 'freezed.dart'),
      _buildPartDirective(element, 'g.dart'),
    ];

    // Generate ID wrapper classes for each IdField.
    final idClassNames = <String>{};
    final idFields = schemaIR.baseFields.where((f) => f.kind == 'id').toList();
    for (final idField in idFields) {
      final idClassName =
          idField.idWrapperName ?? '${schemaIR.baseModelClassName}Id';
      if (!idClassNames.add(idClassName)) {
        throw ArgumentError(
          'Multiple ID fields in ${element.name} schema cannot have the same generated wrapper name. Please provide explicit names using IdField.named().',
        );
      }
      pieces.add(_buildIdClassSnippet(idField, idClassName));
    }

    pieces.add(_generateBaseModelClass(schemaIR));
    pieces.addAll(_generateModelClasses(schemaIR));

    return pieces;
  }
}

String _generateBaseModelClass(SchemaIR schema) {
  final buffer = StringBuffer();
  final baseModelName = schema.baseModelClassName;
  final tableName = schema.tableName;

  final fields = schema.baseFields
      .map((f) => _resolvedFieldFromSchemaField(f, schema))
      .toList();

  // Build mixin clause from Schema-level mixins
  final mixinClause = schema.mixins.isNotEmpty
      ? ', ${schema.mixins.join(', ')}'
      : '';

  buffer.writeln('@freezed');
  buffer.writeln(
    'sealed class $baseModelName with _\$$baseModelName$mixinClause {',
  );
  buffer.writeln('  const $baseModelName._();');
  buffer.writeln();
  buffer.writeln('  @JsonSerializable(explicitToJson: true)');

  if (fields.isNotEmpty) {
    buffer.writeln('  const factory $baseModelName({');

    for (final field in fields) {
      buffer.writeln(
        '    @JsonKey(name: "${field.jsonKey}") required ${field.dartType} ${field.propertyName},',
      );
    }

    buffer.writeln('  }) = _$baseModelName;');
  } else {
    buffer.writeln('  const factory $baseModelName() = _$baseModelName;');
  }

  buffer.writeln();
  buffer.writeln(
    '  factory $baseModelName.fromJson(Map<String, dynamic> json) => _\$${baseModelName}FromJson(json);',
  );
  buffer.writeln();
  buffer.writeln(
    '// These constrains can be helpful for queries, filter by etc.',
  );
  buffer.writeln('  static const String tableName = "$tableName";');

  for (final field in fields) {
    buffer.writeln(
      '  static const String ${_camelCase(field.jsonKey)}Key = "${field.jsonKey}";',
    );
  }

  buffer.writeln();
  buffer.writeln('// These for safer select statements');

  final selectString = _composeSelectColumns(fields);

  buffer.writeln("  static String get selectColumns => '$selectString';");
  buffer.writeln('}');

  return buffer.toString();
}

Iterable<String> _generateModelClasses(SchemaIR schema) {
  if (schema.models.isEmpty) return const [];

  return schema.models.map((model) {
    final fields = _resolveModelFields(schema, model);
    final buffer = StringBuffer();

    // Merge Schema-level and Model-level mixins, filtering out excluded ones
    // 1. Start with Schema mixins, remove excluded ones
    final schemaMixins = schema.mixins
        .where((m) => !model.excludedMixins.contains(m))
        .toList();
    // 2. Add Model-specific mixins
    final allMixins = [...schemaMixins, ...model.mixins];
    final mixinClause = allMixins.isNotEmpty ? ', ${allMixins.join(', ')}' : '';

    buffer.writeln();
    buffer.writeln('@freezed');
    buffer.writeln(
      'sealed class ${model.name} with _\$${model.name}$mixinClause {',
    );
    buffer.writeln('  const ${model.name}._();');
    buffer.writeln();
    buffer.writeln('  @JsonSerializable(explicitToJson: true)');

    if (fields.isNotEmpty) {
      buffer.writeln('  const factory ${model.name}({');

      for (final field in fields) {
        buffer.writeln(
          '    @JsonKey(name: "${field.jsonKey}") required ${field.dartType} ${field.propertyName},',
        );
      }

      buffer.writeln('  }) = _${model.name};');
    } else {
      buffer.writeln('  const factory ${model.name}() = _${model.name};');
    }

    buffer.writeln();
    buffer.writeln(
      '  factory ${model.name}.fromJson(Map<String, dynamic> json) => _\$${model.name}FromJson(json);',
    );
    buffer.writeln();

    // Always generate tableName, using model override or schema default
    final tableNameValue = model.tableName ?? schema.tableName;
    buffer.writeln('  static const String tableName = "$tableNameValue";');
    buffer.writeln();

    for (final field in fields) {
      buffer.writeln(
        '  static const String ${_camelCase(field.jsonKey)}Key = "${field.jsonKey}";',
      );
    }

    buffer.writeln();
    final selectColumns = _composeSelectColumns(fields);
    buffer.writeln("  static String get selectColumns => '$selectColumns';");
    buffer.writeln('}');

    return buffer.toString();
  }).toList();
}

String _buildIdClassSnippet(SchemaFieldIR idField, String idClassName) {
  final buffer = StringBuffer();
  _generateIdClass(buffer, idField, idClassName);
  return buffer.toString();
}

Iterable<String> _collectLibraryImports(ClassElement element) sync* {
  final unit = element.library.compilationUnit;
  final shortUrl = element.librarySrc.shortUri;
  final baseName = shortUrl.pathSegments.last.split('.').first;
  final generatedSuffix = '$baseName.supabase.dart';
  for (final directive in unit.directives.whereType<ImportDirective>()) {
    final uri = directive.uri.stringValue;
    if (uri == null) continue;
    if (uri.endsWith(generatedSuffix)) continue;
    yield directive.toSource();
  }
}

String _buildPartDirective(ClassElement element, String suffix) {
  final shortUrl = element.librarySrc.shortUri;
  final base = shortUrl.pathSegments.last.split('.').first;
  return "part '$base.supabase.$suffix';";
}

String _buildMetadataBanner(SchemaIR schema) {
  final baseModelName = schema.baseModelClassName;
  final modelNames = schema.models.map((m) => m.name).toList();
  final modelLine = modelNames.isEmpty ? 'none' : modelNames.join(', ');
  return [
    '// --------------------------------------------------------------------------',
    '// Metadata:',
    '// - Schema: ${schema.schemaClass}',
    '// - Table: ${schema.tableName}',
    '// - Base model: $baseModelName',
    '// - Base fields: ${schema.baseFields.length}',
    '// - Models (${modelNames.length}): $modelLine',
    '// --------------------------------------------------------------------------',
  ].join('\n');
}

class _ResolvedModelField {
  const _ResolvedModelField({
    required this.propertyName,
    required this.jsonKey,
    required this.dartType,
    required this.isJoin,
    this.joinForeignKey,
    this.joinCandidateKey,
    this.joinTargetType,
  });

  final String propertyName;
  final String jsonKey;
  final String dartType;
  final bool isJoin;
  final String? joinForeignKey;
  final String? joinCandidateKey;
  final String? joinTargetType;
}

class _ResolvedFieldEntry {
  const _ResolvedFieldEntry(this.field, {this.replacePropertyName});

  final _ResolvedModelField field;
  final String? replacePropertyName;
}

_ResolvedModelField _resolvedFieldFromSchemaField(
  SchemaFieldIR field,
  SchemaIR schema,
) {
  final propertyName = _camelCase(field.name);
  // Use the wrapper name if this is an ID field with a named type
  final dartType = (field.isId)
      ? (field.idWrapperName ?? '${schema.baseModelClassName}Id')
      : (field.dartType ?? 'dynamic').trim();
  final jsonKey = field.isJoin ? propertyName : field.jsonKey;

  return _ResolvedModelField(
    propertyName: propertyName,
    jsonKey: jsonKey,
    dartType: dartType,
    isJoin: field.isJoin,
    joinForeignKey: field.joinForeignKey,
    joinCandidateKey: field.joinCandidateKey,
    joinTargetType: field.joinTargetType ?? field.dartType,
  );
}

List<_ResolvedModelField> _resolveModelFields(SchemaIR schema, ModelIR model) {
  final baseLookup = {for (final field in schema.baseFields) field.name: field};
  final resolved = <_ResolvedModelField>[];
  var fallbackIndex = 0;

  if (model.inheritAll) {
    for (final baseField in schema.baseFields) {
      if (model.excepts.contains(baseField.name)) continue;
      resolved.add(_resolvedFieldFromSchemaField(baseField, schema));
    }
  }

  for (final field in model.fields) {
    final entry = _resolveModelFieldEntry(
      field,
      baseLookup,
      schema,
      () => 'field${fallbackIndex++}',
    );
    if (entry == null) continue;

    final replace = entry.replacePropertyName;
    if (replace != null) {
      final index = resolved.indexWhere((f) => f.propertyName == replace);
      if (index != -1) {
        resolved.removeAt(index);
        resolved.insert(index, entry.field);
        continue;
      }
    }

    final existingIndex = resolved.indexWhere(
      (f) => f.propertyName == entry.field.propertyName,
    );
    if (existingIndex != -1) {
      resolved[existingIndex] = entry.field;
    } else {
      resolved.add(entry.field);
    }
  }

  return resolved;
}

_ResolvedFieldEntry? _resolveModelFieldEntry(
  ModelFieldIR field,
  Map<String, SchemaFieldIR> baseLookup,
  SchemaIR schema,
  String Function() fallbackName,
) {
  if (field.origin == 'base') {
    final baseName = field.baseName;
    if (baseName == null) return null;
    final baseField = baseLookup[baseName];
    if (baseField == null) return null;
    final baseResolved = _resolvedFieldFromSchemaField(baseField, schema);
    final propertyName = _sanitizePropertyName(
      field.aliasAs ?? baseResolved.propertyName,
      fallbackName,
    );
    var dartType = baseResolved.dartType;
    if (field.makeNullable) {
      dartType = _ensureNullableType(dartType);
    }

    final resolved = _ResolvedModelField(
      propertyName: propertyName,
      jsonKey: baseResolved.isJoin ? propertyName : baseResolved.jsonKey,
      dartType: dartType,
      isJoin: baseResolved.isJoin,
      joinForeignKey: baseResolved.joinForeignKey,
      joinCandidateKey: baseResolved.joinCandidateKey,
      joinTargetType: baseResolved.joinTargetType ?? baseResolved.dartType,
    );

    return _ResolvedFieldEntry(
      resolved,
      replacePropertyName: baseResolved.propertyName,
    );
  }

  final propertyName = _sanitizePropertyName(
    field.aliasAs ??
        (field.storageKey != null && field.storageKey!.isNotEmpty
            ? _camelCase(field.storageKey!)
            : null),
    fallbackName,
  );

  var dartType = (field.dartType ?? 'dynamic').trim();
  if ((field.baseIsNullable ?? false) || field.makeNullable) {
    dartType = _ensureNullableType(dartType);
  }

  final jsonKey = field.isJoin
      ? propertyName
      : (field.storageKey ?? propertyName);

  final resolved = _ResolvedModelField(
    propertyName: propertyName,
    jsonKey: jsonKey,
    dartType: dartType,
    isJoin: field.isJoin,
    joinForeignKey: field.joinForeignKey,
    joinCandidateKey: field.joinCandidateKey,
    joinTargetType: field.joinTargetType ?? (field.isJoin ? dartType : null),
  );

  return _ResolvedFieldEntry(resolved);
}

String _composeSelectColumns(List<_ResolvedModelField> fields) {
  final joins = <String>[];
  final columns = <String>[];

  for (final field in fields) {
    if (field.isJoin) {
      final joinTypeSource = field.joinTargetType ?? field.dartType;
      final joinType =
          (extractJoinTargetTypeFromString(joinTypeSource) ?? 'dynamic')
              .replaceAll('?', '')
              .replaceAll('!', '');
      final selectStatement = "(\${$joinType.selectColumns})";
      final tableName = "\${$joinType.tableName}";
      final alias = field.propertyName;
      final foreignKey = field.joinForeignKey;
      final candidateKey = field.joinCandidateKey;

      if (candidateKey == null || candidateKey.isEmpty) {
        if (foreignKey != null && foreignKey.isNotEmpty) {
          joins.add('$alias:$tableName!$foreignKey$selectStatement');
        } else {
          joins.add('$alias:$tableName$selectStatement');
        }
      } else {
        joins.add('$alias:$tableName!$candidateKey$selectStatement');
      }
    } else {
      if (field.jsonKey.isNotEmpty) {
        columns.add(field.jsonKey);
      }
    }
  }

  return [
    columns.join(','),
    joins.join(','),
  ].where((part) => part.isNotEmpty).join(',');
}

String _ensureNullableType(String type) {
  final trimmed = type.trim();
  if (trimmed.endsWith('?')) return trimmed;
  return '$trimmed?';
}

String _sanitizePropertyName(String? candidate, String Function() fallback) {
  if (candidate == null) return fallback();
  final normalized = candidate.trim();
  if (_isValidIdentifier(normalized)) return normalized;
  return fallback();
}

bool _isValidIdentifier(String name) => _identifierPattern.hasMatch(name);

final _identifierPattern = RegExp(r'^[a-zA-Z_]\w*$');

String _camelCase(String value) {
  if (value.isEmpty) return value;
  return ReCase(value).camelCase;
}

void _generateIdClass(
  StringBuffer buffer,
  SchemaFieldIR idField,
  String idClassName,
) {
  buffer.writeln('extension type $idClassName._(${idField.dartType} value) {');
  buffer.writeln(
    '  factory $idClassName.fromValue(${idField.dartType} value) => $idClassName._(value);',
  );
  buffer.writeln('  factory $idClassName.fromJson(dynamic value) {');
  buffer.writeln('    if (value is ${idField.dartType}) {');
  buffer.writeln('      return $idClassName._(value);');
  buffer.writeln('    } else if (value == null) {');
  buffer.writeln('      throw ArgumentError.notNull(\'value\');');
  buffer.writeln('    } else {');
  buffer.writeln(
    '      throw ArgumentError(\'Value of $idClassName must be of type ${idField.dartType}, but was \${value.runtimeType}. Please provide the correct type.\');',
  );
  buffer.writeln('    }');
  buffer.writeln('  }');
  buffer.writeln('  ${idField.dartType} toJson() => value;');
  buffer.writeln('  ${idField.dartType} call() => value;');
  buffer.writeln('}');
}
