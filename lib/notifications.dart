import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
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

  Future<void> pickDndTime({required bool isStart}) async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: isStart ? (dndStart ?? TimeOfDay(hour: 22, minute: 0)) : (dndEnd ?? TimeOfDay(hour: 7, minute: 0)),
    );
    if (result != null) {
      setState(() {
        if (isStart) {
          dndStart = result;
        } else {
          dndEnd = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool isTablet = width > 700;
        bool isWide = width > 1100;

        double h(double val) => height * val / 817;
        double w(double val) => width * val / 400;

        return Scaffold(
          appBar: AppBar(
            title: Text('Notification Settings'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
          ),
          backgroundColor: const Color.fromARGB(255, 224, 248, 255),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w(16)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 1000 : double.infinity),
                child: Container(
                  margin: EdgeInsets.all(w(16)),
                  padding: EdgeInsets.all(w(20)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_active, size: w(50), color: Color.fromARGB(250, 57, 201, 245)),
                      SizedBox(height: h(16)),
                      Text('App Notifications', style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: h(8)),
                      Text('Control your notification preferences.'),
                      Divider(height: h(32)),
                      SwitchListTile(
                        activeColor: Color.fromARGB(250, 57, 201, 245),
                        title: Text('Receive Notifications'),
                        value: notificationsEnabled,
                        onChanged: (val) => setState(() => notificationsEnabled = val),
                      ),
                      SwitchListTile(
                        activeColor: Color.fromARGB(250, 57, 201, 245),
                        title: Text('Show Previews'),
                        value: showPreviews,
                        onChanged: notificationsEnabled ? (val) => setState(() => showPreviews = val) : null,
                      ),
                      Divider(),
                      SwitchListTile(
                        activeColor: Color.fromARGB(250, 57, 201, 245),
                        title: Text('Sound'),
                        value: soundEnabled,
                        onChanged: notificationsEnabled ? (val) => setState(() => soundEnabled = val) : null,
                      ),
                      SwitchListTile(
                        activeColor: Color.fromARGB(250, 57, 201, 245),
                        title: Text('Vibration'),
                        value: vibrationEnabled,
                        onChanged: notificationsEnabled ? (val) => setState(() => vibrationEnabled = val) : null,
                      ),
                      SwitchListTile(
                        activeColor: Color.fromARGB(250, 57, 201, 245),
                        title: Text('Daily Summary'),
                        value: dailySummaryEnabled,
                        onChanged: notificationsEnabled ? (val) => setState(() => dailySummaryEnabled = val) : null,
                      ),
                      SwitchListTile(
                        activeColor: Color.fromARGB(250, 57, 201, 245),
                        title: Text('Promotional Alerts'),
                        value: promoEnabled,
                        onChanged: notificationsEnabled ? (val) => setState(() => promoEnabled = val) : null,
                      ),
                      Divider(height: h(32)),
                      ListTile(
                        title: Text('Do Not Disturb'),
                        subtitle: dndStart != null && dndEnd != null
                            ? Text(
                                'From ${dndStart!.format(context)} to ${dndEnd!.format(context)}',
                              )
                            : Text('Set times when notifications are muted'),
                        trailing: Icon(Icons.schedule),
                        onTap: notificationsEnabled
                            ? () async {
                                await pickDndTime(isStart: true);
                                await pickDndTime(isStart: false);
                              }
                            : null,
                      ),
                      SizedBox(height: h(24)),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w(12))),
                        elevation: 2,
                        child: ListTile(
                          leading: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
                          title: Text('Sample Notification'),
                          subtitle: Text('This is how your notifications will appear.'),
                        ),
                      ),
                      SizedBox(height: h(8)),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.done),
                            label: Text('Enable All'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              backgroundColor: Color.fromARGB(250, 57, 201, 245),
                            ),
                            onPressed: () => setState(() {
                              notificationsEnabled = true;
                              showPreviews = true;
                              soundEnabled = true;
                              vibrationEnabled = true;
                              dailySummaryEnabled = true;
                              promoEnabled = true;
                            }),
                          ),
                          SizedBox(width: w(12)),
                          OutlinedButton.icon(
                            icon: Icon(Icons.reset_tv),
                            label: Text('Reset'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              backgroundColor: Color.fromARGB(249, 255, 255, 255),
                            ),                            
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
