import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../services/chat_service.dart';
import '../../models/user_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  List<String> get _suggestions => [
    "¿Qué carreras se alinean a mi perfil?",
    "Háblame de Ingeniería de Sistemas",
    "¿Cuál es el campo laboral de Psicología?",
    "¿Cómo es la malla de Administración?",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  Future<void> _loadHistory() async {
    final appUser = Provider.of<AppUser?>(context, listen: false);
    if (appUser == null) return;

    try {
      final historySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(appUser.uid)
          .collection('history')
          .orderBy('timestamp', descending: false)
          .get();

      if (historySnapshot.docs.isEmpty) {
        final name = appUser.displayName.split(' ')[0];
        final welcomeName = name.isEmpty ? 'estudiante' : name;
        if (mounted) {
          setState(() {
            _messages = [
              ChatMessage(
                id: 'welcome',
                text: "¡Hola $welcomeName! 👋 Soy Cori, tu asistente en Horizonte UC. Estoy aquí para acompañarte en este gran paso. ¿En qué puedo orientarte hoy sobre tu futuro profesional? ✨🎓",
                isUser: false,
                timestamp: DateTime.now(),
              )
            ];
          });
        }
      } else {
        final List<ChatMessage> loadedMessages = [];
        for (var doc in historySnapshot.docs) {
          final data = doc.data();
          loadedMessages.add(ChatMessage(
            id: doc.id,
            text: data['text'] ?? '',
            isUser: data['isUser'] ?? false,
            timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
            rating: data['rating'] is int ? data['rating'] as int : null,
          ));
        }
        if (mounted) {
          setState(() {
            _messages = loadedMessages;
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      print("Error loading history: $e");
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

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cori - Asistente Continental', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Tu guía en Horizonte UC', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
          ],
        ),
        backgroundColor: const Color(0xFF6D23F9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          
          if (_isTyping) _buildTypingIndicator(),
          
          if (!_isTyping) _buildSuggestions(),
          
          _buildInputArea(appUser),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: SpinKitThreeBounce(
                color: Color(0xFF6D23F9),
                size: 20.0,
              ),
            ),
            const SizedBox(width: 8),
            const Text("Analizando tu perfil...", style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(_suggestions[index]),
              backgroundColor: Colors.white,
              labelStyle: const TextStyle(color: Color(0xFF6D23F9), fontSize: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              onPressed: () {
                 _controller.text = _suggestions[index];
                 _handleSend(Provider.of<AppUser?>(context, listen: false));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) 
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: ClipOval(
                child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_1pxqjqps.json',
                  height: 32,
                  width: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: msg.isUser ? const Radius.circular(20) : Radius.zero,
                bottomRight: msg.isUser ? Radius.zero : const Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: msg.isUser 
                      ? LinearGradient(colors: [const Color(0xFF6D23F9).withOpacity(0.85), const Color(0xFF4f46e5).withOpacity(0.85)])
                      : null,
                    color: msg.isUser ? null : Colors.white.withOpacity(0.8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser ? Colors.white : const Color(0xFF1E293B),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      if (!msg.isUser && msg.id != 'welcome') ...[
                        const Divider(height: 20, color: Colors.blueGrey),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('¿Fue útil?', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                            const SizedBox(width: 8),
                            _buildRatingIcon(msg, true),
                            const SizedBox(width: 4),
                            _buildRatingIcon(msg, false),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (msg.isUser) const SizedBox(width: 8),
          if (msg.isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE2E8F0),
              child: Icon(Icons.person, color: Color(0xFF64748B), size: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildInputArea(AppUser? user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Escribe tu duda aquí...",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: const Color(0xFF6D23F9),
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: () => _handleSend(user),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend(AppUser? user) async {
    if (_controller.text.isEmpty) return;
    
    final userText = _controller.text;
    _controller.clear();

    String userId = user?.uid ?? "anonymous";

    setState(() {
      _messages.add(ChatMessage(id: 'temp_user', text: userText, isUser: true, timestamp: DateTime.now()));
      _isTyping = true;
    });
    
    _scrollToBottom();

    final rawResponse = await _chatService.sendMessage(
      userText, 
      userId, 
      user?.riasecProfile ?? {},
      user?.displayName
    );

    // El formato esperado es "id|texto"
    String botId = 'temp_bot';
    String botText = rawResponse;
    if (rawResponse.contains('|')) {
      final parts = rawResponse.split('|');
      botId = parts[0];
      botText = parts.sublist(1).join('|');
    }

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(id: botId, text: botText, isUser: false, timestamp: DateTime.now()));
    });
    
    _scrollToBottom();
  }

  Widget _buildRatingIcon(ChatMessage msg, bool isHelpful) {
    // Definimos los colores basados en si ya está calificado
    final int targetRating = isHelpful ? 5 : 1;
    final bool isSelected = msg.rating == targetRating;
    
    return InkWell(
      onTap: () async {
        final appUser = Provider.of<AppUser?>(context, listen: false);
        if (appUser != null) {
          // Actualización local inmediata para feedback visual (Reactividad)
          setState(() {
            msg.rating = targetRating;
          });

          await _chatService.rateMessage(appUser.uid, msg.id, isHelpful);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Gracias por tu feedback! ✨'),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFF6D23F9),
              ),
            );
          }
        }
      },
      child: Icon(
        isHelpful ? Icons.thumb_up_alt_rounded : Icons.thumb_down_alt_rounded,
        size: 18,
        color: isSelected 
          ? (isHelpful ? Colors.green : Colors.red) 
          : Colors.grey.withOpacity(0.4),
      ),
    );
  }
}
