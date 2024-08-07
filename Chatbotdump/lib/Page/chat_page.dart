import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser =
  ChatUser(id: '1', firstName: 'Telkom', lastName: 'Indonesia');
  final ChatUser _gptChatUser =
  ChatUser(id: '2', firstName: 'Telkom', lastName: 'AI');
  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
        actions: [
          CustomToggle(onEditPressed: _clearMessages),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "Telkom AI",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.01),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Most Question'),
            ),
            Divider(), // Add divider here
            ListTile(
              title: Text('Bagaimana prosedur OKR untuk seorang manager atau...'),
              onTap: () {
                Navigator.pop(context);
                _sendSidebarMessage('Bagaimana prosedur OKR untuk seorang manager atau atasan yang tidak memiliki staf atau posisi dibawahnya kosong?');
              },
            ),
            Divider(), // Add divider here
            ListTile(
              title: Text('Cuti Bersalin'),
              onTap: () {
                Navigator.pop(context);
                _sendSidebarMessage('Cuti Bersalin');
              },
            ),
            Divider(), // Add divider here
            ListTile(
              title: Text('Informasi Umum KDMP'),
              onTap: () {
                Navigator.pop(context);
                _sendSidebarMessage('Informasi Umum KDMP');
              },
            ),
            Divider(), // Add divider here
            ListTile(
              title: Text('Bagaimana cara melakukan re-open OKR yang sudah closed ?'),
              onTap: () {
                Navigator.pop(context);
                _sendSidebarMessage('Bagaimana cara melakukan re-open OKR yang sudah closed ?');
              },
            ),
            Divider(), // Add divider here
            ListTile(
              title: Text('Kenapa saya tidak bisa update progress OKR ?'),
              onTap: () {
                Navigator.pop(context);
                _sendSidebarMessage('Kenapa saya tidak bisa update progress OKR ?');
              },
            ),
            Divider(), // Add divider here
            ListTile(
              title: Text('Untuk OKR yang telah terlanjur di delete apakah bisa dilakukan pengaktifan kembali ?'),
              onTap: () {
                Navigator.pop(context);
                _sendSidebarMessage('Untuk OKR yang telah terlanjur di delete apakah bisa dilakukan pengaktifan kembali ?');
              },
            ),
            Divider(), // Add divider here
            ListTile(
              title: Text('Bagaimana solusi untuk OKR yang sudah closed namun tercatat 0% ?'),
              onTap: () {
                Navigator.pop(context);
                _sendSidebarMessage('Bagaimana solusi untuk OKR yang sudah closed namun tercatat 0% ?');
              },
            ),
            Divider(), // Add divider here
            ListTile(
              title: Text('Implementasi Cuti Online'),
              onTap: () {
                Navigator.pop(context);
                _sendSidebarMessage('Implementasi Cuti Online');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Container(
                width: 100,
                height: 100,
                child: Transform.scale(
                  scale: 0.8,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: DashChat(
                  currentUser: _currentUser,
                  typingUsers: _typingUsers,
                  messageOptions: const MessageOptions(
                    currentUserContainerColor: Colors.black,
                    containerColor: Color.fromRGBO(152, 151, 151, 1.0),
                    textColor: Colors.white,
                  ),
                  onSend: (ChatMessage m) {
                    setState(() {
                      _messages.insert(0, m);
                    });
                    getChatResponse(m);
                  },
                  messages: _messages,
                  inputOptions: InputOptions(
                    inputDecoration: InputDecoration(
                      fillColor: Colors.black26,
                      filled: true,
                      hintText: 'Write a Message...',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0.5, horizontal: 10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendSidebarMessage(String text) {
    final message = ChatMessage(
      user: _currentUser,
      createdAt: DateTime.now(),
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
    getChatResponse(message);
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _typingUsers.add(_gptChatUser);
    });
    List<Messages?> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else if (m.user == _gptChatUser) {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();
  }

  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
  }
}

class CustomToggle extends StatelessWidget {
  final VoidCallback onEditPressed;

  CustomToggle({required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(500.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.circle, size: 10.0, color: Colors.white),
                ),
                SizedBox(width: 10.0),
                Text(
                  'GPT - 4o',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 128.0),
          GestureDetector(
            onTap: onEditPressed,
            child: Icon(Icons.edit, color: Colors.grey[800]),
          ),
          SizedBox(width: 5.0),
        ],
      ),
    );
  }
}
