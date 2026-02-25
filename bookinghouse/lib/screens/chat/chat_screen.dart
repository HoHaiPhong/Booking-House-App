import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final int receiverId;
  final String receiverName;

  const ChatScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final SocketService _socketService = SocketService();
  final List<String> _messages = []; // For demo, storing strings. Better to use Message model.

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _socketService.connect(user.id);
      _socketService.onMessageReceived((data) {
        if (mounted) {
          setState(() {
            _messages.add("${data['senderId'] == user.id ? 'Me' : 'Them'}: ${data['content']}");
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _socketService.sendMessage(user.id, widget.receiverId, _controller.text);
      // Optimistic update or wait for server echo? Server echoes in our implementation.
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.receiverName}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_messages[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
