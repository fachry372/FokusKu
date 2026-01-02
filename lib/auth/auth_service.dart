import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email,password: password,);
  }

   Future<AuthResponse> signUpWithEmailPassword(String name, String email, String password) async {

    final response = await _supabase.auth.signUp(email: email ,password: password);
    final user = response.user;

    if (user == null) {
      throw Exception("Gagal membuat akun");
    }

    await _supabase.from('users').insert({
      'id': user.id,
      'nama': name,
      'email': email,
    });

    return response;
    
  }


  Future<void> signOut() async {
    await _supabase.auth.signOut(); 
  }

  String? getcurrentuseremail(){
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  
 Future<bool> cekEmailTerdaftar(String email) async {
    final res = await _supabase.rpc(
      'cek_email_terdaftar',
      params: {'p_email': email},
    );

    return res == true;
  }

  Future<void> sendResetPasswordLink(String email) async {
  await _supabase.auth.resetPasswordForEmail(
    email,
    redirectTo: 'fokusku://reset', 
  );
}

 Future<void> updatePassword(String newPassword) async {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw Exception("Tidak ada session aktif, user belum login atau belum klik magic link");
    }

    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }
}



