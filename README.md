# MDP 420 Rap Generator

Flutter app for generating instrumental rap beats with Replicate MusicGen.

Styled after Iron Music 420 AI (dark theme, neon green #00FF66).

## Features
- Text prompt → 10s audio via meta/musicgen
- Play / pause
- Dark neon UI matching Iron Music

## Setup
1. `flutter create .` (if missing platform folders)
2. `flutter pub get`
3. Put your Replicate API key in `lib/screens/generate_screen.dart` (line with `ТУК_ТВОЯТ_REPLICATE_KEY`) or better use secure storage.
4. `flutter run` on Android device/emulator.

## Costs
Replicate free tier has limited credits. MusicGen is cheap after that.

## Next
- Secure key storage
- Lyrics generation
- History / projects
- Download audio
- More models
