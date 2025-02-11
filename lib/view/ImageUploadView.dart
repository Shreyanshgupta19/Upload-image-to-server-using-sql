import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upload_image_to_server_using_sql/view-model/upload-image/upload_image.dart';

class ImageUploadView extends ConsumerStatefulWidget {
  const ImageUploadView({super.key});

  @override
  ConsumerState<ImageUploadView> createState() => _ImageUploadAppState();
}

class _ImageUploadAppState extends ConsumerState<ImageUploadView> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final uploader = ref.read(uploadProvider.notifier);

    switch (state) {
      case AppLifecycleState.paused:
        debugPrint('App in background - upload continuing');
        break;
      case AppLifecycleState.resumed:
        debugPrint('App resumed - checking upload status');
        uploader.resumeUpload();
        break;
      // case AppLifecycleState.inactive:
      //   debugPrint('App resumed - checking upload status');
      //   uploader.resumeUpload();
      //   break;
      // case AppLifecycleState.detached:
      //   debugPrint('App resumed - checking upload status');
      //   uploader.resumeUpload();
      //   break;
      default:
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadProvider);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Image Upload'),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (uploadState.status == UploadStatus.uploading) ...[
                CircularProgressIndicator(
                  value: uploadState.progress,
                ),
                SizedBox(height: 10),
                Text('Uploading... ${(uploadState.progress * 100).toStringAsFixed(1)}%'),
              ],

              SizedBox(height: 20),

              Text('Status: ${uploadState.status}'),

              if (uploadState.error != null) ...[
                SizedBox(height: 10),
                Text(
                  'Error: ${uploadState.error}',
                  style: TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(uploadProvider.notifier).retryUpload();
                  },
                  child: Text('Retry Upload'),
                ),
              ],

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  ref.read(uploadProvider.notifier).pickAndUploadImage();
                },
                child: Text('Pick and Upload Image'),
              ),

              if (uploadState.status == UploadStatus.uploading)
                ElevatedButton(
                  onPressed: () {
                    ref.read(uploadProvider.notifier).pauseUpload();
                  },
                  child: Text('Pause Upload'),
                ),
            ],
          ),
        ),
      );
   }
 }
