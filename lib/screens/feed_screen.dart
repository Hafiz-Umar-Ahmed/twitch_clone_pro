import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitch_clone_pro/model/livestream.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitch_clone_pro/resources/supabase_methods.dart';
import 'package:twitch_clone_pro/screens/broadcasting_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final stream = Supabase.instance.client
        .from('livestreams')
        .stream(primaryKey: ['uid', 'channelId'])
        .order('startedAt', ascending: true);

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10,
        ).copyWith(top: 10),
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return snapshot.hasData
                ? InkWell(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        LiveStream post = LiveStream.fromMap(
                          snapshot.data![index],
                        );
                        return InkWell(
                          onTap: () {
                            SupabaseMethods().reduceViewCount(
                              post.channelId,
                              true,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BroadcastingScreen(
                                  isBroadcaster: false,
                                  channelId: post.channelId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.37,
                                  height: size.height * 0.1,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        post.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        post.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text('${post.viewers} watching'),
                                      Text(
                                        'Started ${timeago.format(post.startedAt)} ',
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(child: Text('No Livestreams available currently'));
          },
        ),
      ),
    );
  }
}
