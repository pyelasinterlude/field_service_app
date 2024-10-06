import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/service_request.dart';
import '../services/database_helper.dart';
import '../services/synchronization_service.dart';
import 'user_management_screen.dart';

class ServiceRequestForm extends StatefulWidget {
  @override
  _ServiceRequestFormState createState() => _ServiceRequestFormState();
}

class _ServiceRequestFormState extends State<ServiceRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final SyncService _syncService = SyncService();

  String? _selectedCategory;
  File? _image;
  final picker = ImagePicker();

  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final request = ServiceRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        clientName: _clientNameController.text,
        description: _descriptionController.text,
        category: _selectedCategory ?? '',
        status: 'Pending',
        date: DateTime.now().toIso8601String(),
        location: 'Current Location', // TODO: Implement actual location
        imageUrl: _image?.path, // Store the local path of the image
        isSynced: 0,
      );

      await _databaseHelper.insertServiceRequest(request);
      await _syncService.syncData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service request submitted successfully')),
      );

      // Clear form
      _clientNameController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Service Request'),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserManagementScreen()),
              );
            },
          ),
        ],
      )
      ,body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _clientNameController,
              decoration: InputDecoration(labelText: 'Client Name'),
              validator: (value) => value!.isEmpty ? 'Please enter a client name' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: ['Category 1', 'Category 2', 'Category 3'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              decoration: InputDecoration(labelText: 'Category'),
              validator: (value) => value == null ? 'Please select a category' : null,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.camera),
                  child: Text('Take Photo'),
                ),
                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.gallery),
                  child: Text('Choose from Gallery'),
                ),
              ],
            ),
            if (_image != null) ...[
              SizedBox(height: 20),
              Image.file(_image!),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementScreen()),
                );
              },
              child: Text('User Management'),
            )
          ],
        ),
      ),
    );
  }
}