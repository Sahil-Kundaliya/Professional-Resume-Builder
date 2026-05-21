import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/resume_profile_model.dart';

class ProfileLocalDataSource {
  static const _profileFileName = 'resume_profile.json';
  static const _imageDirectoryName = 'profile_images';

  Future<ResumeProfileModel> loadProfile() async {
    final file = await _getProfileFile();
    if (!await file.exists()) {
      return const ResumeProfileModel(id: 'default-profile');
    }

    final jsonMap =
        jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return ResumeProfileModel.fromJson(jsonMap);
  }

  Future<ResumeProfileModel> saveProfile(ResumeProfileModel profile) async {
    final file = await _getProfileFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(profile.toJson()));
    return profile;
  }

  Future<String> persistSelectedImage(XFile image) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final imageDirectory =
        Directory(p.join(appDirectory.path, _imageDirectoryName));
    await imageDirectory.create(recursive: true);

    final extension = p.extension(image.path);
    final targetPath = p.join(
      imageDirectory.path,
      'profile_${DateTime.now().millisecondsSinceEpoch}$extension',
    );

    final copiedFile = await File(image.path).copy(targetPath);
    return copiedFile.path;
  }

  Future<File> _getProfileFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(p.join(directory.path, _profileFileName));
  }
}
