import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestStoragePermissionStatelessWidget extends StatelessWidget {
  const RequestStoragePermissionStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Grant storage the app permission'),
        Row(
          children: <Widget>[
            TextButton(
              child: const Text('Grant Permission'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Permission.manageExternalStorage.request();
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      ],
    );
  }
}
