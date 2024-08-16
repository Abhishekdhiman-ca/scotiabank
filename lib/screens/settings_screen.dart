import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme(context) ? Colors.black : Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildBackground(context),
          _buildSettingsContent(context),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkTheme(context) ? [Colors.black, Colors.grey[900]!] : [Colors.redAccent, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            color: _isDarkTheme(context) ? Colors.grey.withOpacity(0.3) : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
          ),
          child: Center(
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _isDarkTheme(context) ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 140),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: _isDarkTheme(context) ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 20),
                _buildSectionTitle('Personalization', context),
                _buildSettingsOption(
                  context,
                  icon: Icons.palette,
                  title: 'Theme Settings',
                  subtitle: 'Customize the app appearance',
                  routeName: '/themeSettings',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.language,
                  title: 'Language Preferences',
                  subtitle: 'Set your preferred language',
                  routeName: '/languageSettings',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.shortcut,
                  title: 'Quick Actions',
                  subtitle: 'Manage shortcuts and quick actions',
                  routeName: '/quickActions',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.dashboard_customize,
                  title: 'Home Screen Layout',
                  subtitle: 'Customize your home screen layout',
                  routeName: '/homeLayout',
                ),
                _buildDivider(),

                _buildSectionTitle('Security & Privacy', context),
                _buildSettingsOption(
                  context,
                  icon: Icons.security,
                  title: 'Security Settings',
                  subtitle: 'Manage passwords and security',
                  routeName: '/securitySettings',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.fingerprint,
                  title: 'Biometric Settings',
                  subtitle: 'Enable fingerprint or face recognition',
                  routeName: '/biometricSettings',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Privacy Settings',
                  subtitle: 'Control app permissions and data',
                  routeName: '/privacySettings',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.phonelink_lock,
                  title: 'App Lock',
                  subtitle: 'Set up a passcode to secure the app',
                  routeName: '/appLock',
                ),
                _buildDivider(),

                _buildSectionTitle('Notifications & Support', context),
                _buildSettingsOption(
                  context,
                  icon: Icons.notifications,
                  title: 'Notification Preferences',
                  subtitle: 'Manage app notifications',
                  routeName: '/notificationSettings',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help or report an issue',
                  routeName: '/helpSupport',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Learn more about the app',
                  routeName: '/about',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.update,
                  title: 'Check for Updates',
                  subtitle: 'Ensure you have the latest version',
                  routeName: '/checkUpdates',
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.sync,
                  title: 'Data Sync',
                  subtitle: 'Manage and sync your data',
                  routeName: '/dataSync',
                ),
                _buildDivider(),

                _buildFeedbackOption(context),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required String routeName,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: _isDarkTheme(context) ? Colors.grey[800] : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: Icon(icon, color: Colors.redAccent, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: _isDarkTheme(context) ? Colors.white : Colors.black)),
        subtitle: Text(subtitle, style: TextStyle(color: _isDarkTheme(context) ? Colors.white70 : Colors.black54)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 30,
    );
  }

  Widget _buildFeedbackOption(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.red,
        ),
        icon: Icon(Icons.feedback, color: Colors.white),
        label: Text(
          'Send Feedback',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/feedback');
        },
      ),
    );
  }

  bool _isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
