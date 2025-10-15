import 'package:dio/dio.dart';
import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';

class DocumentService {
  // Upload document
  static Future<Map<String, dynamic>> uploadDocument({
    required String nrkId,
    required String label,
    required String filePath,
  }) async {
    try {
      var dio = await DioHelper.getInstance();
      
      // Create form data
      FormData formData = FormData.fromMap({
        'nrk_id_no': nrkId,
        'label': label,
        'document': await MultipartFile.fromFile(filePath),
      });

      var response = await dio.post(
        '$FamilyBaseURL/documents/add/',
        data: formData,
      );

      print("=== UPLOAD DOCUMENT RESPONSE ===");
      print(response.data);
      return response.data;
    } catch (e) {
      print("❌ Error uploading document: $e");
      rethrow;
    }
  }

  // Fetch documents for a user
  static Future<Map<String, dynamic>> fetchDocuments(String nrkId) async {
    try {
      var dio = await DioHelper.getInstance();
      
      var response = await dio.get(
        '$FamilyBaseURL/documents/nrk/$nrkId/',
      );

      print("=== FETCH DOCUMENTS RESPONSE ===");
      print(response.data);
      return response.data;
    } catch (e) {
      print("❌ Error fetching documents: $e");
      rethrow;
    }
  }

  // Delete document
  static Future<Map<String, dynamic>> deleteDocument(int documentId) async {
    try {
      var dio = await DioHelper.getInstance();
      
      var response = await dio.delete(
        '$FamilyBaseURL/documents/delete/$documentId/',
      );

      print("=== DELETE DOCUMENT RESPONSE ===");
      print(response.data);
      return response.data;
    } catch (e) {
      print("❌ Error deleting document: $e");
      rethrow;
    }
  }
}

