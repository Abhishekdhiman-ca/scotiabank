import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme(context) ? Colors.black : Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _isDarkTheme(context) ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: _isDarkTheme(context) ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          _buildNotificationBadge(context),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(context),
          _buildProfileContent(context),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications, color: _isDarkTheme(context) ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        Positioned(
          right: 11,
          top: 11,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(minWidth: 14, minHeight: 14),
            child: Text(
              '5',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
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
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100),
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage('assets/images/profile_picture.jpg'),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Abhishek Dhiman',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _isDarkTheme(context) ? Colors.white : Colors.black,
          ),
        ),
        Text(
          'abhishekdhiman4184@gmail.com',
          style: TextStyle(
            fontSize: 16,
            color: _isDarkTheme(context) ? Colors.white70 : Colors.black54,
          ),
        ),
        SizedBox(height: 10),
        _buildProfileActions(context),
        SizedBox(height: 30),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: _isDarkTheme(context) ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 20),
                _buildProfileOption(
                  context,
                  icon: Icons.account_circle,
                  title: 'Account Details',
                  subtitle: 'Manage your account information',
                  routeName: '/accountDetails',
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.credit_card,
                  title: 'Manage Cards',
                  subtitle: 'View and edit your saved cards',
                  routeName: '/manageCards',
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.lock,
                  title: 'Security',
                  subtitle: 'Change password and enable 2FA',
                  routeName: '/securitySettings',
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.settings_brightness,
                  title: 'Appearance',
                  subtitle: 'Customize app theme and layout',
                  routeName: '/appearanceSettings',
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Manage notification settings',
                  routeName: '/notificationSettings',
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.language,
                  title: 'Language Preferences',
                  subtitle: 'Change app language',
                  routeName: '/languageSettings',
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.support,
                  title: 'Support',
                  subtitle: 'Get help or report a problem',
                  routeName: '/support',
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                _buildLogoutButton(context),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.edit, color: Colors.white),
          label: Text('Edit Profile'),
          onPressed: () {
            Navigator.pushNamed(context, '/editProfile');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton.icon(
          icon: Icon(Icons.history, color: Colors.white),
          label: Text('View Transactions'),
          onPressed: () {
            Navigator.pushNamed(context, '/transactions');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required String routeName,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
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
    onPressed: () {                Navigator.of(context).pop(); // Close the dialog
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
