import 'package:flutter/material.dart';
import '../models/debt.dart';
import '../services/ai_service.dart';

class AiTipsScreen extends StatefulWidget {
  final List<Debt> debts;
  const AiTipsScreen({super.key, required this.debts});

  @override
  State<AiTipsScreen> createState() => _AiTipsScreenState();
}

class _AiTipsScreenState extends State<AiTipsScreen> {
  List<String> tips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    final fetchedTips = await AiService.fetchAiTips(widget.debts);
    setState(() {
      tips = fetchedTips;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        title: const Text('AI Suggestions'),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tips.length,
              itemBuilder: (context, index) {
                return TipTypingCard(tip: tips[index]);
              },
            ),
    );
  }
}

class TipTypingCard extends StatefulWidget {
  final String tip;
  const TipTypingCard({super.key, required this.tip});

  @override
  State<TipTypingCard> createState() => _TipTypingCardState();
}

class _TipTypingCardState extends State<TipTypingCard> {
  String displayedText = '';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    while (currentIndex < widget.tip.length) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return;
      setState(() {
        displayedText += widget.tip[currentIndex];
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F2235),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          displayedText,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
