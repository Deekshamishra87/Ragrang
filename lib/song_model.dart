import 'package:hive/hive.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0)
class SongModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String artist;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  String previewUrl;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.previewUrl,
  });
}
