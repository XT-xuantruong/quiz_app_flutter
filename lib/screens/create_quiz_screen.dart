import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

import 'dart:io';
import 'package:flutter/foundation.dart'; // For platform check

import '../models/quiz_model.dart';
import '../services/category_service.dart';
import '../services/quiz_service.dart';

class CreateQuizScreen extends StatefulWidget {
  final QuizModel? quiz;

  const CreateQuizScreen({Key? key, this.quiz}) : super(key: key);

  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final QuizService _quizService = QuizService();
  final ImagePicker _picker = ImagePicker();
  final cloudinary = CloudinaryPublic('diia1p9ou', 'quiz_uploads', cache: false);

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  File? _imageFile;
  String? _imageUrl;
  bool _isUploading = false;
  List _categories = [];

  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quiz?.title ?? '');
    _descriptionController = TextEditingController(text: widget.quiz?.description ?? '');

    // Handle category_id as DocumentReference.
    _categoryController = TextEditingController(text: widget.quiz?.category_id.id ?? '');
    _imageUrl = widget.quiz?.img_url;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      _categories = await CategoryService().getCategories();


      setState(() {});
    } catch (e) {
      // Xử lý lỗi khi lấy danh sách danh mục
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải danh mục: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary() async {
    if (_imageFile == null && _imageUrl != null) return _imageUrl;
    if (_imageFile == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      final response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            _imageFile!.path,
            folder: 'quiz_images',
            resourceType: CloudinaryResourceType.Image,
          )
      );

      setState(() {
        _isUploading = false;
        _imageUrl = response.secureUrl;
      });

      return response.secureUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi tải ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl = await _uploadImageToCloudinary();

        // Convert the category_id to DocumentReference
        DocumentReference categoryRef = FirebaseFirestore.instance
            .collection('category')
            .doc(_categoryController.text);  // Convert to DocumentReference

        QuizModel quiz = QuizModel(
          id: widget.quiz?.id,
          title: _titleController.text,
          description: _descriptionController.text,
          category_id: categoryRef,  // Pass DocumentReference here
          img_url: imageUrl ?? '',
        );

        if (widget.quiz == null) {
          await _quizService.addQuiz(quiz);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tạo quiz thành công')),
          );
        } else {
          await _quizService.updateQuiz(quiz);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật quiz thành công')),
          );
        }

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz == null ? 'Tạo Quiz Mới' : 'Chỉnh Sửa Quiz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Tiêu đề Quiz',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                value: _categories.isNotEmpty && _categoryController.text.isNotEmpty
                    ? _categories.firstWhere(
                      (category) => category.id == _categoryController.text,
                ).id // Ensure the value matches the category ID
                    : null,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,  // Set the value as category.id
                    child: Text(category.title),  // Display the category name
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn danh mục';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _categoryController.text = value!;  // Store category id as text for form submission
                  });
                },
              )
,
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image, color: Colors.white,),
                label: Text(style: TextStyle(color: Colors.white), 'Chọn Ảnh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              // Hiển thị ảnh đã chọn hoặc ảnh hiện tại
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: kIsWeb // Check if it's running on the web
                      ? Image.network(
                    _imageFile!.path, // Display the image using a URL
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    _imageFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else if (_imageUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.network(
                    _imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              // Nếu đang upload thì hiển thị loading
              if (_isUploading)
                Center(child: CircularProgressIndicator()),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(style: TextStyle(color: Colors.white),widget.quiz == null ? 'Tạo Quiz' : 'Cập Nhật'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
