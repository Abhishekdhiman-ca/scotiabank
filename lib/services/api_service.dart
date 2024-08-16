import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://json-storage-api.p.rapidapi.com/datalake";
  final String _apiKey = "737b5b8023msh5dc8759b04faf33p1be655jsn98f86fc2f298";
  final String _apiHost = "json-storage-api.p.rapidapi.com";

  ApiService() {
    _dio.options.headers = {
      'x-rapidapi-key': _apiKey,
      'x-rapidapi-host': _apiHost,
      'Content-Type': 'application/json',
    };
  }

  // Method to create a new transaction (e.g., register a new user)
  Future<Response?> createTransaction(Map<String, dynamic> data) async {
    final requestData = {
      "@context": [
        "http://schema4i.org/Thing.jsonld",
        "http://schema4i.org/Action.jsonld",
        "http://schema4i.org/CreateAction.jsonld"
      ],
      "@type": "CreateAction",
      "Result": data,
    };

    try {
      final response = await _dio.post(_baseUrl, data: requestData);
      return response;
    } catch (e) {
      print('Create Transaction Error: $e');
      return null;
    }
  }

  // Method to read transactions (e.g., for login or retrieving user data)
  Future<Response?> readTransaction(Map<String, dynamic> filter) async {
    final requestData = {
      "@context": [
        "http://schema4i.org/Thing.jsonld",
        "http://schema4i.org/Action.jsonld",
        "http://schema4i.org/SearchAction.jsonld"
      ],
      "@type": "SearchAction",
      "Object": filter,
    };

    try {
      final response = await _dio.post(_baseUrl, data: requestData);
      return response;
    } catch (e) {
      print('Read Transaction Error: $e');
      return null;
    }
  }

  // Method to update an existing transaction (e.g., updating user details)
  Future<Response?> updateTransaction(Map<String, dynamic> data) async {
    final requestData = {
      "@context": [
        "http://schema4i.org/Thing.jsonld",
        "http://schema4i.org/Action.jsonld",
        "http://schema4i.org/UpdateAction.jsonld"
      ],
      "@type": "UpdateAction",
      "Result": data,
    };

    try {
      final response = await _dio.post(_baseUrl, data: requestData);
      return response;
    } catch (e) {
      print('Update Transaction Error: $e');
      return null;
    }
  }

  // Method to delete a transaction (e.g., deleting a user)
  Future<Response?> deleteTransaction(Map<String, dynamic> filter) async {
    final requestData = {
      "@context": [
        "http://schema4i.org/Thing.jsonld",
        "http://schema4i.org/Action.jsonld",
        "http://schema4i.org/DeleteAction.jsonld"
      ],
      "@type": "DeleteAction",
      "Object": filter,
    };

    try {
      final response = await _dio.post(_baseUrl, data: requestData);
      return response;
    } catch (e) {
      print('Delete Transaction Error: $e');
      return null;
    }
  }

  // Method to get all users (or all transactions)
  Future<Response?> getAllUsers() async {
    try {
      final response = await _dio.get(_baseUrl);
      return response;
    } catch (e) {
      print('Get All Users Error: $e');
      return null;
    }
  }

  // New method to fetch account data (chequing and savings)
  Future<Map<String, dynamic>> fetchAccountData() async {
    try {
      final response = await _dio.get('https://nawazchowdhury.com/acc.php');
      return response.data;
    } catch (e) {
      print('Error fetching account data: $e');
      return {};
    }
  }

  // New method to fetch savings transactions
  Future<List<dynamic>> fetchSavingsTransactions() async {
    try {
      final response = await _dio.get('https://nawazchowdhury.com/sav.php');
      return response.data;
    } catch (e) {
      print('Error fetching savings transactions: $e');
      return [];
    }
  }

  // New method to fetch chequing transactions
  Future<List<dynamic>> fetchChequingTransactions() async {
    try {
      final response = await _dio.get('https://nawazchowdhury.com/chq.php');
      return response.data;
    } catch (e) {
      print('Error fetching chequing transactions: $e');
      return [];
    }
  }
}
