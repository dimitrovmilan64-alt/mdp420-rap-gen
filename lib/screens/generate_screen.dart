import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../ui/theme.dart';
import '../services/replicate_service.dart';
import '../services/lyrics_service.dart';
import '../services/history_service.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final _prompt = TextEditingController(
    text: "dark underground bulgarian trap, heavy bass, 140 bpm, aggressive",
  );
  final _lyrics = TextEditingController();
  final _player = AudioPlayer();
  final _history = HistoryService();
  String? _audioUrl;
  bool _loading = false;
  String? _error;

  static const _apiKey = "ТУК_ТВОЯТ_REPLICATE_KEY";

  void _genLyrics() {
    final topic = _prompt.text.split(',').first.trim();
    setState(() {
      _lyrics.text = LyricsService.generate(topic: topic);
    });
  }

  Future<void> _generate() async {
    if (_apiKey.startsWith("ТУК_")) {
      setState(() => _error = "Сложи Replicate API ключ в кода");
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = await ReplicateService(_apiKey).generate(_prompt.text.trim());
      setState(() => _audioUrl = url);
      await _player.setUrl(url);

      final item = SongItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        prompt: _prompt.text.trim(),
        lyrics: _lyrics.text,
        audioUrl: url,
        created: DateTime.now(),
      );
      await _history.save(item);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _prompt.dispose();
    _lyrics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IronBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "MDP 420",
                style: TextStyle(
                  color: ironGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "RAP GEN",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _prompt,
                style: const TextStyle(color: Colors.white, height: 1.4),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Стил / промпт",
                  labelStyle: const TextStyle(color: ironGreen),
                  hintText: "underground trap, dark, 140 bpm...",
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: ironPanel.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: ironGreen.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: ironGreen, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _genLyrics,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ironGreen,
                        side: BorderSide(color: ironGreen.withOpacity(0.5)),
                      ),
                      child: const Text("ГЕНЕРИРАЙ ЛИРИКИ"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lyrics,
                style: const TextStyle(color: Colors.white, height: 1.35, fontSize: 13),
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: "Лирики",
                  labelStyle: const TextStyle(color: ironGreen),
                  filled: true,
                  fillColor: ironPanel.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: ironGreen.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: ironGreen, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _generate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ironGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "ГЕНЕРИРАЙ БИЙТ",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(color: Color(0xFFFF745C)),
                  textAlign: TextAlign.center,
                ),
              ],
              if (_audioUrl != null) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.play_arrow_rounded, color: ironGreen),
                      onPressed: () => _player.play(),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.pause_rounded, color: ironGreen),
                      onPressed: () => _player.pause(),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
