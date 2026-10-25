import 'dart:convert';
import 'package:http/http.dart' as http;

class ReplicateService {
  final String apiKey;
  static const version = "671ac645ce5e552cc63a54a2bbff63fcf798043055d2dac5fc9e36a837eedcfb";

  ReplicateService(this.apiKey);

  Future<String> generate(String prompt) async {
    final create = await http.post(
      Uri.parse("https://api.replicate.com/v1/predictions"),
      headers: {
        "Authorization": "Token $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "version": version,
        "input": {
          "prompt": prompt,
          "duration": 10,
          "model_version": "stereo-large",
        }
      }),
    );

    if (create.statusCode != 201) {
      throw Exception("Create failed: ${create.body}");
    }
    final id = jsonDecode(create.body)["id"];

    for (int i = 0; i < 90; i++) {
      await Future.delayed(const Duration(seconds: 2));
      final status = await http.get(
        Uri.parse("https://api.replicate.com/v1/predictions/$id"),
        headers: {"Authorization": "Token $apiKey"},
      );
      final data = jsonDecode(status.body);
      if (data["status"] == "succeeded") {
        return data["output"] as String;
      }
      if (data["status"] == "failed") {
        throw Exception(data["error"] ?? "Generation failed");
      }
    }
    throw Exception("Timeout waiting for generation");
  }
}
