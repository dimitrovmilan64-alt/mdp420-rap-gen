import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../ui/theme.dart';
import '../services/replicate_service.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final _prompt = TextEditingController(
    text: "dark underground bulgarian trap, heavy bass, 140 bpm, aggressive",
  );
  final _player = AudioPlayer();
  String? _audioUrl;
  bool _loading = false;
  String? _error;

  // TODO: Move to flutter_secure_storage
  static const _apiKey = "ТУК_ТВОЯТ_REPLICATE_KEY";

  Future<void> _generate() async {
    if (_apiKey.startsWith("ТУК_")) {
      setState(() => _error = "Сложи Replicate API ключ в кода");
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _audioUrl = null;
    });
    try {
      final url = await ReplicateService(_apiKey).generate(_prompt.text.trim());
      setState(() => _audioUrl = url);
      await _player.setUrl(url);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IronBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
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
              const SizedBox(height: 32),
              TextField(
                controller: _prompt,
                style: const TextStyle(color: Colors.white, height: 1.4),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Опиши стила...",
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
                          "ГЕНЕРИРАЙ",
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
                const SizedBox(height: 28),
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
