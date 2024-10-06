import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/service_request.dart';

class ApiService {
  final String baseUrl = 'https://your-api-endpoint.com/api';

  Future<List<String>> syncServiceRequests(List<ServiceRequest> requests) async {
    final url = Uri.parse('$baseUrl/sync');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requests.map((r) => r.toMap()).toList()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<String>.from(data['synced_ids']);
      } else {
        throw Exception('Failed to sync service requests: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in API call: $e');
      return []; // Return an empty list if there's an error
    }
  }
}