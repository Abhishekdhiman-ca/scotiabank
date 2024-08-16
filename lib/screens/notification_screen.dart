import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      "title": "Payment Received",
      "description": "Your payment of \$250.00 has been successfully received.",
      "date": "Today, 10:30 AM",
      "isRead": false,
      "category": "Finance",
      "snoozed": false,
      "important": true,
    },
    {
      "title": "Security Alert",
      "description":
      "A new device has been detected. If this wasn't you, please secure your account.",
      "date": "Yesterday, 7:45 PM",
      "isRead": false,
      "category": "Security",
      "snoozed": false,
      "important": true,
    },
    {
      "title": "Profile Update",
      "description": "Your profile information has been updated successfully.",
      "date": "2 days ago, 3:15 PM",
      "isRead": true,
      "category": "Account",
      "snoozed": false,
      "important": false,
    },
    {
      "title": "Weekly Summary",
      "description": "Your account summary for the week is now available.",
      "date": "3 days ago, 1:00 PM",
      "isRead": true,
      "category": "Summary",
      "snoozed": false,
      "important": false,
    },
    {
      "title": "Promotion",
      "description":
      "Exclusive offer: Get 10% cashback on your next purchase.",
      "date": "Last week, 5:30 PM",
      "isRead": true,
      "category": "Promotions",
      "snoozed": false,
      "important": false,
    },
  ];

  bool _isSelectionMode = false;
  Set<int> _selectedNotifications = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          _isSelectionMode
              ? "${_selectedNotifications.length} Selected"
              : 'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteSelectedNotifications,
            ),
            IconButton(
              icon: Icon(Icons.snooze, color: Colors.white),
              onPressed: _snoozeSelectedNotifications,
            ),
          ] else ...[
            IconButton(
              icon: Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: _deleteAllNotifications,
            ),
            IconButton(
              icon: Icon(Icons.mark_email_read, color: Colors.white),
              onPressed: _markAllAsRead,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(notification, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          _buildFilterChip('All'),
          _buildFilterChip('Unread'),
          _buildFilterChip('Finance'),
          _buildFilterChip('Security'),
          _buildFilterChip('Account'),
          _buildFilterChip('Summary'),
          _buildFilterChip('Promotions'),
          _buildFilterChip('Important'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      onSelected: (selected) {
        // Implement filter logic
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: _isSelectionMode
            ? Checkbox(
          value: _selectedNotifications.contains(index),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _selectedNotifications.add(index);
              } else {
                _selectedNotifications.remove(index);
              }
            });
          },
        )
            : Icon(
          notification['isRead']
              ? Icons.mark_email_read
              : Icons.mark_email_unread,
          color:
          notification['isRead'] ? Colors.grey : Colors.redAccent,
          size: 30,
        ),
        title: Row(
          children: [
            Text(
              notification['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: notification['isRead'] ? Colors.grey : Colors.black,
              ),
            ),
            if (notification['important'])
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.star, color: Colors.orange, size: 20),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(notification['description'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              notification['date'],
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            if (notification['snoozed'])
              Text(
                "Snoozed",
                style: TextStyle(color: Colors.orange, fontSize: 14),
              ),
          ],
        ),
        trailing: _isSelectionMode
            ? null
            : _buildTrailingIcons(notification, index),
        onTap: () {
          setState(() {
            notification['isRead'] = true;
            if (!_isSelectionMode) {
              _enterSelectionMode(index);
            }
          });
        },
        onLongPress: () {
          _enterSelectionMode(index);
        },
      ),
    );
  }

  Widget _buildTrailingIcons(Map<String, dynamic> notification, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            _deleteNotification(notification, index);
          },
        ),
        IconButton(
          icon: Icon(
            notification['isRead']
                ? Icons.mark_email_read
                : Icons.mark_email_unread,
            color: notification['isRead'] ? Colors.grey : Colors.redAccent,
          ),
          onPressed: () {
            setState(() {
              notification['isRead'] = !notification['isRead'];
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.snooze, color: Colors.orange),
          onPressed: () {
            setState(() {
              notification['snoozed'] = !notification['snoozed'];
            });
          },
        ),
        IconButton(
          icon: Icon(
            notification['important'] ? Icons.star : Icons.star_border,
            color: notification['important'] ? Colors.orange : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              notification['important'] = !notification['important'];
            });
          },
        ),
      ],
    );
  }

  void _enterSelectionMode(int index) {
    setState(() {
      _isSelectionMode = true;
      _selectedNotifications.add(index);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedNotifications.clear();
    });
  }

  void _deleteNotification(Map<String, dynamic> notification, int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void _deleteSelectedNotifications() {
    setState(() {
      notifications.removeWhere((notification) =>
          _selectedNotifications.contains(notifications.indexOf(notification)));
      _exitSelectionMode();
    });
  }

  void _deleteAllNotifications() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete All Notifications"),
          content: Text("Are you sure you want to delete all notifications?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notifications.clear();
                });
                Navigator.pop(context);
              },
              child: Text("Delete All"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  void _markAllAsRead() {
    setState(() {
      notifications.forEach((notification) {
        notification['isRead'] = true;
      });
    });
  }

  void _snoozeSelectedNotifications() {
    setState(() {
      _selectedNotifications.forEach((index) {
        notifications[index]['snoozed'] = true;
      });
      _exitSelectionMode();
    });
  }
}
