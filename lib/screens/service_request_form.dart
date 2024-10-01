import 'package:flutter/material.dart';
import '../models/service_request.dart';
import '../services/category_service.dart';
import '../services/database_helper.dart';
import '../services/firestore_service.dart';
import '../services/image_service.dart';

class ServiceRequestForm extends StatefulWidget {
  @override
  _ServiceRequestFormState createState() => _ServiceRequestFormState();
}

class _ServiceRequestFormState extends State<ServiceRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final CategoryService _categoryService = CategoryService();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final ImageService _imageService = ImageService();

  String? _selectedCategory;
  List<String> _categories = [];
  String? _imageUrl;

  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryService.getCategories();
    setState(() {
      _categories = categories.map((c) => c.name).toList();
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final request = ServiceRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        clientName: _clientNameController.text,
        description: _descriptionController.text,
        category: _selectedCategory ?? '',
        status: 'Pending',
        date: DateTime.now().toIso8601String(),
        location: 'Current Location', // You should implement actual location fetching
        imageUrl: _imageUrl,
      );

      // Save locally
      await _databaseHelper.insertServiceRequest(request);

      // Save to Firestore
      await _firestoreService.addServiceRequest(request);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service request submitted successfully')),
      );

      // Clear form
      _clientNameController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        _imageUrl = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final image = await _imageService.pickImage();
    if (image != null) {
      final url = await _imageService.uploadImage(image, 'temp_id');
      setState(() {
        _imageUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Service Request')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _clientNameController,
              decoration: InputDecoration(labelText: 'Client Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter client name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              decoration: InputDecoration(labelText: 'Category'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Add Image'),
            ),
            if (_imageUrl != null) Image.network(_imageUrl!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
