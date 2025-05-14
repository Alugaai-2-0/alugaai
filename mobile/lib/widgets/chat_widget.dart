import 'package:flutter/material.dart';
import 'package:mobile/utils/Colors.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  bool _isChatOpen = false;
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
    });

    // Resposta do BOT
    Future.delayed(const Duration(milliseconds: 300), () {
      final botReply = _getBotResponse(text); // Respostas mockadas para teste
      // final botReply = await fetchChatGPTReply(text); (Use chat GPT API)

      setState(() {
        _messages.add(_ChatMessage(text: botReply, isUser: false));
      });

      // Scrollar pra baixo quando o BOT responder
      _scrollToBottom();
    });

    // Scrollar pra baixo quando uma mensagem for enviada
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getBotResponse(String userMessage) {
    final lower = userMessage.toLowerCase();

    if (lower.contains("oi") || lower.contains("olá") || lower.contains("eae") || lower.contains("salve")) {
      return "Oi! 👋 Como posso ajudar você hoje?";
    } else if (lower.contains("ajuda")) {
      return "Estou aqui para ajudar com suas dúvidas sobre moradia estudantil. Posso dar informações sobre vagas, preços, ou como encontrar um colega de quarto!";
    } else if (lower.contains("tchau") || lower.contains("flw") || lower.contains("adeus")) {
      return "Até logo! Tenha um ótimo dia! 😊";
    } else if (lower.contains("preço") || lower.contains("valor") || lower.contains("custo")) {
      return "Os preços variam dependendo da localização e tipo de acomodação. Posso ajudar você a encontrar opções dentro do seu orçamento!";
    } else if (lower.contains("quarto") || lower.contains("vaga") || lower.contains("disponível")) {
      return "Temos várias opções de quartos disponíveis. Você está procurando algo específico como localização ou valor?";
    } else {
      // Random fallback
      List<String> fallbackReplies = [
        "Não sei se entendi sua mensagem. Pode me perguntar sobre vagas, preços ou como funciona nossa plataforma?",
        "Pode tentar me explicar novamente? Estou aqui para ajudar com tudo relacionado à moradia estudantil.",
        "Interessante, conte-me mais sobre o que você precisa para sua moradia ideal...",
      ];
      fallbackReplies.shuffle();
      return fallbackReplies.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Botão do chat
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryOrangeColor,
            onPressed: () {
              setState(() {
                _isChatOpen = !_isChatOpen;
              });
            },
            child: Icon(
              _isChatOpen ? Icons.close : Icons.chat,
              color: Colors.white,
            ),
          ),
        ),

        // Janela do chat
        if (_isChatOpen)
          Positioned(
            bottom: 80,
            right: 20,
            child: _buildChatWindow(),
          ),
      ],
    );
  }

  Widget _buildChatWindow() {
    return Container(
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black26,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header com botão de fechar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.support_agent,
                    color: AppColors.primaryOrangeColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Assistente Alugaai",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                color: Colors.grey.shade600,
                onPressed: () {
                  setState(() {
                    _isChatOpen = false;
                  });
                },
              )
            ],
          ),
          Divider(height: 2, thickness: 1, color: Colors.grey.shade200),

          // Mensagem de boas-vindas se não houver mensagens
          if (_messages.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_work_outlined,
                      size: 48,
                      color: AppColors.primaryOrangeColor.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Olá! Como posso ajudar você\na encontrar sua moradia ideal?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Lista de mensagens
          if (_messages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 220,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? AppColors.primaryOrangeColor
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: Colors.black12,
                            offset: const Offset(0, 1),
                          )
                        ],
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Input de texto
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Escreva uma mensagem...",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 16, right: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, size: 20),
                  color: AppColors.primaryOrangeColor,
                  onPressed: _sendMessage,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minHeight: 36,
                    minWidth: 36,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Classe de mensagens internas
class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({required this.text, required this.isUser});
}