import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upload_image_to_server_using_sql/data/network/network_api_service.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url, Map<String, dynamic> data);
  Future<dynamic> getPostApiResponse(String url , dynamic data);
}

// Define a provider for BaseApiServices
final baseApiServiceProvider = Provider<BaseApiServices>((ref) {
  return ref.read(networkApiServiceProvider);
});
