import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImgSourceDialog extends StatelessWidget {
  final VoidCallback onTapGallery;
  final VoidCallback onTapCamera;
  const ImgSourceDialog({super.key, required this.onTapGallery, required this.onTapCamera});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14
          ),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "New",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              ListTile(
                onTap: onTapCamera,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  CupertinoIcons.camera,
                  size: 36,
                  color: Colors.black,
                ),
                title: const Text(
                  "Take photo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              ListTile(
                onTap: onTapGallery,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  CupertinoIcons.photo,
                  size: 36,
                  color: Colors.black,
                ),
                title: const Text(
                  "Choose from Gallery",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
