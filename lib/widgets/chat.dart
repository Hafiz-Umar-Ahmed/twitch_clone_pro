import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitch_clone_pro/provider/user_provider.dart';
import 'package:twitch_clone_pro/resources/supabase_methods.dart';
import 'package:twitch_clone_pro/widgets/custom_textfield.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, required this.channelId});
  final String channelId;
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _chatController = TextEditingController();
  final stream = Supabase.instance.client
      .from('comments')
      .stream(primaryKey: ['id', 'channelId', 'name'])
      .order('createdAt', ascending: true);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              snapshot.data![index]['name'],
                              style: TextStyle(
                                color:
                                    provider.user.uid ==
                                        snapshot.data![index]['id']
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Text(snapshot.data![index]['content']),
                          );
                        },
                      )
                    : Container();
              },
            ),
          ),
          CustomTextField(
            customController: _chatController,
            onTap: (val) {
              SupabaseMethods().addComment(
                provider.user.uid,
                provider.user.username,
                widget.channelId,
                _chatController.text,
              );
              _chatController.clear();
            },
          ),
        ],
      ),
    );
  }
}
