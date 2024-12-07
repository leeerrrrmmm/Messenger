import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message/Screens/auth/services/auth_services.dart';
import 'package:message/components/chat_bubble.dart';
import 'package:message/components/my_text_field.dart';
import 'package:message/services/chat/chat_services.dart';

class Chat extends StatefulWidget {
  final String receiveEmail;
  final String receiverId;

  Chat({
    super.key,
    required this.receiveEmail,
    required this.receiverId,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthServices _authServices = AuthServices();

  // TextField focus
  FocusNode myFocusNode = FocusNode();

  // Scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverId,
        _messageController.text,
      );

      _messageController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveEmail),
        foregroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: _buildUserInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authServices.getCurUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessage(widget.receiverId, senderId),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Text('Error'),
          );
        }

        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return Center(
            child: Text('No messages yet'),
          );
        }

        final messages = snap.data!.docs;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollDown();
        });

        return ListView(
          controller: _scrollController,
          children: messages.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurUser = data['senderId'] == _authServices.getCurUser()!.uid;

    var alignment = isCurUser ? Alignment.topRight : Alignment.topLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
        isCurUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          ChatBubble(
              message: data['message'],
              isCurrentUser: isCurUser,
              userId:data['senderId'],
              messageId:doc.id,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            focusNode: myFocusNode,
            labelText: 'Text some message...',
            controller: _messageController,
            keyboardType: TextInputType.text,
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
