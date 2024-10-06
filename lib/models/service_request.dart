class ServiceRequest {
  final String id;
  final String clientName;
  final String description;
  final String category;
  final String status;
  final String date;
  final String location;
  final String? imageUrl;
  final int isSynced;

  ServiceRequest({
    required this.id,
    required this.clientName,
    required this.description,
    required this.category,
    required this.status,
    required this.date,
    required this.location,
    this.imageUrl,
    required  this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'description': description,
      'category': category,
      'status': status,
      'date': date,
      'location': location,
      'imageUrl': imageUrl,
      'isSynced': isSynced,
    };
  }

  factory ServiceRequest.fromMap(Map<String, dynamic> map) {
    return ServiceRequest(
      id: map['id'],
      clientName: map['clientName'],
      description: map['description'],
      category: map['category'],
      status: map['status'],
      date: map['date'],
      location: map['location'],
      imageUrl: map['imageUrl'],
      isSynced: map['isSynced'],
    );
  }
}