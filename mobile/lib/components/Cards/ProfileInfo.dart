import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final VoidCallback onLogout;
  final Map<String, dynamic> userInfo;

  ProfileInfo({
    required this.onLogout,
    required this.userInfo,
  });

  String getInitials(String username) {
    final names = username.split(' ');
    if (names.length > 1) {
      return '${names.first[0]}${names.last[0]}';
    } else {
      return username.length >= 2 ? username.substring(0, 2) : username;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade100,
          ),
          child: Text(
            getInitials(userInfo['username'] ?? ''),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userInfo['username'] ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Spacer(),
        ElevatedButton(
          onPressed: onLogout,
          style: ElevatedButton.styleFrom(
            primary: Colors.red.shade500,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
