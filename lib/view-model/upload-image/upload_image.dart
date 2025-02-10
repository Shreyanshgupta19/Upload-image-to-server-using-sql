import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upload_image_to_server_using_sql/data/local/db_helper.dart';

enum UploadStatus {
  initial,
  uploading,
  completed,
  error,
}

class UploadState{

  final UploadStatus status;
  final double progress;
  final String? error;
  final int? uploadId;
  final String? imagePath;

  UploadState({
    required this.status,
    this.progress = 0.0,
    this.error,
    this.uploadId,
    this.imagePath
});

  UploadState copyWith({
    UploadStatus? status,
    double? progress,
    String? error,
    int? uploadId,
    String? imagePath,
}) {
    return UploadState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      uploadId: uploadId ?? this.uploadId,
      imagePath: imagePath ?? this.imagePath,
    );
  }

}


class ImageUploadNotifier extends StateNotifier<UploadState> {
  ImageUploadNotifier() : super(UploadState(status: UploadStatus.initial)){
    checkPendingUploads();
  }
  WebSocket? socket;
  Uint8List? imageBytes;
  bool isUploading = false;
  int? currentUploadId;

  Future<void> checkPendingUploads() async{
    final pendingUploads = await DBHelper.getInstance.getPendingUploads();
    if(pendingUploads.isNotEmpty) {
      for( var upload in pendingUploads) {
        File imageFile = File(upload[DBHelper.IMAGE_FILE]);
        if(await imageFile.exists()) {
          imageBytes = await imageFile.readAsBytes();
          currentUploadId = upload[DBHelper.SNO];
          state = state.copyWith(
            imagePath: upload[DBHelper.IMAGE_FILE],
            uploadId: upload[DBHelper.SNO],
          );
          startUpload();
          break;
        } else {
          await DBHelper.getInstance.deleteCompletedUpload(upload[DBHelper.SNO]);
        }
      }
    }
  }

  // Future<void> startUpload() async{
  //   if(imageBytes == null) return;
  //   try{
  //     state = state.copyWith(
  //       status: UploadStatus.uploading,
  //       uploadId: currentUploadId,
  //     );
  //     isUploading = true;
  //
  //     const int chunkSize = 1024;
  //     int uploaded = 0;
  //     socket = await WebSocket.connect('ws://echo.websocket.org');
  //     while (uploaded < imageBytes!.length && isUploading) {
  //       int end = (uploaded < imageBytes!.length && isUploading)
  //                 ? uploaded + chunkSize
  //                 : imageBytes!.length;
  //
  //       Uint8List chunk = imageBytes!.sublist(uploaded, end);
  //       socket!.add(chunk);
  //
  //       uploaded = uploaded + chunk.length;
  //       double progress = uploaded / imageBytes!.length;
  //
  //       state =  state.copyWith(
  //         status: UploadStatus.uploading,
  //         progress: progress,
  //       );
  //
  //       if(currentUploadId != null) {
  //         await DBHelper.getInstance.updateUploadProgress(
  //             currentUploadId!,
  //             progress
  //         );
  //       }
  //
  //       await Future.delayed(Duration(microseconds: 100));
  //     }
  //
  //     if(isUploading) {
  //       if(currentUploadId != null) {
  //         await DBHelper.getInstance.deleteCompletedUpload(currentUploadId!);
  //
  //         // Delete the temporary file
  //         if(state.imagePath != null) {
  //           try{
  //             await File(state.imagePath!).delete();
  //           } catch(e) {
  //             debugPrint('Error deleting temporary file: $e');
  //           }
  //         }
  //       }
  //
  //       state = UploadState(status: UploadStatus.completed);
  //       currentUploadId = null;
  //       imageBytes = null;
  //
  //       // Check for more pending uploads
  //       checkPendingUploads();
  //     }
  //   } catch (e){
  //     state = state.copyWith(
  //       status: UploadStatus.error,
  //       error: e.toString(),
  //     );
  //   }
  // }

  Future<void> startUpload() async {
    if (imageBytes == null) return;

    try {
      state = state.copyWith(
        status: UploadStatus.uploading,
        uploadId: currentUploadId,
      );
      isUploading = true;

      // Convert image bytes to file
      File tempFile = File(state.imagePath!);

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(tempFile.path, filename: basename(tempFile.path)),
      });

      Dio dio = Dio();
      Response response = await dio.post(
        "https://api.escuelajs.co/api/v1/files/upload",
        data: formData,
        onSendProgress: (sent, total) {

          double progress = sent / total;
          state = state.copyWith(status: UploadStatus.uploading, progress: progress);

          if (currentUploadId != null) {
            DBHelper.getInstance.updateUploadProgress(currentUploadId!, progress);
          }
        },
      );

        if (currentUploadId != null) {
          await DBHelper.getInstance.deleteCompletedUpload(currentUploadId!);
          if (state.imagePath != null) {
            try {
              await File(state.imagePath!).delete();
            } catch (e) {
              debugPrint('Error deleting temporary file: $e');
            }
          }
        }

        state = UploadState(status: UploadStatus.completed);
        currentUploadId = null;
        imageBytes = null;
        checkPendingUploads();

    } catch (e) {
      state = state.copyWith(
        status: UploadStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> pickAndUploadImage() async{
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, /* .camera .gallery */ );
    // final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(type: FileType.any, /* .image */ );
    if(pickedFile != null) {
      try{
        // Save to temporary file
        final  tempDir = await getTemporaryDirectory();
        final tempPath = join(tempDir.path,
        '${DateTime.now().microsecondsSinceEpoch}.jpg'
        );
        if (pickedFile != null) {
        // await File(pickedFile.files.single.path!).copy(tempPath);
          await File(pickedFile.path).copy(tempPath);
        } else {
          debugPrint("No file selected");
        }

        // Save to database
        currentUploadId = await DBHelper.getInstance.insertPendingUpload(tempPath);

        imageBytes = await File(tempPath).readAsBytes();
        state = state.copyWith(
          imagePath: tempPath,
          uploadId: currentUploadId
        );

        startUpload();
      } catch(e) {
        state = state.copyWith(
          status: UploadStatus.error,
          error: 'Error preparing upload: $e',
        );
      }
    }
  }

  void pauseUpload() {
    isUploading = false;
  }
  void resumeUpload() {
    if(!isUploading && state.status == UploadStatus.uploading) {
      isUploading = true;
      startUpload();
    }
  }

  void retryUpload() {
    if(state.status == UploadStatus.error) {
      startUpload();
    }
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }
}

final uploadProvider = StateNotifierProvider<ImageUploadNotifier, UploadState>(
  (ref) => ImageUploadNotifier(),
);