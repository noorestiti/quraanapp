import 'package:flutter/material.dart';
import 'praytime.dart';
import 'nearby.dart';
import 'tasbeeh.dart';
import 'quraan.dart';
import 'azkar.dart';
import 'qibla.dart';


void main() {
  runApp(QuranApp());
}

class QuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF0C223E),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool prayerReminder = true;
  bool azkarReminder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('القرآن الكريم', style: TextStyle(fontSize: 24, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF0C223E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(

        backgroundColor: Colors.white,
        child: SettingsDrawer(
          prayerReminder: prayerReminder,
          azkarReminder: azkarReminder,
          onPrayerReminderChanged: (value) {
            setState(() {
              prayerReminder = value;
            });
          },
          onAzkarReminderChanged: (value) {
            setState(() {
              azkarReminder = value;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            buildGridItem(Icons.access_time, "أوقات الصلاة", Color(0xFF0C223E), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => praytime()),
              );


            }),
            buildGridItem(Icons.location_on, "مساجد قريبه", Color(0xFF0C223E), () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MosqueNear()),
              );


            }),
            buildGridItem(Icons.format_list_bulleted, "التسبيح", Color(0xFF0C223E), () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Tasbeeh()),
              );


            }),
            buildGridItem(Icons.book, "القرآن الكريم", Color(0xFF0C223E), () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Quran()),
              );


            }),
            buildGridItem(Icons.accessibility_new, "أذكار", Color(0xFF0C223E), () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AzkarScreen()),
              );


            }),
            buildGridItem(Icons.explore, "إتجاه القبله", Color(0xFF0C223E), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Qibla()),
              );

            }),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(1),
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


class SettingsDrawer extends StatelessWidget {
  final bool prayerReminder;
  final bool azkarReminder;
  final ValueChanged<bool> onPrayerReminderChanged;
  final ValueChanged<bool> onAzkarReminderChanged;

  SettingsDrawer({
    required this.prayerReminder,
    required this.azkarReminder,
    required this.onPrayerReminderChanged,
    required this.onAzkarReminderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
            backgroundColor: Color(0xFF0C223E),
            title: Text(
              'أخرى',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_right_alt, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },

              ),
            ])


        , body:   Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Color(0xFF0C223E),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildSettingsOption(
                    icon: Icons.save,
                    text: 'سجل المرجعية',
                    onTap: () {

                    },
                  ),
                  _buildSettingsOption(
                    icon: Icons.group,
                    text: 'شارك',
                    onTap: () {

                    },
                  ),
                  _buildSettingsOption(
                    icon: Icons.message,
                    text: 'اتصل بنا',
                    onTap: () {

                    },
                  ),
                  _buildSettingsOption(
                    icon: Icons.notifications,
                    text: 'منبه الصلاة',
                    hasSwitch: true,
                    switchValue: prayerReminder,
                    onSwitchChanged: onPrayerReminderChanged,
                  ),
                  _buildSettingsOption(
                    icon: Icons.star,
                    text: 'تقييم التطبيق',
                    onTap: () {

                    },
                  ),
                  _buildSettingsOption(
                    icon: Icons.apps,
                    text: 'تطبيقاتنا',
                    onTap: () {

                    },
                  ),
                  _buildSettingsOption(
                    icon: Icons.notifications_active,
                    text: 'منبه الأذكار',
                    hasSwitch: true,
                    switchValue: azkarReminder,
                    onSwitchChanged: onAzkarReminderChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }


  Widget _buildSettingsOption({
    required IconData icon,
    required String text,
    bool hasSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    GestureTapCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        trailing: hasSwitch
            ? Switch(
          activeTrackColor: Colors.white,
          value: switchValue,
          onChanged: onSwitchChanged,
          activeColor: Color(0xFF0C223E),
        )
            : null,
        onTap: onTap,
        tileColor: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}