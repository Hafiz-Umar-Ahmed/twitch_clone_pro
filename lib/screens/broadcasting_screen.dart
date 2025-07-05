import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone_pro/config/AppID.dart';
import 'package:twitch_clone_pro/model/user.dart';
import 'package:twitch_clone_pro/provider/user_provider.dart';
import 'package:twitch_clone_pro/resources/supabase_methods.dart';
import 'package:twitch_clone_pro/screens/home_screen.dart';
import 'package:twitch_clone_pro/widgets/chat.dart';

class BroadcastingScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;

  const BroadcastingScreen({
    super.key,
    required this.isBroadcaster,
    required this.channelId,
  });

  @override
  State<BroadcastingScreen> createState() => _BroadcastingScreenState();
}

class _BroadcastingScreenState extends State<BroadcastingScreen> {
  late RtcEngine _engine;
  bool hasJoined = false;
  bool switchCamera = true;
  bool isMuted = false;
  final List<int> _remoteUid = [];

  @override
  initState() {
    super.initState();
    _initAgora();
  }

  void _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: agoraId));
    _addListners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );
    if (widget.isBroadcaster) {
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    }
    setState(() {
      hasJoined = false;
    });
    await _joinChannel();
    if (mounted) {
      setState(() {
        hasJoined = true;
      });
    }
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    _engine.joinChannelWithUserAccount(
      token: agoraTempId,
      channelId: 'test123',
      userAccount: Provider.of<UserProvider>(context, listen: false).user.uid,
    );
  }

  _addListners() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint('onJoinChannelSuccess $connection.channelId $elapsed');
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint('onUserJoined $connection.channelId $remoteUid $elapsed');
          if (mounted) {
            setState(() {
              _remoteUid.add(remoteUid);
            });
          }
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint('onUserOffline $connection.channelId $remoteUid $reason');
          if (mounted) {
            setState(() {
              _remoteUid.removeWhere((e) => e == remoteUid);
            });
          }
        },
        onLeaveChannel: (connection, stats) {
          debugPrint('onLeaveChannel $connection.channelId');
          if (mounted) {
            setState(() {
              _remoteUid.clear();
            });
          }
        },
      ),
    );
  }

  Future<void> _leaveChannel(User user) async {
    await _engine.leaveChannel();

    if ('${user.uid}${user.username}' == widget.channelId) {
      await SupabaseMethods().endLiveStream(widget.channelId, user.uid);
    } else {
      await SupabaseMethods().reduceViewCount(widget.channelId, false);
    }
    if (mounted) {
      Navigator.pushNamed(context, HomeScreen.routeName);
    }
  }

  Future<void> _switchCamera() async {
    await _engine
        .switchCamera()
        .then((value) {
          setState(() {
            switchCamera = !switchCamera;
          });
        })
        .catchError((err) {
          debugPrint('switching Camera error: $err');
        });
  }

  _onToggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    _engine.muteLocalAudioStream(isMuted);
  }

  @override
  void dispose() {
    () async {
      try {
        await _engine.leaveChannel();
        await _engine.stopPreview();
        await _engine.release();
      } catch (e) {
        debugPrint('Error releasing Agora engine: $e');
      }
    }();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _leaveChannel(user);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              hasJoined
                  ? _renderVideo(user)
                  : Center(child: CircularProgressIndicator()),
              if ('${user.uid}${user.username}' == widget.channelId)
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _switchCamera,
                        child: const Text('Switch Camera'),
                      ),
                      InkWell(
                        onTap: _onToggleMute,
                        child: Text((isMuted ? 'Mute Audio' : 'UnmuteAudio')),
                      ),
                      Expanded(child: ChatWidget(channelId: widget.channelId)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _renderVideo(User user) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ('${user.uid}${user.username}' == widget.channelId)
          ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: VideoCanvas(renderMode: RenderModeType.renderModeFit),
                useAndroidSurfaceView: true,
              ),
            )
          : (_remoteUid.isNotEmpty
                ? (kIsWeb
                      ? AgoraVideoView(
                          controller: VideoViewController.remote(
                            connection: RtcConnection(
                              channelId: widget.channelId,
                              localUid: user.uid.hashCode,
                            ),
                            rtcEngine: _engine,
                            canvas: VideoCanvas(
                              uid: _remoteUid[0],
                              renderMode: RenderModeType.renderModeFit,
                            ),
                            useFlutterTexture: false,
                          ),
                        )
                      : AgoraVideoView(
                          controller: VideoViewController.remote(
                            connection: RtcConnection(
                              channelId: widget.channelId,
                              localUid: user.uid.hashCode,
                            ),
                            rtcEngine: _engine,
                            canvas: VideoCanvas(
                              uid: _remoteUid[0],
                              renderMode: RenderModeType.renderModeFit,
                            ),
                            useFlutterTexture: true,
                          ),
                        ))
                : Container()),
    );
  }
}
