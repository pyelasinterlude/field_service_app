import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_request.dart';

class FirestoreService {
  final CollectionReference serviceRequestsCollection =
  FirebaseFirestore.instance.collection('service_requests');

  Future<void> addServiceRequest(ServiceRequest request) async {
    await serviceRequestsCollection.add(request.toMap());
  }

  Future<List<ServiceRequest>> getServiceRequests() async {
    QuerySnapshot snapshot = await serviceRequestsCollection.get();
    return snapshot.docs
        .map((doc) => ServiceRequest.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<ServiceRequest>> streamServiceRequests() {
    return serviceRequestsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceRequest.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}