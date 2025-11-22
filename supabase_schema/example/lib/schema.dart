import 'package:example/schema.supabase.dart';
import 'package:supabase_schema/supabase_schema.dart';

@Schema(tableName: 'users', baseModelName: 'User')
class UserSchema extends SupabaseSchema {
  final id = Field.intId().aliasAs('UserId');
  final name = Field<String>('name');
  final email = Field<String>('email');
  final createdAt = Field<DateTime>('created_at');
  final joinUserId = Field.join<User>().withForeignKey('join_user_id');

  @override
  List<Model> get models => [
    Model('CreateUserModel').fields([
      id,
      name,
      email,
      createdAt,
      Field<User>('user'),
      Field.join<User>().withForeignKey('join_user2_id'),
    ]),
  ];
}
