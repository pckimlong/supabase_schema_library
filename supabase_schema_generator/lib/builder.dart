import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator.dart';

Builder supabaseSchemaBuilder(BuilderOptions options) => LibraryBuilder(
  SupabaseTableGenerator(),
  generatedExtension: '.supabase.dart',
);
