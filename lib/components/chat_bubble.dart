import 'package:flutter/material.dart';
import 'package:message/services/chat/chat_services.dart';
import 'package:message/themes/themes_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;


    //report message
    void _reportMessage (BuildContext context, String messageId, String userId) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Report Message'),
            content: const Text('Are you sure you want to report this message?'),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child:Text('Cancel')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    ChatService().reportUser(messageId, userId);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message Reported')));
                  },
                  child:Text('Report')
              ),
            ],
          )
      );
    }


    //block user
    void _blockUser(BuildContext context, String userId) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Block User'),
            content: Text('You sure you want to block this user?'),
            actions: [
              TextButton(
                onPressed:(){
                  Navigator.pop(context);
                },
                child:Text('Cancel')
              ),
              TextButton(
                  onPressed:(){
                    ChatService().blockUser(userId);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text ('User Blocked')));
                    Navigator.pop(context);
                  },
                  child:Text('Block')
              )
            ],
          )
      );
    }


    //show options
    void _showOptions(BuildContext context, String messageId, String userId) {
      showModalBottomSheet(
          context: context,
          builder: (context){
          return SafeArea(
              child:
              Wrap(
                children: [
                  //rep message button
                    ListTile(
                      leading: const Icon(Icons.flag),
                      title:const Text('Report'),
                      onTap: () {
                        Navigator.pop(context);
                        _reportMessage(context, messageId, userId);

                      },
                    ),
                  //block user button
                  ListTile(
                    leading: const Icon(Icons.block_rounded),
                    title:const Text('Block'),
                    onTap: () {
                      Navigator.pop(context);
                      _blockUser(context, userId);
                    },
                  ),

                  //cancel button

                  ListTile(
                    leading: const Icon(Icons.cancel_sharp),
                    title:const Text('Canсel'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),


                ],
              ),
          );
      });
    }




    return GestureDetector(
      onLongPress: (){
        if(!isCurrentUser){
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          gradient: isCurrentUser
              ? LinearGradient(
            colors: isDarkMode
                ? [Colors.deepPurple.shade700, Colors.red]
                : [Colors.purple.shade700, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : LinearGradient(
            colors: isDarkMode
                ? [Colors.grey.shade700, Colors.grey.shade700]
                : [Colors.yellow.shade900, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: isCurrentUser
              ? BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          )
              : BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white, // Цвет текста для читаемости
          ),
        ),
      ),
    );
  }
}
