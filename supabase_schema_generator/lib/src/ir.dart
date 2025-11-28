import 'package:analyzer/dart/ast/ast.dart';
import 'package:lean_builder/element.dart';

// ------------ IR TYPES ------------

SchemaIR parseSchema(ClassElement element, ElementAnnotation annotation) {
  // 1) Extract annotation info
  final schemaAnno = annotation.constant as ConstObject;
  final tableName = schemaAnno.getString('tableName')!.value;
  final className = schemaAnno.getString('className')?.value;
  final baseModelName = schemaAnno.getString('baseModelName')?.value;

  // 2) Extract base fields and models via AST from compilation unit (more reliable)
  final classNode = _findClassNode(element);
  final baseFields = <SchemaFieldIR>[];

  // Extract mixins from annotation AST
  final mixinsList = <String>[];
  if (classNode != null) {
    for (final meta in classNode.metadata) {
      // meta.name can be SimpleIdentifier or PrefixedIdentifier
      final metaName = meta.name;
      final annotationName = metaName is SimpleIdentifier
          ? metaName.name
          : (metaName is PrefixedIdentifier ? metaName.identifier.name : null);

      if (annotationName == 'Schema') {
        final args = meta.arguments;
        if (args != null) {
          for (final arg in args.arguments) {
            if (arg is NamedExpression && arg.name.label.name == 'mixins') {
              final expr = arg.expression;
              if (expr is ListLiteral) {
                for (final elem in expr.elements) {
                  if (elem is SimpleIdentifier) {
                    mixinsList.add(elem.name);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  if (classNode != null) {
    for (final member in classNode.members) {
      if (member is FieldDeclaration) {
        for (final v in member.fields.variables) {
          final name = v.name.lexeme;
          final init = v.initializer;
          if (init == null) continue;
          final parsed = _parseSchemaFieldInitializer(name, init);
          if (parsed != null) baseFields.add(parsed);
        }
      }
    }
  } else {
    // Fallback to element.fields (may miss initializers in some cases)
    for (final f in element.fields) {
      if (f.isStatic || f.isSynthetic) continue;
      final init = f.initializer;
      if (init == null) continue;
      final parsed = _parseSchemaFieldInitializer(f.name, init);
      if (parsed != null) baseFields.add(parsed);
    }
  }

  // 3) Extract models getter
  final modelsIr = <ModelIR>[];
  final modelExprsSrc = <String>[];
  final modelChains = <List<String>>[];
  final modelChainSrc = <List<String>>[];
  if (classNode != null) {
    final getter = _findModelsGetter(classNode);
    if (getter != null) {
      final body = getter.body;
      Expression? valueExpr;
      if (body is ExpressionFunctionBody) {
        valueExpr = body.expression;
      } else if (body is BlockFunctionBody) {
        for (final s in body.block.statements) {
          if (s is ReturnStatement) {
            valueExpr = s.expression;
            break;
          }
        }
      }
      if (valueExpr is ListLiteral) {
        for (final elem in valueExpr.elements) {
          Expression? mexpr;
          if (elem is Expression) {
            mexpr = elem;
          } else if (elem is SpreadElement) {
            mexpr = elem.expression;
          }
          if (mexpr != null) {
            modelExprsSrc.add(mexpr.toSource());
            final ch = _flattenChain(mexpr);
            modelChains.add(ch.map((e) => e.runtimeType.toString()).toList());
            modelChainSrc.add(ch.map((e) => e.toSource()).toList());
            final model = _parseModelExpression(mexpr, baseFields);
            if (model != null) modelsIr.add(model);
          }
        }
      }
    }
  }

  return SchemaIR(
    schemaClass: element.name,
    tableName: tableName,
    className: className,
    baseModelName: baseModelName,
    baseFields: baseFields,
    models: modelsIr,
    mixins: mixinsList,
  );
}

class SchemaIR {
  final String schemaClass;
  final String tableName;
  final String? className;
  final String? baseModelName;
  final List<SchemaFieldIR> baseFields;
  final List<ModelIR> models;
  final List<String> mixins; // mixin type names from @Schema annotation

  SchemaIR({
    required this.schemaClass,
    required this.tableName,
    required this.className,
    required this.baseModelName,
    required this.baseFields,
    required this.models,
    this.mixins = const [],
  });

  String get baseModelClassName =>
      baseModelName ??
      className ??
      tableName.replaceFirst(tableName[0], tableName[0].toUpperCase());

  Map<String, Object?> toJson() => {
    'schemaClass': schemaClass,
    'tableName': tableName,
    'className': className,
    'baseModelName': baseModelName,
    'baseFields': baseFields.map((e) => e.toJson()).toList(),
    'models': models.map((e) => e.toJson()).toList(),
    'mixins': mixins,
  };
}

class SchemaFieldIR {
  final String name; // schema property name (e.g., id, name)
  final String kind; // regular | id | join
  final String? storageKey; // column key or FK
  final String? dartType; // e.g. int, String, DateTime?
  final bool? isNullable; // from type '?'
  final String? idWrapperName; // from IdField.named('UserId')
  final String? joinForeignKey;
  final String? joinCandidateKey;
  final String?
  joinTargetType; // resolved inner type for joins (e.g. SubCategory)

  String get jsonKey => storageKey ?? name;
  bool get isString => dartType == 'String' || dartType == 'String?';
  bool get isNumber =>
      dartType == 'int' ||
      dartType == 'double' ||
      dartType == 'num' ||
      dartType == 'int?' ||
      dartType == 'double?' ||
      dartType == 'num?';
  bool get isId => kind == 'id';
  bool get isInt => dartType == 'int' || dartType == 'int?';
  bool get isJoin => kind == 'join';

  SchemaFieldIR({
    required this.name,
    required this.kind,
    this.storageKey,
    this.dartType,
    this.isNullable,
    this.idWrapperName,
    this.joinForeignKey,
    this.joinCandidateKey,
    this.joinTargetType,
  });

  Map<String, Object?> toJson() => {
    'name': name,
    'kind': kind,
    'storageKey': storageKey,
    'dartType': dartType,
    'isNullable': isNullable,
    'idWrapperName': idWrapperName,
    'joinForeignKey': joinForeignKey,
    'joinCandidateKey': joinCandidateKey,
    'joinTargetType': joinTargetType,
  };
}

class ModelIR {
  final String name;
  final bool inheritAll;
  final List<String> excepts; // base field names
  final String? tableName;
  final List<ModelFieldIR> fields; // explicit picks/additions
  final List<ModelFieldIR> inherited; // fields coming from inheritAll
  final List<String> mixins; // mixin type names from .withMixin() calls
  final List<String>
  excludedMixins; // Schema-level mixins to exclude via .withoutMixin()

  ModelIR({
    required this.name,
    required this.inheritAll,
    required this.excepts,
    required this.tableName,
    required this.fields,
    required this.inherited,
    this.mixins = const [],
    this.excludedMixins = const [],
  });

  Map<String, Object?> toJson() => {
    'name': name,
    'inheritAll': inheritAll,
    'excepts': excepts,
    'tableName': tableName,
    'fields': fields.map((e) => e.toJson()).toList(),
    'inherited': inherited.map((e) => e.toJson()).toList(),
    'mixins': mixins,
    'excludedMixins': excludedMixins,
  };
}

class ModelFieldIR {
  final String origin; // base | adhoc
  final String? baseName; // schema field name if base
  final String? storageKey; // for adhoc
  final String? dartType; // e.g. int, String, DateTime?
  final bool? baseIsNullable; // from base or adhoc type '?'
  final bool makeNullable; // override request in model
  final String? aliasAs; // alternative DTO name
  final bool isInheritedFromBase; // flagged when included via inheritAll
  final bool isJoin; // whether this is a join field
  final String? joinForeignKey; // foreign key for joins
  final String? joinCandidateKey; // candidate key for joins
  final String? joinTargetType; // resolved target type for joins

  ModelFieldIR({
    required this.origin,
    this.baseName,
    this.storageKey,
    this.dartType,
    this.baseIsNullable,
    required this.makeNullable,
    this.aliasAs,
    required this.isInheritedFromBase,
    this.isJoin = false,
    this.joinForeignKey,
    this.joinCandidateKey,
    this.joinTargetType,
  });

  Map<String, Object?> toJson() => {
    'origin': origin,
    'baseName': baseName,
    'storageKey': storageKey,
    'dartType': dartType,
    'baseIsNullable': baseIsNullable,
    'makeNullable': makeNullable,
    'aliasAs': aliasAs,
    'isInheritedFromBase': isInheritedFromBase,
    'isJoin': isJoin,
    'joinForeignKey': joinForeignKey,
    'joinCandidateKey': joinCandidateKey,
    'joinTargetType': joinTargetType,
  };
}

// ------------ PARSERS ------------

ClassDeclaration? _findClassNode(ClassElement element) {
  final unit = element.library.compilationUnit;
  for (final d in unit.declarations) {
    if (d is ClassDeclaration && d.name.lexeme == element.name) return d;
  }
  return null;
}

MethodDeclaration? _findModelsGetter(ClassDeclaration clazz) {
  for (final m in clazz.members) {
    if (m is MethodDeclaration) {
      if (m.isGetter && m.name.lexeme == 'models') return m;
    }
  }
  return null;
}

SchemaFieldIR? _parseSchemaFieldInitializer(String fieldName, Expression init) {
  // Handles: Field<T>('key'), Field.intId([key]).named('Wrapper'), Field.join<T>().withForeignKey('fk')
  // Also accepts nullable types like T?
  final chain = _flattenChain(init);
  if (chain.isEmpty) return null;

  // Prefer static calls on Field: Field.intId / Field.stringId / Field.join
  MethodInvocation? fieldStatic;
  for (final n in chain.whereType<MethodInvocation>()) {
    final t = n.target;
    if (t is SimpleIdentifier && t.name == 'Field') {
      fieldStatic = n;
      break;
    }
  }
  if (fieldStatic != null) {
    final method = fieldStatic.methodName.name;
    if (method == 'intId' || method == 'stringId') {
      final key = _firstStringArg(fieldStatic.argumentList) ?? fieldName;
      final dartType = method == 'intId' ? 'int' : 'String';
      String? wrapperName;
      for (final n in chain.whereType<MethodInvocation>()) {
        if (n.methodName.name == 'named') {
          wrapperName = _firstStringArg(n.argumentList);
        }
      }
      return SchemaFieldIR(
        name: fieldName,
        kind: 'id',
        storageKey: key,
        dartType: dartType,
        isNullable: false,
        idWrapperName: wrapperName,
      );
    }
    if (method == 'join') {
      final targs =
          fieldStatic.typeArguments?.arguments ?? const <TypeAnnotation>[];
      final dartType = targs.isNotEmpty ? targs.first.toSource() : null;
      final resolvedJoinTarget = targs.isNotEmpty
          ? _extractJoinTargetType(targs.first)
          : extractJoinTargetTypeFromString(dartType);
      String? fk;
      String? ck;
      for (final n in chain.whereType<MethodInvocation>()) {
        switch (n.methodName.name) {
          case 'withForeignKey':
            fk = _firstStringArg(n.argumentList);
            break;
          case 'withCandidateKey':
            ck = _firstStringArg(n.argumentList);
            break;
        }
      }
      return SchemaFieldIR(
        name: fieldName,
        kind: 'join',
        storageKey: fk,
        dartType: dartType,
        isNullable: (dartType ?? '').trim().endsWith('?'),
        joinForeignKey: fk,
        joinCandidateKey: ck,
        joinTargetType: resolvedJoinTarget,
      );
    }
  }

  // Constructor case: Field<T>('key')
  final ctor = chain.firstWhere(
    (e) => e is InstanceCreationExpression,
    orElse: () => init,
  );
  if (ctor is InstanceCreationExpression) {
    String? dartType;
    // Prefer reading from type arguments; fallback to parsing toSource
    final typeArgs =
        ctor.constructorName.type.typeArguments?.arguments ??
        const <TypeAnnotation>[];
    if (typeArgs.isNotEmpty) {
      dartType = typeArgs.first.toSource();
    } else {
      final typeSrc = ctor.constructorName.type.toSource();
      final m = RegExp(r'<(.+)>').firstMatch(typeSrc);
      if (m != null) dartType = m.group(1)?.trim();
    }
    final key = _firstStringArg(ctor.argumentList) ?? fieldName;
    return SchemaFieldIR(
      name: fieldName,
      kind: 'regular',
      storageKey: key,
      dartType: dartType,
      isNullable: (dartType ?? '').trim().endsWith('?'),
    );
  }

  // Fallback: parse from source string patterns
  final src = init.toSource();
  // Field<T>('key')
  final reCtor = RegExp(r'''^Field<([^>]+)>\((?:'([^']*)'|"([^"]*)")\)''');
  final mCtor = reCtor.firstMatch(src);
  if (mCtor != null) {
    final t = (mCtor.group(1) ?? '').trim();
    final key = (mCtor.group(2) ?? mCtor.group(3) ?? fieldName).trim();
    return SchemaFieldIR(
      name: fieldName,
      kind: 'regular',
      storageKey: key,
      dartType: t,
      isNullable: t.endsWith('?'),
    );
  }
  // Field.intId([key]) / Field.stringId([key])
  final reId = RegExp(r'''^Field\.(intId|stringId)\(([^)]*)\)''');
  final mId = reId.firstMatch(src);
  if (mId != null) {
    final method = mId.group(1);
    final arg = mId.group(2)?.trim();
    final key = (arg != null && arg.isNotEmpty)
        ? arg.replaceAll("'", '').replaceAll('"', '')
        : fieldName;
    return SchemaFieldIR(
      name: fieldName,
      kind: 'id',
      storageKey: key,
      dartType: method == 'intId' ? 'int' : 'String',
      isNullable: false,
    );
  }
  // Field.join<T>().withForeignKey('...')
  final reJoin = RegExp(
    r'''^Field\.join<([^>]+)>\(\)(?:\.withForeignKey\((?:'([^']*)'|"([^"]*)")\))?''',
  );
  final mJoin = reJoin.firstMatch(src);
  if (mJoin != null) {
    final t = (mJoin.group(1) ?? '').trim();
    final fk = (mJoin.group(2) ?? mJoin.group(3))?.trim();
    return SchemaFieldIR(
      name: fieldName,
      kind: 'join',
      storageKey: fk,
      dartType: t,
      isNullable: t.endsWith('?'),
      joinForeignKey: fk,
      joinTargetType: extractJoinTargetTypeFromString(t),
    );
  }

  return null;
}

ModelIR? _parseModelExpression(Expression expr, List<SchemaFieldIR> base) {
  final chain = _flattenChain(expr);
  if (chain.isEmpty) return null;

  // Find the Model(...) creation (can appear as InstanceCreationExpression or MethodInvocation)
  ArgumentList? modelArgs;
  for (final n in chain) {
    if (n is InstanceCreationExpression) {
      final typeNameSrc = n.constructorName.type.toSource();
      final baseName = typeNameSrc.contains('<')
          ? typeNameSrc.substring(0, typeNameSrc.indexOf('<')).trim()
          : typeNameSrc.trim();
      if (baseName == 'Model') {
        modelArgs = n.argumentList;
        break;
      }
    } else if (n is MethodInvocation) {
      // Some resolvers surface constructor-like calls as MethodInvocation
      if (n.target == null && n.methodName.name == 'Model') {
        modelArgs = n.argumentList;
        break;
      }
    }
  }
  if (modelArgs == null) return null;
  final modelName = _firstStringArg(modelArgs) ?? '<unnamed>';
  bool inheritAll = false;
  String? tableName;
  final excepts = <String>[];
  final explicitFields = <ModelFieldIR>[];
  final modelMixins = <String>[];
  final excludedMixins = <String>[];

  for (final n in chain) {
    if (n is MethodInvocation) {
      final name = n.methodName.name;
      switch (name) {
        case 'inheritAllFromBase':
          inheritAll = true;
          final arg = _findNamedArg(n.argumentList, 'excepts');
          if (arg != null && arg.expression is ListLiteral) {
            final list = arg.expression as ListLiteral;
            for (final e in list.elements.whereType<Expression>()) {
              if (e is SimpleIdentifier) excepts.add(e.name);
            }
          }
          break;
        case 'fields':
          final args = n.argumentList.arguments;
          if (args.isNotEmpty && args.first is ListLiteral) {
            final list = args.first as ListLiteral;
            for (final ce in list.elements) {
              Expression? fe;
              if (ce is Expression) fe = ce;
              if (ce is SpreadElement) fe = ce.expression;
              if (fe != null) {
                final mf = _parseModelFieldExpr(fe, base);
                if (mf != null) explicitFields.add(mf);
              }
            }
          }
          break;
        case 'table':
          tableName = _firstStringArg(n.argumentList) ?? tableName;
          break;
        case 'withMixin':
          // Extract single mixin type from withMixin(SomeMixin)
          final args = n.argumentList.arguments;
          if (args.isNotEmpty && args.first is SimpleIdentifier) {
            final mixinName = (args.first as SimpleIdentifier).name;
            if (mixinName.isNotEmpty) {
              modelMixins.add(mixinName);
            }
          }
          break;
        case 'withMixins':
          // Extract multiple mixins from withMixins([Mixin1, Mixin2])
          final args = n.argumentList.arguments;
          if (args.isNotEmpty && args.first is ListLiteral) {
            final list = args.first as ListLiteral;
            for (final e in list.elements.whereType<SimpleIdentifier>()) {
              if (e.name.isNotEmpty) {
                modelMixins.add(e.name);
              }
            }
          }
          break;
        case 'withoutMixin':
          // Extract single excluded mixin from withoutMixin(SomeMixin)
          final args = n.argumentList.arguments;
          if (args.isNotEmpty && args.first is SimpleIdentifier) {
            final mixinName = (args.first as SimpleIdentifier).name;
            if (mixinName.isNotEmpty) {
              excludedMixins.add(mixinName);
            }
          }
          break;
        case 'withoutMixins':
          // Extract multiple excluded mixins from withoutMixins([Mixin1, Mixin2])
          final args = n.argumentList.arguments;
          if (args.isNotEmpty && args.first is ListLiteral) {
            final list = args.first as ListLiteral;
            for (final e in list.elements.whereType<SimpleIdentifier>()) {
              if (e.name.isNotEmpty) {
                excludedMixins.add(e.name);
              }
            }
          }
          break;
        default:
          break;
      }
    }
  }

  // Build inherited fields snapshot (no validation, just merge later if duplicates)
  final inherited = <ModelFieldIR>[];
  if (inheritAll) {
    for (final bf in base) {
      if (excepts.contains(bf.name)) continue;
      inherited.add(
        ModelFieldIR(
          origin: 'base',
          baseName: bf.name,
          storageKey: bf.storageKey,
          dartType: bf.dartType,
          baseIsNullable: bf.isNullable,
          makeNullable: false,
          aliasAs: null,
          isInheritedFromBase: true,
        ),
      );
    }
  }

  return ModelIR(
    name: modelName,
    inheritAll: inheritAll,
    excepts: excepts,
    tableName: tableName,
    fields: explicitFields,
    inherited: inherited,
    mixins: modelMixins,
    excludedMixins: excludedMixins,
  );
}

ModelFieldIR? _parseModelFieldExpr(Expression expr, List<SchemaFieldIR> base) {
  // Cases:
  // 1) SimpleIdentifier => base ref
  // 2) MethodInvocation on SimpleIdentifier => base ref with overrides
  // 3) InstanceCreationExpression Field<T>('key') [.aliasAs/.nullable] => adhoc
  // 4) MethodInvocation starting at Field.intId()/Field.join<T>() => adhoc
  if (expr is SimpleIdentifier) {
    final name = expr.name;
    final baseMeta = base.firstWhere(
      (e) => e.name == name,
      orElse: () => SchemaFieldIR(
        name: name,
        kind: 'unknown',
        storageKey: null,
        dartType: null,
        isNullable: null,
      ),
    );
    return ModelFieldIR(
      origin: 'base',
      baseName: name,
      storageKey: baseMeta.storageKey,
      dartType: baseMeta.dartType,
      baseIsNullable: baseMeta.isNullable,
      makeNullable: false,
      aliasAs: null,
      isInheritedFromBase: false,
    );
  }

  final chain = _flattenChain(expr);
  if (chain.isEmpty) return null;

  // Detect base-ref chain
  Expression root = chain.first;
  bool isFieldStaticCall =
      false; // Declared here so it's in scope for adhoc check later

  if (root is SimpleIdentifier ||
      root is PropertyAccess ||
      root is PrefixedIdentifier) {
    final baseName = _extractSimpleName(root);

    // Check if this is actually a static call on Field (e.g. Field.join)
    // If the baseName is 'Field', we treat it as adhoc, UNLESS there happens to be a base field named 'Field'
    // (which is unlikely but possible). However, the usage `Field.join` strongly implies the static utility.
    // We'll prioritize the static utility interpretation if it looks like a method call on Field.
    if (baseName == 'Field') {
      // Check if there's a method invocation on this root
      for (final n in chain) {
        if (n is MethodInvocation && n.target != null) {
          final targetName = _extractSimpleName(n.target!);
          if (targetName == 'Field') {
            isFieldStaticCall = true;
            break;
          }
        }
      }
    }

    if (!isFieldStaticCall) {
      bool makeNullable = false;
      String? aliasAs;
      for (final n in chain.whereType<MethodInvocation>()) {
        switch (n.methodName.name) {
          case 'nullable':
            makeNullable = true;
            break;
          case 'aliasAs':
            aliasAs = _firstStringArg(n.argumentList) ?? aliasAs;
            break;
        }
      }
      final baseMeta = base.firstWhere(
        (e) => e.name == baseName,
        orElse: () => SchemaFieldIR(
          name: baseName,
          kind: 'unknown',
          storageKey: null,
          dartType: null,
          isNullable: null,
        ),
      );

      // If we found a base field, OR if it's not 'Field', we treat it as a base ref.
      // If it IS 'Field' but we didn't find a base field for it, we might fall through to adhoc handling
      // if we didn't return here. But currently we return a 'base' origin field even if unknown.
      // So we need to be careful.
      // If baseName is 'Field' and it is NOT in base fields, we should probably treat it as adhoc
      // (constructor or static).
      if (baseName != 'Field' || baseMeta.kind != 'unknown') {
        return ModelFieldIR(
          origin: 'base',
          baseName: baseName,
          storageKey: baseMeta.storageKey,
          dartType: baseMeta.dartType,
          baseIsNullable: baseMeta.isNullable,
          makeNullable: makeNullable,
          aliasAs: aliasAs,
          isInheritedFromBase: false,
        );
      }
    }
  }

  // Detect adhoc field chain
  // Cases:
  // - InstanceCreationExpression: Field<T>(...) when parsed as a constructor
  // - MethodInvocation with target=Field: Field.join<T>(), Field.intId(), etc.
  // - MethodInvocation with null target: Field<T>(...) when parsed as a method call
  // - root is SimpleIdentifier 'Field' with isFieldStaticCall=true (Field.join path)
  final isAdhocFieldChain =
      root is InstanceCreationExpression ||
      (root is MethodInvocation &&
          (root.target == null ||
              (root.target is SimpleIdentifier &&
                  (root.target as SimpleIdentifier).name == 'Field'))) ||
      (root is SimpleIdentifier && (root).name == 'Field' && isFieldStaticCall);

  if (isAdhocFieldChain) {
    String? dartType;
    String? storageKey;
    bool baseIsNullable = false;
    bool isJoin = false;
    String? joinForeignKey;
    String? joinCandidateKey;
    String? joinTargetType;

    for (final n in chain) {
      if (n is InstanceCreationExpression) {
        final typeArgs =
            n.constructorName.type.typeArguments?.arguments ??
            const <TypeAnnotation>[];
        if (typeArgs.isNotEmpty) {
          dartType = typeArgs.first.toSource();
        } else {
          final typeSrc = n.constructorName.type.toSource();
          final m = RegExp(r'\<(.+)\>').firstMatch(typeSrc);
          if (m != null) dartType = m.group(1)?.trim();
        }
        baseIsNullable = (dartType ?? '').trim().endsWith('?');
        storageKey = storageKey ?? _firstStringArg(n.argumentList);
      }
      if (n is MethodInvocation) {
        // Handle Field<T>('key') parsed as MethodInvocation with null target
        if (n.target == null && n.methodName.name == 'Field') {
          final targs = n.typeArguments?.arguments ?? const <TypeAnnotation>[];
          if (targs.isNotEmpty) {
            dartType = targs.first.toSource();
            baseIsNullable = dartType.trim().endsWith('?');
          }
          storageKey = storageKey ?? _firstStringArg(n.argumentList);
        }
        // Handle Field.join<T>(), Field.intId(), Field.stringId()
        else if (n.target is SimpleIdentifier &&
            (n.target as SimpleIdentifier).name == 'Field') {
          final method = n.methodName.name;
          if (method == 'intId') {
            dartType = 'int';
            storageKey = storageKey ?? _firstStringArg(n.argumentList) ?? 'id';
          } else if (method == 'stringId') {
            dartType = 'String';
            storageKey = storageKey ?? _firstStringArg(n.argumentList) ?? 'id';
          } else if (method == 'join') {
            isJoin = true;
            final targs =
                n.typeArguments?.arguments ?? const <TypeAnnotation>[];
            if (targs.isNotEmpty) {
              dartType = targs.first.toSource();
              baseIsNullable = dartType.trim().endsWith('?');
              joinTargetType = _extractJoinTargetType(targs.first);
            }
          }
        } else if (n.methodName.name == 'withForeignKey') {
          joinForeignKey = _firstStringArg(n.argumentList);
          storageKey = storageKey ?? joinForeignKey;
        } else if (n.methodName.name == 'withCandidateKey') {
          joinCandidateKey = _firstStringArg(n.argumentList);
        }
      }
    }

    bool makeNullable = false;
    String? aliasAs;
    for (final n in chain.whereType<MethodInvocation>()) {
      switch (n.methodName.name) {
        case 'nullable':
          makeNullable = true;
          break;
        case 'aliasAs':
          aliasAs = _firstStringArg(n.argumentList) ?? aliasAs;
          break;
      }
    }

    return ModelFieldIR(
      origin: 'adhoc',
      baseName: null,
      storageKey: storageKey,
      dartType: dartType,
      baseIsNullable: baseIsNullable,
      makeNullable: makeNullable,
      aliasAs: aliasAs,
      isInheritedFromBase: false,
      isJoin: isJoin,
      joinForeignKey: joinForeignKey,
      joinCandidateKey: joinCandidateKey,
      joinTargetType: joinTargetType ?? (isJoin ? dartType : null),
    );
  }

  return null;
}

String? _extractJoinTargetType(TypeAnnotation type) {
  return extractJoinTargetTypeFromString(type.toSource());
}

String? extractJoinTargetTypeFromString(String? typeSource) {
  if (typeSource == null) return null;
  var candidate = typeSource.trim();
  if (candidate.isEmpty) return candidate;

  // Strip trailing nullability markers repeatedly (e.g., `Foo?` or `Foo?!`).
  while (candidate.endsWith('?') || candidate.endsWith('!')) {
    candidate = candidate.substring(0, candidate.length - 1).trim();
  }

  // Iteratively peel single-parameter generic wrappers such as
  // `List<T>`, `Future<List<T>>`, `IList<T>`, etc. We stop once a
  // wrapper exposes more than one top-level parameter (e.g., Map).
  while (true) {
    final generic = _decomposeFirstGeneric(candidate);
    if (generic == null) break;

    final params = generic.$2;
    if (params.length != 1) break;

    final inner = params.first.trim();
    if (inner.isEmpty || inner == candidate) break;

    candidate = inner;

    // Maintain the stripping of nullability/wrapper layers in
    // subsequent iterations in case of nested wrappers.
    while (candidate.endsWith('?') || candidate.endsWith('!')) {
      candidate = candidate.substring(0, candidate.length - 1).trim();
    }
  }

  return candidate;
}

/// Returns the base identifier and the list of top-level generic
/// arguments for the first generic segment in [type]. For example
/// `List<Foo>` yields `('List', ['Foo'])`, `Map<String, Foo>` yields
/// `('Map', ['String', 'Foo'])`, and non-generic strings return null.
///
/// Nested generics are kept intact inside the argument strings.
(String, List<String>)? _decomposeFirstGeneric(String type) {
  final firstLt = type.indexOf('<');
  if (firstLt == -1) return null;

  var depth = 0;
  int? endIndex;
  for (var i = firstLt; i < type.length; i++) {
    final char = type[i];
    if (char == '<') {
      depth++;
    } else if (char == '>') {
      depth--;
      if (depth == 0) {
        endIndex = i;
        break;
      }
    }
  }

  if (endIndex == null) return null;

  final base = type.substring(0, firstLt).trim();
  final inner = type.substring(firstLt + 1, endIndex).trim();
  if (base.isEmpty || inner.isEmpty) return null;

  final params = _splitTopLevelGenericParameters(inner);
  return (base, params);
}

List<String> _splitTopLevelGenericParameters(String source) {
  final result = <String>[];
  var buffer = StringBuffer();
  var depth = 0;
  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (char == '<') {
      depth++;
      buffer.write(char);
    } else if (char == '>') {
      depth--;
      buffer.write(char);
    } else if (char == ',' && depth == 0) {
      result.add(buffer.toString().trim());
      buffer = StringBuffer();
    } else {
      buffer.write(char);
    }
  }

  final trailing = buffer.toString().trim();
  if (trailing.isNotEmpty) {
    result.add(trailing);
  }

  return result;
}

List<Expression> _flattenChain(Expression expr) {
  // Returns nodes from root -> leaf in a call/property chain
  final parts = <Expression>[];
  void walk(Expression e) {
    if (e is MethodInvocation) {
      if (e.target != null) walk(e.target!);
      parts.add(e);
    } else if (e is PropertyAccess) {
      if (e.target != null) walk(e.target!);
      parts.add(e);
    } else if (e is PrefixedIdentifier) {
      walk(e.prefix);
      parts.add(e);
    } else {
      parts.add(e);
    }
  }

  walk(expr);
  return parts;
}

String? _firstStringArg(ArgumentList args) {
  for (final a in args.arguments) {
    if (a is SimpleStringLiteral) return a.value;
  }
  return null;
}

NamedExpression? _findNamedArg(ArgumentList args, String name) {
  for (final a in args.arguments) {
    if (a is NamedExpression && a.name.label.name == name) return a;
  }
  return null;
}

String _extractSimpleName(Expression e) {
  if (e is SimpleIdentifier) return e.name;
  if (e is PropertyAccess) return e.propertyName.name;
  if (e is PrefixedIdentifier) return e.identifier.name;
  return e.toSource();
}
