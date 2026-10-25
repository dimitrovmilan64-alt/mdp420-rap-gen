import 'package:flutter/material.dart';
import '../ui/theme.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _history = HistoryService();
  List<SongItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _history.load();
    if (mounted) setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _delete(String id) async {
    await _history.delete(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return IronBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("История", style: TextStyle(color: ironGreen)),
          iconTheme: const IconThemeData(color: ironGreen),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: ironGreen))
            : _items.isEmpty
                ? const Center(
                    child: Text("Няма песни", style: TextStyle(color: Colors.white54)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final item = _items[i];
                      return Card(
                        color: ironPanel.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: ironGreen.withOpacity(0.3)),
                        ),
                        child: ListTile(
                          title: Text(
                            item.prompt.length > 40
                                ? "${item.prompt.substring(0, 40)}..."
                                : item.prompt,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            item.created.toString().substring(0, 16),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Color(0xFFFF745C)),
                            onPressed: () => _delete(item.id),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
