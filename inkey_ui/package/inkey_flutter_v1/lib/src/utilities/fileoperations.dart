import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String filePath) async {
  final path = await _localPath;
  return File("$path/$filePath");
}

Future<Map<String, dynamic>> readFile(String filePath) async {
  File file = await _localFile(filePath);

  if (!await file.exists()) {
    throw Exception("File not found");
  }

  String contents = await file.readAsString();
  Map<String, dynamic> jsonData = jsonDecode(contents);
  return jsonData;
}

Future<void> writeFile(String filePath, Map<dynamic, dynamic> jsonData) async {
  File file = await _localFile(filePath);
  String jsonString = jsonEncode(jsonData);

  if (!await file.exists()) {
    await file.create();
  }

  await file.writeAsString(jsonString);
}

Future<void> deleteFile(String filePath) async {
  File file = await _localFile(filePath);

  if (!await file.exists()) {
    throw Exception("File not found");
  }

  await file.delete();
}

Future<void> cleanFile(String filePath) async {
  File file = await _localFile(filePath);

  if (!await file.exists()) {
    throw Exception("File not found");
  }

  await file.writeAsString("");
}

Future<bool> checkStoragePermissions() async {
  PermissionStatus storagePermission = await Permission.storage.status;

  if (!storagePermission.isGranted) {
    PermissionStatus status = await Permission.manageExternalStorage.request();

    return status.isGranted;
  }

  return true;
}

Future<bool> checkStrogaePermission() async {
  PermissionStatus storagePermission =
      await Permission.manageExternalStorage.status;

  if (storagePermission.isDenied || storagePermission.isPermanentlyDenied) {
    return false;
  }

  return true;
}
