import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  // REPLACE WITH YOUR ACTUAL API KEY
  static const String _apiKey = 'Your API Key Here';

  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    // Initialize Gemini Model
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
    // Start a chat session with instructions
    _chat = _model.startChat(
      history: [
        Content.text(
          "You are a helpful assistant for Yatt's Kitchen, a restaurant at Hutan Melintang. You help customers with the food menu, prices, and recommendations. Keep responses friendly and short.",
        ),
      ],
    );

    // Initial welcome message
    _messages.add({
      'text':
          "Hello! I'm your Yatt's Kitchen AI. Ask me anything about our menu!",
      'isUser': false,
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _isLoading = true;
    });

    try {
      // Send message to Gemini
      final response = await _chat.sendMessage(Content.text(text));

      setState(() {
        _messages.add({
          'text': response.text ?? "I'm sorry, I couldn't process that.",
          'isUser': false,
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'text': "Connection error. Please check your API key or internet.",
          'isUser': false,
        });
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      appBar: AppBar(
        title: const Text(
          "AI Kitchen Assistant",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF1C40F),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg['text'], msg['isUser']);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(color: Color(0xFFE67E22)),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFE67E22) : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              decoration: const InputDecoration(
                hintText: "Ask about our menu...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFFE67E22)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
