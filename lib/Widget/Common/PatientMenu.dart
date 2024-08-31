import 'package:flutter/material.dart';
import 'package:medi_connect/Sevices/Auth/UserSession.dart';

class PatientMenu extends StatelessWidget {
  final Function(String) onMenuItemSelected; // Callback when a menu item is selected

  const PatientMenu({required this.onMenuItemSelected, super.key});

  Future<Map<String, String?>> _getUserInfo() async {
    final userName = await UserSession.getUserName();
    final userEmail = await UserSession.getUserEmail();
    return {'userName': userName, 'userEmail': userEmail};
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, String?>>(
            future: _getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
                  accountName: Text('Loading...'), // Placeholder while loading
                  accountEmail: Text('Loading...'), // Placeholder while loading
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person), // Default user avatar
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                );
              } else if (snapshot.hasError) {
                return const UserAccountsDrawerHeader(
                  accountName: Text('Error'), // Display error
                  accountEmail: Text('Error'), // Display error
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.error), // Error icon
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                );
              } else {
                final userName = snapshot.data?['userName'] ?? 'No Name';
                final userEmail = snapshot.data?['userEmail'] ?? 'No Email';
                return UserAccountsDrawerHeader(
                  accountName: Text(userName), // User's name
                  accountEmail: Text(userEmail), // User's email
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person), // Default user avatar
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Overview'),
            onTap: () {
              onMenuItemSelected('Overview');
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Prescription'),
            onTap: () {
              onMenuItemSelected('Prescription');
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Response'),
            onTap: () {
              onMenuItemSelected('Response');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Orders'),
            onTap: () {
              onMenuItemSelected('Orders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chats'),
            onTap: () {
              onMenuItemSelected('Chats');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              onMenuItemSelected('Settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              onMenuItemSelected('Logout');
            },
          ),
        ],
      ),
    );
  }
}
