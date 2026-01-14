import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false; // Controls the loading bar and typing indicator

  // YOUR API KEY
  static const String _apiKey = 'AIzaSyAr-Qhn3VU2R7HX-_sZIallWO7cEBnyPAA';

  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();

    // 1. Initialize Gemini with System Instructions for your restaurant
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // Updated to stable flash model
      apiKey: _apiKey,
      systemInstruction: Content.system(
        "You are a helpful assistant for Yatt's Kitchen at Hutan Melintang. "
        "You know the menu, prices, and recommendations. "
        "Keep responses short, friendly, and helpful for hungry students and staff.",
      ),
    );

    // 2. Start the chat session
    _chat = _model.startChat();

    // 3. Add initial greeting
    _messages.add({
      'text':
          "Hello! I'm your Yatt's Kitchen AI. Ask me anything about our menu at Hutan Melintang!",
      'isUser': false,
    });
  }

  // Logic: Send message and get response
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _isLoading = true; // Shows the lecture's "AI is typing" indicator
    });

    _scrollToBottom();

    try {
      final response = await _chat.sendMessage(Content.text(text));

      setState(() {
        _messages.add({
          'text': response.text ?? "I'm sorry, I couldn't process that.",
          'isUser': false,
        });
      });
    } catch (e) {
      debugPrint("Chat Error: $e");
      setState(() {
        _messages.add({
          'text': "Connection error. Please check your internet or API key.",
          'isUser': false,
        });
      });
    } finally {
      setState(() => _isLoading = false); // Hides the typing indicator
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // LECTURE COMPONENT: Typing indicator widget
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFF1C40F),
            child: Icon(Icons.smart_toy, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 10),
          const Text(
            "AI is thinking",
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 6),
          const AnimatedDots(), // From lecture code below
        ],
      ),
    );
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
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              // ADDED: List length increases if AI is typing
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // ADDED: Show typing animation as the last item
                if (_isLoading && index == _messages.length) {
                  return _buildTypingIndicator();
                }

                final msg = _messages[index];
                return _buildChatBubble(msg['text'], msg['isUser']);
              },
            ),
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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFE67E22) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isUser ? 15 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: "Ask about our specials...",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE67E22),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

// LECTURE CLASS: Animated three dots (...) for typing
class AnimatedDots extends StatefulWidget {
  const AnimatedDots({super.key});

  @override
  State<AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<int> dotAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    dotAnimation = IntTween(begin: 0, end: 3).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: dotAnimation,
      builder: (context, child) {
        String dots = "." * dotAnimation.value;
        return Text(
          dots,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
