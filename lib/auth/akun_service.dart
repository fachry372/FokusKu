import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AkunService {
  final supabase = Supabase.instance.client;

  /// Upload file ke supabase storage
  Future<String?> uploadProfileImage(File file, String userId) async {
    try {
      final fileName = "profile_$userId.jpg";

      // upload ke storage bucket "profile"
      await supabase.storage
          .from('profile')
          .upload(fileName, file, fileOptions: FileOptions(upsert: true));

      // ambil URL publik
      final imageUrl =
          supabase.storage.from('profile').getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  /// Update kolom image di tabel users
  Future<bool> updateUserImage(String userId, String imageUrl) async {
    try {
      await supabase
          .from('users')
          .update({'image': imageUrl})
          .eq('id', userId);

      return true;
    } catch (e) {
      print("Update error: $e");
      return false;
    }
  }

 

  /// Ambil nama & image dari tabel public.users
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select('nama, image')
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      print("profile error: $e");
      return null;
    }
  }

 
//   Future<String?> getUserEmail(String userId) async {
//   try {
//     return Supabase.instance.client.auth.currentUser?.email;
//   } catch (e) {
//     print("mengambil email error: $e");
//     return null;
//   }
// }


//   /// Ambil data lengkap (nama, image, email)
//   Future<Map<String, dynamic>?> getCompleteUserData(String userId) async {
//     try {
//       final profile = await getUserProfile(userId);
//       final email = await getUserEmail(userId);

//       if (profile == null) return null;

//       return {
//         'nama': profile['nama'],
//         'image': profile['image'],
//         'email': email,
//       };
//     } catch (e) {
//       print("gagal mendapatkan user error: $e");
//       return null;
//     }
//   }

/// Ambil email user dari tabel users
Future<String?> getUserEmail(String userId) async {
  try {
    final response = await Supabase.instance.client
        .from('users')
        .select('email')
        .eq('id', userId)
        .single(); // ambil 1 row

    // response berbentuk Map<String, dynamic>
    return response['email'] as String?;
  } catch (e) {
    print("mengambil email error: $e");
    return null;
  }
}

/// Ambil data lengkap (nama, image, email) dari tabel users
Future<Map<String, dynamic>?> getCompleteUserData(String userId) async {
  try {
    final profile = await Supabase.instance.client
        .from('users')
        .select('nama, image, email')
        .eq('id', userId)
        .single();


    return {
      'nama': profile['nama'],
      'image': profile['image'],
      'email': profile['email'],
    };
  } catch (e) {
    print("gagal mendapatkan user error: $e");
    return null;
  }
}


  Future<int> getTotalWaktuFokus(String userId) async {
  final result = await Supabase.instance.client
      .from('timer')
      .select('durasi_fokus')
      .eq('user_id', userId);

  int total = 0;

  for (var row in result) {
    total += (row['durasi_fokus'] ?? 0) as int;
  }

  return total; // dalam menit
}


Future<double> getRataRataPerHari(String userId) async {
  final result = await Supabase.instance.client.rpc(
    'get_avg_focus_per_day',
    params: {'uid': userId},
  );

  return (result as num?)?.toDouble() ?? 0.0;
}

Future<int> getTotalHewan(String userId) async {
  try {
    final result = await Supabase.instance.client.rpc(
      'get_total_hewan',
      params: {'uid': userId},
    );

    return (result as int?) ?? 0;
  } catch (e) {
    print("RPC total hewan error: $e");
    return 0;
  }
}

Future<bool> ubahNama(String userId, String newName) async {
  try {
    final result = await Supabase.instance.client
        .from('users')
        .update({'nama': newName})
        .eq('id', userId)
        .select();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

    if (result.isNotEmpty) {
      print("Nama berhasil diupdate: $result");
      return true;
    } else {
      print("User ID tidak ditemukan!");
      return false;
    }
  } catch (e) {
    print("ERROR UPDATE NAMA: $e");
    return false;
  }
}

 // Ubah password user via Supabase Auth
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return false;

      // 1. Re-authenticate user dengan password lama
      final reAuth = await supabase.auth.signInWithPassword(
        email: user.email!,
        password: oldPassword,
      );

      if (reAuth.user == null) {
        print("Password lama salah");
        return false;
      }

      // 2. Update password baru
      await supabase.auth.updateUser(
        AdminUserAttributes(password: newPassword),
      );

      return true;
    } catch (e) {
      print("Gagal update password: $e");
      return false;
    }
  }


}


