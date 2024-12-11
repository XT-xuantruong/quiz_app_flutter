import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Only import kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/models/category_model.dart' as CategoryModel;
import 'package:quiz_app/services/category_service.dart';

import '../themes/app_colors.dart';

class CreateEditCategoryScreen extends StatefulWidget {
  final CategoryModel.Category? category;
  final Function(CategoryModel.Category)? onCategoryAdded;

  const CreateEditCategoryScreen({
    Key? key,
    this.category,
    this.onCategoryAdded,
  }) : super(key: key);

  @override
  _CreateEditCategoryScreenState createState() =>
      _CreateEditCategoryScreenState();
}

class _CreateEditCategoryScreenState extends State<CreateEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final CategoryService _categoryService = CategoryService();
  final cloudinary =
  CloudinaryPublic('diia1p9ou', 'quiz_uploads', cache: false);

  late TextEditingController _titleController;
  File? _imageFile;
  String? _imageUrl;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.category?.title ?? '');
    _imageUrl = widget.category?.imgUrl;
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        CategoryModel.Category newCategory = CategoryModel.Category(
          id: widget.category?.id ?? CategoryModel.Category.generateId(),
          title: _titleController.text,
          imgUrl: _imageUrl ?? '',
        );

        if (widget.category == null) {
          await _categoryService.addCategory(newCategory);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Category Created Successfully'), backgroundColor: AppColors.correctAnswer),
          );
        } else {
          await _categoryService.updateCategory(newCategory);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Category Updated Successfully'), backgroundColor: AppColors.correctAnswer,),
          );
        }

        if (widget.onCategoryAdded != null) {
          widget.onCategoryAdded!(newCategory);
        }

        // Navigate back to the previous screen and reload the data
        Navigator.of(context).pop();
        if (widget.onCategoryAdded != null) {
          await widget.onCategoryAdded!(newCategory);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.wrongAnswer,
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
          widget.category == null ? 'Create New Category' : 'Edit Category',
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
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: Text(
                  'Choose Image',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
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
              if (_isUploading)
                Center(child: CircularProgressIndicator()),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  widget.category == null ? 'Create Category' : 'Update',
                  style: TextStyle(color: Colors.white),
                ),
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