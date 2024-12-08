import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/image_preview.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentAvatar;
  final String currentEmail;
  final String currentId;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentAvatar,
    required this.currentEmail,
    required this.currentId,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _avatarController;
  late TextEditingController _emailController;

  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();
  final cloudinary = CloudinaryPublic('diia1p9ou', 'quiz_uploads', cache: false);
  File? _imageFile;
  String? _imageUrl ;
  bool _isUploading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _avatarController = TextEditingController(text: widget.currentAvatar);
    _emailController = TextEditingController(text: widget.currentEmail);
    _imageUrl = widget.currentAvatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    _emailController.dispose();
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
            folder: 'avatar',
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

  Future<void> _updateProfile() async {
    try {
      // First upload the image if a new one was selected
      final String? uploadedImageUrl = await _uploadImageToCloudinary();
      if (_isUploading) return; // Don't proceed if still uploading

      // Create map of only the fields we want to update
      final Map<String, dynamic> updateData = {
        'email': _emailController.text,
        'full_name': _nameController.text,
        'profile_picture': uploadedImageUrl ?? widget.currentAvatar,
      };

      // Update user in database
      await _userService.updateUser(updateData,widget.currentId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('userAvatar', uploadedImageUrl ?? widget.currentAvatar);
      await prefs.setString('userEmail', _emailController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Chọn Ảnh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            // Hiển thị ảnh đã chọn hoặc ảnh hiện tại
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ImagePreview(
                  imageFile: _imageFile,
                ),
              )
            else if (_imageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ImagePreview(
                  imageUrl: _imageUrl,
                ),
              ),
            // Nếu đang upload thì hiển thị loading
            if (_isUploading)
              Center(child: CircularProgressIndicator()),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}