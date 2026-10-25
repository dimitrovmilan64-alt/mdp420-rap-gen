import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SongItem {
  final String id;
  final String prompt;
  final String lyrics;
  final String? audioUrl;
  final DateTime created;

  SongItem({
    required this.id,
    required this.prompt,
    required this.lyrics,
    this.audioUrl,
    required this.created,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'prompt': prompt,
        'lyrics': lyrics,
        'audioUrl': audioUrl,
        'created': created.toIso8601String(),
      };

  factory SongItem.fromJson(Map<String, dynamic> json) => SongItem(
        id: json['id'],
        prompt: json['prompt'],
        lyrics: json['lyrics'],
        audioUrl: json['audioUrl'],
        created: DateTime.parse(json['created']),
      );
}

class HistoryService {
  static const _key = 'mdp_songs_v1';

  Future<List<SongItem>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => SongItem.fromJson(e)).toList()
      ..sort((a, b) => b.created.compareTo(a.created));
  }

  Future<void> save(SongItem item) async {
    final items = await load();
    items.removeWhere((e) => e.id == item.id);
    items.insert(0, item);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<void> delete(String id) async {
    final items = await load();
    items.removeWhere((e) => e.id == id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items.map((e) => e.toJson()).toList()));
  }
}
