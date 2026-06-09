import 'package:supabase_flutter/supabase_flutter.dart';

class DBServices {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String position,
  }) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        // Updated to match the schema image:
        // Table: 'user' (lowercase)
        // Column: 'name' (instead of 'user_name')
        // Added: 'status'
        await supabase.from('user').insert({
          'id': user.id,
          'name': username,
          'user_email': email,
          'phone': phone,
          'position': position,
          'status': 'active',
        });
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await supabase.from('user').select();
    return List<Map<String, dynamic>>.from(response);
  }
}
