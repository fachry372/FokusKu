import 'package:supabase_flutter/supabase_flutter.dart';

class RewardService {
  static final supabase = Supabase.instance.client;

  static Future<bool> save({
    required int menitFokus,
    required int faseAyam,
    required String rewardImage,
    required int jumlahSesi, 
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      await supabase.from('koleksi').insert({
        'user_id': user.id,
        'menit_fokus': menitFokus,
        'fase_ayam': faseAyam,
        'reward_image': rewardImage,
        'jumlah_sesi': jumlahSesi,
      });

      return true;
    } catch (e) {
      print("Gagal menyimpan reward: $e");
      return false;
    }
  }

static Future<List<Map<String, dynamic>>> getKoleksi() async {
  final user = supabase.auth.currentUser;
  if (user == null) return [];

  final data = await supabase
      .from('koleksi')
      .select('id, reward_image, created_at, jumlah_sesi')
      .eq('user_id', user.id)
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(data);
}


}

