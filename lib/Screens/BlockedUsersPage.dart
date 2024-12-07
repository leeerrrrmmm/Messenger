import 'package:flutter/material.dart';
import 'package:message/Screens/auth/services/auth_services.dart';
import 'package:message/components/user_tile.dart';
import 'package:message/services/chat/chat_services.dart';

class BlockedUsersPage extends StatelessWidget {

  BlockedUsersPage({
    super.key,

  });

  final ChatService chatService = ChatService();
  final AuthServices authServices = AuthServices();



  @override
  Widget build(BuildContext context) {

    String userId = authServices.getCurUser()!.uid;

    void _showUnblockBox(BuildContext context, String userId) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unblock User'),
            content: const Text('Are you sure you want to unblock this user?'),
            actions: [
              TextButton(
                  onPressed:() {
                    Navigator.pop(context);
                  },
                  child:const Text('Cancel')
              ),
              TextButton(
                  onPressed:() {
                    chatService.unblockUser(userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                        const SnackBar(
                            content:
                             Text("User  unblocked!")
                        )
                    );
                  },
                  child:const Text('Unblock')
              )
            ],
          )
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar:AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title:const Text('Blocked Users'),
        centerTitle:true,
      ),
      body:StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatService.getBlockUsersStream(userId),
          builder: (context, snap) {
            if(snap.hasError){
              print(snap.error);
              return Center(child:Text('Error'));
            }

            if(snap.connectionState == ConnectionState.waiting){
              return Center(child:CircularProgressIndicator());
            }

            final blockedUsers = snap.data ?? [];

            if(blockedUsers.isEmpty){
              return Center(child: Text('Blocked Users yet :)'),);
            }

            return ListView.builder(
              itemCount: blockedUsers.length,
                itemBuilder:(context, index){
                  final user = blockedUsers[index];
                  return UserTile(
                      text: user['email'],
                      onTap: () => _showUnblockBox(context, user['uid']));
                }
            );
          }),

    );
  }
}