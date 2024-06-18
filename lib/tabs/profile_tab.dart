// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/services/json_utils.dart';
import 'dart:io';

class ProfileTab extends StatefulWidget {
  final String userId;

  const ProfileTab({super.key, required this.userId});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late Future<User?> _userFuture;
  final _formKey = GlobalKey<FormState>();
  bool _isEditMode = false;
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _userFuture = JsonUtils.getUserById(widget.userId);
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfilePicture(User user) async {
    if (_imageFile != null) {
      String imageUrl = await JsonUtils.uploadImageToFirebase(_imageFile!);
      user.photoUrl = imageUrl;
      await JsonUtils.updateUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final user = snapshot.data;

          return user == null
              ? const Center(child: Text('User not found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isEditMode ? _buildEditForm(user) : _buildProfileView(user),
                );
        },
      ),
    );
  }

  Widget _buildProfileView(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: user.photoUrl.isEmpty
                ? const AssetImage('assets/default_user_picture.png')
                : user.photoUrl.startsWith('http')
                    ? NetworkImage(user.photoUrl)
                    : FileImage(File(user.photoUrl)) as ImageProvider,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Select from Gallery'),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Take a Picture'),
              ),
            ],
          ),
        ),
        _buildProfileItem('First Name', user.firstName),
        _buildProfileItem('Last Name', user.lastName),
        _buildProfileItem('Email', user.email),
        _buildProfileItem('Phone Number', user.phoneNumber),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _toggleEditMode,
            child: const Text('Edit Profile'),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildEditForm(User user) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            initialValue: user.email,
            decoration: const InputDecoration(labelText: 'Email'),
            onSaved: (value) => user.email = value ?? user.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: user.phoneNumber,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            onSaved: (value) => user.phoneNumber = value ?? user.phoneNumber,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Current Password'),
            obscureText: true,
            onChanged: (value) => _currentPassword = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'New Password'),
            obscureText: true,
            onChanged: (value) => _newPassword = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirm New Password'),
            obscureText: true,
            onChanged: (value) => _confirmNewPassword = value,
            validator: (value) {
              if (value != _newPassword) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (_currentPassword.isNotEmpty && _newPassword == _confirmNewPassword) {
                  final hashedCurrentPassword = PasswordUtils.hashPassword(_currentPassword);
                  if (hashedCurrentPassword == user.password) {
                    user.password = PasswordUtils.hashPassword(_newPassword);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Current password is incorrect')),
                    );
                    return;
                  }
                }
                _saveProfilePicture(user).then((_) {
                  JsonUtils.updateUser(user).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );
                    _toggleEditMode();
                  });
                });
              }
            },
            child: const Text('Save Changes'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _toggleEditMode,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
