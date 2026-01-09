import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
) async {
  final response = await _supabase.auth
      .signInWithPassword(email: email, password: password);

  final user = response.user;

  if (user != null && user.emailConfirmedAt == null) {
    throw Exception("Email belum diverifikasi");
  }

  return response;
}

Future<void> signUpWithEmailPassword(
  String name,
  String email,
  String password,
) async {
  await _supabase.auth.signUp(
    email: email,
    password: password,
    emailRedirectTo: 'fokusku://auth-callback',
    data: {
      'nama': name, // simpan di metadata dulu
    },
  );
}

Future<void> ensureUserProfile() async {
  final user = _supabase.auth.currentUser;
  if (user == null) return;

  if (user.emailConfirmedAt == null) {
    throw Exception("Email belum diverifikasi");
  }

  final exists = await _supabase
      .from('users')
      .select('id')
      .eq('id', user.id)
      .maybeSingle();

  if (exists == null) {
    await _supabase.from('users').insert({
      'id': user.id,
      'nama': user.userMetadata?['nama'],
      'email': user.email,
    });
  }
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



