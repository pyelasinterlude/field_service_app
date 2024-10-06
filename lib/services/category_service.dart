import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_category.dart';

class CategoryService {
  final CollectionReference categoriesCollection =
  FirebaseFirestore.instance.collection('categories');

  final List<ServiceCategory> predefinedCategories = [
    ServiceCategory(id: '1', name: 'Plumbing'),
    ServiceCategory(id: '2', name: 'Electrical'),
    ServiceCategory(id: '3', name: 'IT Support'),
    ServiceCategory(id: '4', name: 'Cleaning Services'),
    ServiceCategory(id: '5', name: 'General Maintenance'),
  ];

  Future<void> initializePredefinedCategories() async {
    for (var category in predefinedCategories) {
      await addCategory(category);
    }
  }

  Future<List<ServiceCategory>> getCategories() async {
    QuerySnapshot snapshot = await categoriesCollection.get();
    return snapshot.docs
        .map((doc) =>
        ServiceCategory.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCategory(ServiceCategory category) async {
    //to check if category already exists to avoid duplicates
    var existingDocs = await categoriesCollection.where(
        'name', isEqualTo: category.name).get();
    if (existingDocs.docs.isEmpty) {
      await categoriesCollection.add(category.toMap());
    }
  }
}