import 'package:example/schema.supabase.dart';
import 'package:supabase_schema/supabase_schema.dart';

@Schema(tableName: 'accounts', baseModelName: 'Account')
class AccountSchema extends SupabaseSchema {
  final id = Field.intId().aliasAs('UserId');
  final name = Field<String>('name');
  final createdAt = Field<DateTime>('created_at');
  final owner = Field<User>('user');
}
