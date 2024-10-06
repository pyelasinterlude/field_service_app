import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final AuthService _authService = AuthService();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _deleteCurrentUser() async {
    if (currentUser != null) {
      try {
        await _authService.deleteUser(currentUser!.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User deleted successfully')),
        );
        // Navigate to login screen or exit the app
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Center(
        child: currentUser != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current User: ${currentUser!.email}'),
            ElevatedButton(
              onPressed: _deleteCurrentUser,
              child: Text('Delete Current User'),
            ),
          ],
        )
            : Text('No user signed in'),
      ),
    );
  }
}