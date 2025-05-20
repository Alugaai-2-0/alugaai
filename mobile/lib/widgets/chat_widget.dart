import 'package:flutter/material.dart';
import 'dart:async'; // Add this import for TimeoutException
import 'package:mobile/services/chat_api.dart';
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
  bool _isLoading = false; // Track when waiting for the bot to respond
  bool _isOffline = false; // Track if the bot is offline

  // Retry logic
  int _retryCount = 0;
  static const int _maxRetries = 2;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
      _isLoading = true; // Start loading indicator
      _isOffline = false; // Reset offline state
      _retryCount = 0; // Reset retry count
    });

    // Scroll to bottom when user sends a message
    _scrollToBottom();

    // Create a timeout that will force update UI if the network operation takes too long
    Timer timeoutTimer = Timer(const Duration(seconds: 15), () {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
          _isOffline = true;
          _messages.add(_ChatMessage(
            text: "A conexão demorou muito tempo. O servidor pode estar offline ou inacessível.",
            isUser: false,
            isError: true,
          ));
        });
        _scrollToBottom();
      }
    });

    try {
      await _getResponseFromBot(text);
    } finally {
      // Cancel the timeout timer if it hasn't fired yet
      if (timeoutTimer.isActive) {
        timeoutTimer.cancel();
      }
    }
  }

  Future<void> _getResponseFromBot(String text) async {
    try {
      // Get response from your Python Flask server with timeout
      final botReply = await fetchChatbotReply(text).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );

      setState(() {
        _messages.add(_ChatMessage(text: botReply, isUser: false));
        _isLoading = false; // Stop loading indicator
        _isOffline = false; // Connection successful
      });

      // Scroll to bottom when the bot responds
      _scrollToBottom();
    } catch (e) {
      print('Error caught in chat widget: $e');

      if (_retryCount < _maxRetries) {
        // Try again but don't chain the futures (to avoid staying in loading state)
        setState(() {
          _retryCount++;
        });

        await Future.delayed(const Duration(seconds: 2));

        // If we're still in the retry process and not manually cancelled
        if (_isLoading && _retryCount <= _maxRetries) {
          return _getResponseFromBot(text);
        }
      }

      // After max retries or if process was cancelled, show error
      if (_isLoading) {
        setState(() {
          _isOffline = true;
          _isLoading = false;
          _messages.add(_ChatMessage(
            text: _getErrorMessage(e.toString()),
            isUser: false,
            isError: true,
          ));
        });
        _scrollToBottom();
      }
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('SocketException') || error.contains('Connection refused')) {
      return "Ops! Parece que nosso assistente está offline no momento. Por favor, tente novamente mais tarde.";
    } else if (error.contains('timeout') || error.contains('TimeoutException')) {
      return "A conexão expirou. Nossa rede pode estar lenta ou o servidor está offline.";
    } else if (error.contains('service_unavailable')) {
      return "O serviço do assistente está temporariamente indisponível. Por favor, tente novamente mais tarde.";
    } else {
      return "Desculpe, ocorreu um erro inesperado. Por favor, tente novamente em alguns instantes.";
    }
  }

  void _retryConnection() {
    if (_messages.isNotEmpty) {
      // Get the last user message to retry
      String? lastUserMessage;
      for (int i = _messages.length - 1; i >= 0; i--) {
        if (_messages[i].isUser) {
          lastUserMessage = _messages[i].text;
          break;
        }
      }

      if (lastUserMessage != null) {
        setState(() {
          // Remove the error message
          if (_messages.last.isError) {
            _messages.removeLast();
          }
          _isLoading = true;
          _isOffline = false;
          _retryCount = 0;
        });
        _getResponseFromBot(lastUserMessage);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Chat button
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

        // Chat window
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
          // Header with status and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _isOffline ? Icons.cloud_off : Icons.support_agent,
                    color: _isOffline ? Colors.red : AppColors.primaryOrangeColor,
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
                  if (_isOffline)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Offline",
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
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

          // Welcome message if no messages
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
                      "Olá! Como posso ajudar você?\nTente dizer um 'Oi'",
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

          // Message list
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
                            : message.isError
                            ? Colors.red.shade50
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: message.isError
                            ? Border.all(color: Colors.red.shade200)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: Colors.black12,
                            offset: const Offset(0, 1),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              color: message.isUser
                                  ? Colors.white
                                  : message.isError
                                  ? Colors.red.shade800
                                  : Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          if (message.isError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: _retryConnection,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red.shade300),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: 14,
                                        color: Colors.red.shade700,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Tentar novamente",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Show loading indicator while waiting for response
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryOrangeColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Digitando...",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

          // Text input
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
                    enabled: !_isLoading, // Disable input while loading
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, size: 20),
                  color: _isLoading ? Colors.grey : AppColors.primaryOrangeColor,
                  onPressed: _isLoading ? null : _sendMessage,
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

// Internal message class
class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;

  _ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
}