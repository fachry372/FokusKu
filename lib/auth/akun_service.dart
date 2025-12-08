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
}
