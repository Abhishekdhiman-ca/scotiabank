import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme(context) ? Colors.black : Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildBackground(context),
          _buildMoreContent(context),
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
              'More Options',
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

  Widget _buildMoreContent(BuildContext context) {
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
                _buildSectionTitle('User Management', context),
                _buildMoreOption(
                  context,
                  icon: Icons.person,
                  title: 'Profile and Settings',
                  subtitle: 'View and update your profile settings',
                  routeName: '/profile',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.security,
                  title: 'Sign-in and Security',
                  subtitle: 'Manage your sign-in methods and security',
                  routeName: '/securitySettings',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.group_add,
                  title: 'Invite Friends',
                  subtitle: 'Invite others to join the app',
                  routeName: '/inviteFriends',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.delete_forever,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  routeName: '/deleteAccount',
                ),
                _buildDivider(),

                _buildSectionTitle('App Customization', context),
                _buildMoreOption(
                  context,
                  icon: Icons.palette,
                  title: 'Theme Settings',
                  subtitle: 'Customize the app appearance',
                  routeName: '/themeSettings',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.brightness_6,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark mode',
                  routeName: '/darkModeToggle',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.visibility_off,
                  title: 'Privacy Mode',
                  subtitle: 'Hide sensitive information',
                  routeName: '/privacyMode',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.dashboard_customize,
                  title: 'Customize Dashboard',
                  subtitle: 'Personalize your dashboard layout',
                  routeName: '/customizeDashboard',
                ),
                _buildDivider(),

                _buildSectionTitle('Data Management', context),
                _buildMoreOption(
                  context,
                  icon: Icons.backup,
                  title: 'Backup Data',
                  subtitle: 'Back up your data for later restore',
                  routeName: '/backupData',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.restore,
                  title: 'Restore Data',
                  subtitle: 'Restore data from backup',
                  routeName: '/restoreData',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.storage,
                  title: 'Manage App Data',
                  subtitle: 'Clear cache and storage',
                  routeName: '/dataManagement',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.sync,
                  title: 'Sync Data',
                  subtitle: 'Synchronize your data across devices',
                  routeName: '/syncData',
                ),
                _buildDivider(),

                _buildSectionTitle('Integrations', context),
                _buildMoreOption(
                  context,
                  icon: Icons.link,
                  title: 'App Integrations',
                  subtitle: 'Connect to third-party services',
                  routeName: '/appIntegrations',
                ),
                _buildDivider(),

                _buildSectionTitle('Accessibility Settings', context),
                _buildMoreOption(
                  context,
                  icon: Icons.accessibility_new,
                  title: 'Accessibility Settings',
                  subtitle: 'Customize text size, color contrast',
                  routeName: '/accessibilitySettings',
                ),
                _buildDivider(),

                _buildSectionTitle('Support and Legal', context),
                _buildMoreOption(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Get help or report an issue',
                  routeName: '/helpCenter',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.phone,
                  title: 'Contact Us',
                  subtitle: 'Call or email customer support',
                  routeName: '/contactUs',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.privacy_tip,
                  title: 'Privacy and Legal',
                  subtitle: 'Review our policies',
                  routeName: '/privacy',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.update,
                  title: 'Check for Updates',
                  subtitle: 'Ensure you have the latest version',
                  routeName: '/checkUpdates',
                ),
                _buildMoreOption(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Feedback',
                  subtitle: 'Share your feedback or suggestions',
                  routeName: '/feedback',
                ),
                _buildDivider(),

                _buildLogoutButton(context),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Version 1.0.1 (2407.0.1)',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
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

  Widget _buildMoreOption(
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

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.red,
        ),
        icon: Icon(Icons.exit_to_app, color: Colors.white),
        label: Text(
          'Logout',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: () {
          _showLogoutDialog(context);
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
              child: Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, '/login'); // Navigate back to login
              },
            ),
          ],
        );
      },
    );
  }

  bool _isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
