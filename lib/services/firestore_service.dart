import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_request.dart';

class FirestoreService {
  final CollectionReference serviceRequests = FirebaseFirestore.instance.collection('serviceRequests');

  Future<void> addServiceRequest(ServiceRequest request) async {
    await serviceRequests.doc(request.id).set(request.toMap());
  }

  Future<void> syncServiceRequests(List<ServiceRequest> requests) async {
    final batch = FirebaseFirestore.instance.batch();
    for (var request in requests) {
      batch.set(serviceRequests.doc(request.id), request.toMap());
    }
    await batch.commit();
  }
}
