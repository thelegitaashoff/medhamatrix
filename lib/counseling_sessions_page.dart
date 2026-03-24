import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'agora_call_page.dart';
import 'medha_ui.dart';
import 'models/counseling_session.dart';
import 'services/counseling_session_service.dart';

class CounselingSessionsPage extends StatefulWidget {
  const CounselingSessionsPage({super.key});

  @override
  State<CounselingSessionsPage> createState() => _CounselingSessionsPageState();
}

class _CounselingSessionsPageState extends State<CounselingSessionsPage> {
  bool _isLoading = true;
  List<CounselingSession> _sessions = const [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await CounselingSessionService.loadSessions();
    if (!mounted) return;
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(
        title: 'My Sessions',
        subtitle: 'Join your booked counseling calls',
      ),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Booked Counseling Sessions',
            subtitle: 'Open a booked session and join its Agora channel automatically.',
          ),
          const SizedBox(height: 18),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: MedhaColors.primary),
              ),
            )
          else if (_sessions.isEmpty)
            const MedhaCard(
              child: Text(
                'No counseling sessions booked yet.',
                style: TextStyle(
                  fontSize: 15,
                  color: MedhaColors.muted,
                ),
              ),
            )
          else
            ..._sessions.map((session) {
              final sessionDate = DateTime.tryParse(session.dateIso);
              final formattedDate = sessionDate == null
                  ? session.dateIso
                  : DateFormat('dd MMM yyyy').format(sessionDate);

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: MedhaCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.counselor,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: MedhaColors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$formattedDate at ${session.timeSlot}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: MedhaColors.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Channel: ${session.agoraChannel}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: MedhaColors.muted,
                        ),
                      ),
                      const SizedBox(height: 14),
                      MedhaPrimaryButton(
                        label: 'Join Session',
                        icon: Icons.video_call_rounded,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AgoraCallPage(
                              bookedChannelName: session.agoraChannel,
                              readOnlyChannel: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
