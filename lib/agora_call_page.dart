import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'medha_ui.dart';
import 'services/agora_token_service.dart';
import 'services/user_service.dart';

class AgoraCallPage extends StatefulWidget {
  final bool previewOnly;
  final String? bookedChannelName;
  final bool readOnlyChannel;

  const AgoraCallPage({
    super.key,
    this.previewOnly = false,
    this.bookedChannelName,
    this.readOnlyChannel = false,
  });

  @override
  State<AgoraCallPage> createState() => _AgoraCallPageState();
}

class _AgoraCallPageState extends State<AgoraCallPage> {
  static const String _defaultAppId = AgoraTokenService.appId;
  static const String _defaultToken = String.fromEnvironment('AGORA_TEMP_TOKEN');
  static const String _defaultChannel = 'medhamatrix-test-room';

  final TextEditingController _appIdController = TextEditingController(
    text: _defaultAppId,
  );
  final TextEditingController _tokenController = TextEditingController(
    text: _defaultToken,
  );
  late final TextEditingController _channelController;

  RtcEngine? _engine;
  int? _remoteUid;
  bool _isInitializing = false;
  bool _isJoined = false;
  bool _isMuted = false;
  bool _cameraEnabled = true;
  String _status = 'Enter your Agora App ID, token, and channel to start.';

  @override
  void dispose() {
    _leaveCall(disposeEngine: true);
    _appIdController.dispose();
    _tokenController.dispose();
    _channelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _channelController = TextEditingController(
      text: widget.bookedChannelName?.trim().isNotEmpty == true
          ? widget.bookedChannelName!.trim()
          : _defaultChannel,
    );
    UserService.loadAuthToken();
  }

