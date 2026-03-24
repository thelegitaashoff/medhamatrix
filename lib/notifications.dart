import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool notificationsEnabled = true;
  bool showPreviews = true;
  bool soundEnabled = true;
  bool vibrationEnabled = false;
  bool dailySummaryEnabled = false;
  bool promoEnabled = false;
  TimeOfDay? dndStart;
  TimeOfDay? dndEnd;

  Future<void> _pickDndTime() async {
    final start = await showTimePicker(
      context: context,
      initialTime: dndStart ?? const TimeOfDay(hour: 22, minute: 0),
    );
    if (!mounted || start == null) return;
    final end = await showTimePicker(
      context: context,
      initialTime: dndEnd ?? const TimeOfDay(hour: 7, minute: 0),
    );
    if (!mounted) return;
    setState(() {
      dndStart = start;
      dndEnd = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Notifications', subtitle: 'Control alerts and quiet hours'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Notification Center',
            subtitle: 'Customize how and when app alerts reach you.',
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: Column(
              children: [
                _toggle('Receive Notifications', notificationsEnabled, (v) => setState(() => notificationsEnabled = v)),
                _toggle('Show Previews', showPreviews, notificationsEnabled ? (v) => setState(() => showPreviews = v) : null),
                _toggle('Sound', soundEnabled, notificationsEnabled ? (v) => setState(() => soundEnabled = v) : null),
                _toggle('Vibration', vibrationEnabled, notificationsEnabled ? (v) => setState(() => vibrationEnabled = v) : null),
                _toggle('Daily Summary', dailySummaryEnabled, notificationsEnabled ? (v) => setState(() => dailySummaryEnabled = v) : null),
                _toggle('Promotional Alerts', promoEnabled, notificationsEnabled ? (v) => setState(() => promoEnabled = v) : null),
              ],
            ),
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Do Not Disturb', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MedhaColors.text)),
                const SizedBox(height: 6),
                Text(
                  dndStart != null && dndEnd != null
                      ? 'Muted from ${dndStart!.format(context)} to ${dndEnd!.format(context)}'
                      : 'Set times when notifications are muted',
                  style: const TextStyle(fontSize: 14, color: MedhaColors.muted),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: MedhaPrimaryButton(
                        label: 'Enable All',
                        icon: Icons.check_rounded,
                        onPressed: () => setState(() {
                          notificationsEnabled = true;
                          showPreviews = true;
                          soundEnabled = true;
                          vibrationEnabled = true;
                          dailySummaryEnabled = true;
                          promoEnabled = true;
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MedhaOutlineButton(
                        label: 'Reset',
                        icon: Icons.refresh_rounded,
                        onPressed: () => setState(() {
                          notificationsEnabled = true;
                          showPreviews = true;
                          soundEnabled = true;
                          vibrationEnabled = false;
                          dailySummaryEnabled = false;
                          promoEnabled = false;
                          dndStart = null;
                          dndEnd = null;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: notificationsEnabled ? _pickDndTime : null,
                  icon: const Icon(Icons.schedule_rounded, color: MedhaColors.primary),
                  label: const Text('Set quiet hours', style: TextStyle(color: MedhaColors.primary, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool>? onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 17, color: MedhaColors.text)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: MedhaColors.primary,
            inactiveThumbColor: const Color(0xFF7D8A88),
            inactiveTrackColor: const Color(0xFFD9E3E1),
          ),
        ],
      ),
    );
  }
}
