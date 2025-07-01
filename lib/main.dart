import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'img_source_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image to Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ImageToTextScreen(),
    );
  }
}

class ImageToTextScreen extends StatefulWidget {
  @override
  _ImageToTextScreenState createState() => _ImageToTextScreenState();
}

class _ImageToTextScreenState extends State<ImageToTextScreen> {
  File? _selectedImage;
  String _extractedText = '';
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _extractedText = '';
      });
      _extractTextFromImage();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _extractedText = '';
      });
      _extractTextFromImage();
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final InputImage inputImage = InputImage.fromFile(_selectedImage!);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _extractedText = 'Xatolik yuz berdi: $e';
        _isProcessing = false;
      });
    }
  }

  void _clearAll() {
    setState(() {
      _selectedImage = null;
      _extractedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Image to Text'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_selectedImage != null)
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _extractedText));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Text Copied')),
                );
              },
              icon: const Icon(
                Icons.copy,
                color: Colors.black,
                size: 24,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: Colors.black,
                        width: 1
                    )
                ),
                child: Builder(
                  builder: (context) {
                    if (_selectedImage == null) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          "Upload an image using the “+” button",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      );
                    }
                  }
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              Container(
                constraints: const BoxConstraints(
                  minHeight: 250,
                  maxHeight: 250
                ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: Colors.black,
                      width: 1
                  )
                ),
                child: Builder(
                  builder: (context) {
                    if (_isProcessing) {
                      return const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Matn tanilmoqda...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    if (_extractedText.isNotEmpty && !_isProcessing) {
                      return SelectableText(
                        _extractedText,
                        style: const TextStyle(fontSize: 16),
                      );
                    } else {
                      return const Text(
                        "Click the “Scan Image” button to perform scan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      );
                    }
                  }
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _clearAll();
                    },
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Colors.white),
                      elevation: const WidgetStatePropertyAll(0),
                      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8
                      )),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1
                        )
                      ))
                    ),
                    child: const Text(
                      "Clear image",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),

                  const SizedBox(width: 32,),

                  ElevatedButton(
                    onPressed: () {
                      _showImgDialog(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Color(0xffFFB347)),
                        elevation: const WidgetStatePropertyAll(4),
                        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8
                        )),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                        ))
                    ),
                    child: const Text(
                      "Scan image",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showImgDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: EdgeInsets.zero,
          content: ImgSourceDialog(
            onTapCamera: () {
              Navigator.of(context).pop();
              _pickImageFromCamera();
            },
            onTapGallery: () {
              Navigator.of(context).pop();
              _pickImageFromGallery();
            },
          ),
        );
      },
    );
  }
}