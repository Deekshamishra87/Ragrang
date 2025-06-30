import 'package:hive/hive.dart';
import '../song_model.dart';

class LikeStorage {
  static const _boxName = 'liked_songs';
  static late Box<SongModel> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<SongModel>(_boxName);
  }

  static bool isLiked(String id) {
    return _box.containsKey(id);
  }

  static void toggleLike(SongModel song) {
    if (isLiked(song.id)) {
      _box.delete(song.id);
    } else {
      _box.put(song.id, song);
    }
  }

  static List<SongModel> getAllLiked() {
    return _box.values.toList();
  }
}
