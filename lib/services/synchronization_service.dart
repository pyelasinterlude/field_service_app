import 'package:connectivity_plus/connectivity_plus.dart';
import 'database_helper.dart';
import 'api_service.dart';

class SyncService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final ApiService _apiService = ApiService();

  Future<void> syncData() async {
    var connectivity = Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      final unSyncedRequests = await _databaseHelper.getUnSyncedRequests();
      try {
        final syncedIds = await _apiService.syncServiceRequests(unSyncedRequests);
        for (var id in syncedIds) {
          await _databaseHelper.markAsSynced(id);
        }
            } catch (e) {
        print('Error syncing data: $e');
        // Handle the error (e.g., retry later, log it, notify the user)
      }
    }
  }
}