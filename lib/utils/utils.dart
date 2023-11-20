import 'dart:typed_data';

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource? source) async {
  if (source == null) {
    return null;
  }

  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    // return File(_file.path);
    return await file.readAsBytes();
  }

  return null;
}

Future<Uint8List?> selectImage(BuildContext context) async {
  ImageSource? source = ImageSource.gallery;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            icon: const Icon(Icons.cancel),
          ),
        ],
      ),
      iconColor: Colors.redAccent,
      iconPadding: EdgeInsets.zero,
      title: const Text(
        'Choose ImageSource',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(ImageSource.camera);
          },
          child: const Text('Camera'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(ImageSource.gallery);
          },
          child: const Text('Gallery'),
        ),
      ],
    ),
  ).then((value) => source = value);
  Uint8List? image = await pickImage(source);
  return image;
}
