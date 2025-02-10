import 'package:flutter/cupertino.dart';
import 'package:upload_image_to_server_using_sql/data/response/status.dart';

class ApiResponse<T> {

  Status? status ;
  T? data ;
  String? message ;

  ApiResponse(this.status , this.data, this.message);

  // ApiResponse.notStarted() : status = Status.notStarted ;
  ApiResponse.notStarted() {
    debugPrint('No data');
    status = Status.notStarted ;}

  // ApiResponse.loading() : status = Status.loading ;
  ApiResponse.loading() {
    debugPrint('Loading');
    status = Status.loading;}
  // ApiResponse.completed(this.data) : status = Status.completed ;
  ApiResponse.completed(this.data) {
    debugPrint('Completed');
    status = Status.completed;}
  // ApiResponse.error(this.message) : status = Status.error ;

  ApiResponse.error(this.message) {
    debugPrint('Error');
    status = Status.error;}


  @override
  String toString(){
    return "Status : $status \n Message : $message \n Data: $data" ;
  }

}

extension ApiResponseWhenExtension<T> on ApiResponse<T> {
  R when<R>({
    required R Function() notStarted,
    required R Function() loading,
    required R Function(T data) completed,
    required R Function(String error) error,
  }) {
    switch (status) {
      case Status.notStarted:
        return notStarted();
      case Status.loading:
        return loading();
      case Status.completed:
        return completed(data!);
      case Status.error:
        return error(message ?? 'Unknown error');
      default:
        throw UnimplementedError('Unhandled status: $status');
    }
  }
}
