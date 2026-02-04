import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/screens/profile/select_avatar.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_form_email.dart';
import 'package:mindfullshelter/utils/custom_input_form_gender.dart';
import 'package:mindfullshelter/utils/custom_input_form_username.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  final ImagePicker _picker = ImagePicker();

  String? selectedAvatarUrl;

  bool get isDataChanged {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;
    if (user == null) return false;

    final currentUsername = usernameController.text.trim();
    final currentEmail = emailController.text.trim();
    final currentGender = genderController.text.trim();

    bool hasTextChanged =
        currentUsername != user.username ||
        currentEmail != user.email ||
        currentGender != (user.gender ?? '');

    bool hasNewImageFile = auth.imageFile != null;

    bool hasNewAvatar =
        selectedAvatarUrl != null && selectedAvatarUrl != user.profilePhotoUrl;

    return (hasTextChanged || hasNewAvatar || hasNewImageFile) &&
        currentUsername.isNotEmpty &&
        currentEmail.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;

    usernameController = TextEditingController(text: user?.username ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    genderController = TextEditingController(text: user?.gender ?? '');

    usernameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    genderController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    genderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );

    if (pickedFile != null) {
      Provider.of<AuthProvider>(
        context,
        listen: false,
      ).setImage(File(pickedFile.path));
      setState(() {
        selectedAvatarUrl = null;
      });
    }
  }

  void _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final success = await auth.updateProfile(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      gender: genderController.text.trim(),
      avatarUrl: selectedAvatarUrl,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memperbarui profil')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 11),
              _buildHeader(
                context: context,
                icon: icBackLeft2,
                onTap: () => Navigator.pop(context),
                onPickImage: _pickImage,
              ),
              const SizedBox(height: 45),
              _buildFormEdit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String icon,
    required VoidCallback onTap,
    required VoidCallback onPickImage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: onTap,
                child: Image.asset(icon, width: 10),
              ),
              const SizedBox(width: 25),
              Text('Edit Profil', style: AppTextStyles.heading3Bold),
            ],
          ),
          const SizedBox(height: 35),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(44),
                  child: _getProfilePreview(auth),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () {
              showSelectAvatar(context, (url) {
                setState(() {
                  selectedAvatarUrl = url;
                  Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  ).setImage(null);
                });
              });
            },
            child: Text(
              'GANTI AVATAR',
              style: AppTextStyles.instructionsAddImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProfilePreview(AuthProvider auth) {
    if (selectedAvatarUrl != null) {
      return Image.asset(selectedAvatarUrl!, fit: BoxFit.cover);
    }

    if (auth.imageFile != null && auth.imageFile!.path.isNotEmpty) {
      return Image.file(auth.imageFile!, fit: BoxFit.cover);
    }

    final dbPhoto = auth.currentUser?.profilePhotoUrl;
    if (dbPhoto != null && dbPhoto.isNotEmpty) {
      if (dbPhoto.contains('assets/')) {
        return Image.asset(dbPhoto, fit: BoxFit.cover);
      }
      return Image.network(dbPhoto, fit: BoxFit.cover);
    }

    return Padding(
      padding: const EdgeInsets.all(23),
      child: Image.asset(icAnonymousProfile, fit: BoxFit.contain),
    );
  }

  Widget _buildFormEdit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Pengguna', style: AppTextStyles.headingProfile),
            const SizedBox(height: 8),
            CustomInputFormUsername(controller: usernameController),
            const SizedBox(height: 18),
            Text('Email', style: AppTextStyles.headingProfile),
            const SizedBox(height: 8),
            CustomInputFormEmail(controller: emailController),
            const SizedBox(height: 18),
            Text('Jenis Kelamin', style: AppTextStyles.headingProfile),
            const SizedBox(height: 8),
            CustomInputFormGender(controller: genderController),
            const SizedBox(height: 25),
            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                final disabled = !isDataChanged || auth.isLoading;
                if (disabled) {
                  return CustomButton4(
                    label: auth.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.background,
                            ),
                          )
                        : Text(
                            'Simpan Perubahan',
                            style: AppTextStyles.button1,
                          ),
                  );
                }
                return CustomButton1(
                  onTap: _handleUpdate,
                  label: 'Simpan Perubahan',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
