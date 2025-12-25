import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_schema_generator/src/ir.dart';

String _norm(String input) => input.replaceAll(RegExp(r'\s+'), '');

Expression _topLevelInitializer(CompilationUnit unit, String variableName) {
  for (final decl in unit.declarations.whereType<TopLevelVariableDeclaration>()) {
    for (final v in decl.variables.variables) {
      if (v.name.lexeme == variableName) {
        final init = v.initializer;
        if (init == null) {
          throw StateError('Variable $variableName has no initializer');
        }
        return init;
      }
    }
  }
  throw StateError('Variable $variableName not found');
}

void main() {
  test('parses nested generic schema Field<T> initializers', () {
    const source = r'''
T Field<T>(String key) => throw UnimplementedError();

final variants = Field<List<Map<String, dynamic>>>('variants');
final options = Field<Map<String, dynamic>>('options');
final activePromotions = Field<List<Map<String, dynamic>>>('active_promotions');
final attributes = Field<Map<String, dynamic>>('attributes');
final tags = Field<List<String>?>('tags');
''';

    final unit = parseString(content: source).unit;

    final variantsInit = _topLevelInitializer(unit, 'variants');
    final optionsInit = _topLevelInitializer(unit, 'options');
    final activePromotionsInit = _topLevelInitializer(unit, 'activePromotions');
    final attributesInit = _topLevelInitializer(unit, 'attributes');
    final tagsInit = _topLevelInitializer(unit, 'tags');

    final variants = parseSchemaFieldInitializerForTesting('variants', variantsInit);
    final options = parseSchemaFieldInitializerForTesting('options', optionsInit);
    final activePromotions = parseSchemaFieldInitializerForTesting(
      'activePromotions',
      activePromotionsInit,
    );
    final attributes = parseSchemaFieldInitializerForTesting(
      'attributes',
      attributesInit,
    );
    final tags = parseSchemaFieldInitializerForTesting('tags', tagsInit);

    expect(variants, isNotNull);
    expect(_norm(variants!.dartType!), 'List<Map<String,dynamic>>');
    expect(variants.storageKey, 'variants');

    expect(options, isNotNull);
    expect(_norm(options!.dartType!), 'Map<String,dynamic>');
    expect(options.storageKey, 'options');

    expect(activePromotions, isNotNull);
    expect(_norm(activePromotions!.dartType!), 'List<Map<String,dynamic>>');
    expect(activePromotions.storageKey, 'active_promotions');

    expect(attributes, isNotNull);
    expect(_norm(attributes!.dartType!), 'Map<String,dynamic>');
    expect(attributes.storageKey, 'attributes');

    expect(tags, isNotNull);
    expect(_norm(tags!.dartType!), 'List<String>?');
    expect(tags.isNullable, isTrue);
    expect(tags.storageKey, 'tags');
  });
}

