import 'package:field_service_app/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/service_request_form.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Initialize predefined categories
  final categoryService = CategoryService();
  await  categoryService.initializePredefinedCategories();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Service App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: ServiceRequestForm(),
    );
  }
}