  Future<void> _startCall() async {
    final appId = _appIdController.text.trim();
    final channel = _channelController.text.trim();
    var token = _tokenController.text.trim();
    var uid = 0;

    if (appId.isEmpty) {
      _showSnack('Agora App ID is required.', isError: true);
      return;
    }

    if (channel.isEmpty) {
      _showSnack('Channel name is required.', isError: true);
      return;
    }

    setState(() {
      _isInitializing = true;
      _status = 'Requesting permissions...';
    });

    try {
      final statuses = await [Permission.camera, Permission.microphone].request();
      if (statuses[Permission.camera] != PermissionStatus.granted ||
          statuses[Permission.microphone] != PermissionStatus.granted) {
        throw Exception('Camera and microphone permissions are required.');
      }

      await _leaveCall(disposeEngine: true);

      final engine = createAgoraRtcEngine();
      _engine = engine;
      await engine.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            if (!mounted) return;
            setState(() {
              _isJoined = true;
              _status = 'Joined channel ${connection.channelId}. Waiting for another user...';
            });
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            if (!mounted) return;
            setState(() {
              _remoteUid = remoteUid;
              _status = 'Remote user joined: $remoteUid';
            });
          },
          onUserOffline: (connection, remoteUid, reason) {
            if (!mounted) return;
            setState(() {
              if (_remoteUid == remoteUid) {
                _remoteUid = null;
              }
              _status = 'Remote user left the call.';
            });
          },
          onError: (err, msg) {
            if (!mounted) return;
            setState(() {
              _status = 'Agora error $err: $msg';
            });
          },
        ),
      );

      await engine.enableVideo();
      await engine.startPreview();

      if (!widget.previewOnly) {
        if (widget.bookedChannelName != null && widget.bookedChannelName!.trim().isNotEmpty) {
          setState(() {
            _status = 'Fetching Agora token for booked session...';
          });
          final tokenResult = await AgoraTokenService.fetchToken(
            channelName: channel,
          );
          token = tokenResult.token ?? '';
          uid = tokenResult.uid;
          _tokenController.text = token;
        }

        await engine.joinChannel(
          token: token,
          channelId: channel,
          uid: uid,
          options: const ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            channelProfile: ChannelProfileType.channelProfileCommunication,
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
            autoSubscribeAudio: true,
            autoSubscribeVideo: true,
          ),
        );
      } else {
        setState(() {
          _status = 'Preview started. You are not joined to a live channel.';
        });
      }

    } catch (e) {
      if (_engine != null) {
        try {
          await _engine!.release();
        } catch (_) {}
        _engine = null;
      }
      _showSnack('Failed to start Agora call: $e', isError: true);
      setState(() {
        _status = 'Failed to start call.';
      });
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<void> _leaveCall({bool disposeEngine = false}) async {
    final engine = _engine;
    if (engine == null) return;

    try {
      await engine.leaveChannel();
    } catch (_) {}

    try {
      await engine.stopPreview();
    } catch (_) {}

    if (disposeEngine) {
      await engine.release();
      _engine = null;
    }

    if (!mounted) return;
    setState(() {
      _isJoined = false;
      _remoteUid = null;
      _isMuted = false;
      _cameraEnabled = true;
      _status = 'Call ended.';
    });
  }

  Future<void> _toggleMute() async {
    final engine = _engine;
    if (engine == null) return;
    final nextValue = !_isMuted;
    await engine.muteLocalAudioStream(nextValue);
    if (!mounted) return;
    setState(() => _isMuted = nextValue);
  }

  Future<void> _toggleCamera() async {
    final engine = _engine;
    if (engine == null) return;
    final nextValue = !_cameraEnabled;
    await engine.enableLocalVideo(nextValue);
    if (!mounted) return;
    setState(() => _cameraEnabled = nextValue);
  }

  Future<void> _switchCamera() async {
    final engine = _engine;
    if (engine == null) return;
    await engine.switchCamera();
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? MedhaColors.danger : MedhaColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: MedhaTopBar(
        title: widget.previewOnly ? 'Video Preview' : 'Agora Test Call',
        subtitle: widget.previewOnly
            ? 'Check camera and microphone before joining'
            : 'Join a live Agora video session',
      ),
      child: MedhaPageView(
        children: [
          MedhaHeroCard(
            title: widget.previewOnly ? 'Preview Your Setup' : 'Agora Video Call',
            subtitle: widget.bookedChannelName == null
                ? _status
                : 'Booked channel ${widget.bookedChannelName}. $_status',
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: Column(
              children: [
                _buildReadOnlyField(
                  label: 'Agora App ID',
                  value: _appIdController.text,
                ),
                const SizedBox(height: 12),
                _buildInput(
                  label: 'Token',
                  controller: _tokenController,
                  hint: 'Paste a temporary token or leave blank if your project allows it',
                  readOnly: widget.bookedChannelName != null,
                ),
                const SizedBox(height: 12),
                _buildInput(
                  label: 'Channel Name',
                  controller: _channelController,
                  hint: 'For example: medhamatrix-session',
                  readOnly: widget.readOnlyChannel,
                ),
                const SizedBox(height: 16),
                if (!_isJoined && !widget.previewOnly)
                  MedhaPrimaryButton(
                    label: _isInitializing ? 'Starting...' : 'Join Call',
                    icon: Icons.video_call_rounded,
                    onPressed: _isInitializing ? null : _startCall,
                  )
                else if (widget.previewOnly && _engine == null)
                  MedhaPrimaryButton(
                    label: _isInitializing ? 'Starting...' : 'Start Preview',
                    icon: Icons.videocam_outlined,
                    onPressed: _isInitializing ? null : _startCall,
                  )
                else
                  MedhaOutlineButton(
                    label: 'Leave',
                    icon: Icons.call_end_rounded,
                    onPressed: () => _leaveCall(disposeEngine: true),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildVideoStage(),
          if (_engine != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: 140,
                  child: MedhaPrimaryButton(
                    label: _isMuted ? 'Unmute' : 'Mute',
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    onPressed: _toggleMute,
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: MedhaOutlineButton(
                    label: _cameraEnabled ? 'Camera Off' : 'Camera On',
                    icon: _cameraEnabled
                        ? Icons.videocam_off_rounded
                        : Icons.videocam_rounded,
                    onPressed: _toggleCamera,
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: MedhaOutlineButton(
                    label: 'Switch Camera',
                    icon: Icons.cameraswitch_outlined,
                    onPressed: _switchCamera,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      minLines: label == 'Token' ? 2 : 1,
      maxLines: label == 'Token' ? 3 : 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: MedhaColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MedhaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: MedhaColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: MedhaColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoStage() {
    return MedhaCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Call Stage',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: MedhaColors.text,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardHeight = constraints.maxWidth < 700 ? 220.0 : 280.0;
              return Column(
                children: [
                  _videoTile(
                    title: widget.previewOnly ? 'Your Preview' : 'Your Video',
                    height: cardHeight,
                    child: _engine == null
                        ? _placeholderTile('Start the call to see your camera preview.')
                        : AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine!,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          ),
                  ),
                  if (!widget.previewOnly) ...[
                    const SizedBox(height: 12),
                    _videoTile(
                      title: 'Remote Video',
                      height: cardHeight,
                      child: (_engine == null || _remoteUid == null)
                          ? _placeholderTile('Waiting for another participant to join.')
                          : AgoraVideoView(
                              controller: VideoViewController.remote(
                                rtcEngine: _engine!,
                                canvas: VideoCanvas(uid: _remoteUid),
                                connection: RtcConnection(
                                  channelId: _channelController.text.trim(),
                                ),
                              ),
                            ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _videoTile({
    required String title,
    required double height,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: MedhaColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: MedhaColors.text,
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ],
    );
  }

  Widget _placeholderTile(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
