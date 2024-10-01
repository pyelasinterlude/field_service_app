import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_category.dart';

class CategoryService {
  final CollectionReference categoriesCollection =
  FirebaseFirestore.instance.collection('categories');

  Future<List<ServiceCategory>> getCategories() async {
    QuerySnapshot snapshot = await categoriesCollection.get();
    return snapshot.docs
        .map((doc) => ServiceCategory.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCategory(ServiceCategory category) async {
    await categoriesCollection.add(category.toMap());
  }
}