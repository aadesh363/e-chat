import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage {
  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  Widget profileScreen({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StatefulBuilder(
      builder: (context, setState) {
        Future<void> pickFromGallery() async {
          final XFile? image =
          await picker.pickImage(source: ImageSource.gallery);

          if (image != null) {
            setState(() {
              selectedImage = File(image.path);
            });
          }
        }

        Future<void> pickFromCamera() async {
          final XFile? image =
          await picker.pickImage(source: ImageSource.camera);

          if (image != null) {
            setState(() {
              selectedImage = File(image.path);
            });
          }
        }

        return Center(
          child: Stack(
            children: [
              ClipOval(
                child: Container(
                  width: 150,
                  height: 150,
                  color: isDark ? Colors.grey : Colors.grey.shade300,
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : Image.asset("assets/images/user_icon_dark.png"),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Pick a profile picture"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                pickFromGallery();
                              },
                              child: Text("Gallery"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                pickFromCamera();
                              },
                              child: Text("Camera"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Image.asset(
                    "assets/images/picker_icon.png",
                    width: 45,
                    height: 45,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}