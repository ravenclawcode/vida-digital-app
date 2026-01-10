import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_form_email.dart';
import 'package:mindfullshelter/utils/custom_input_username.dart';
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
  final ImagePicker _picker = ImagePicker();

  bool get isFormFilled =>
      usernameController.text.trim().isNotEmpty ||
      emailController.text.trim().isNotEmpty;

  bool get isDataChanged {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;

    if (user == null) return false;

    final currentUsername = usernameController.text.trim();
    final currentEmail = emailController.text.trim();

    bool hasTextChanged =
        currentUsername != user.username || currentEmail != user.email;
    bool hasNewImage = auth.imageFile != null;

    return (hasTextChanged || hasNewImage) &&
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

    usernameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
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
      setState(() {});
    }
  }

  void _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.updateProfile(
      usernameController.text.trim(),
      emailController.text.trim(),
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
              SizedBox(height: 11),
              _buildHeader(
                context: context,
                icon: icBackLeft2,
                onTap: () => Navigator.pop(context),
                onPickImage: _pickImage,
              ),
              SizedBox(height: 45),
              _buildFormEdit(
                userCtrl: usernameController,
                emailCtrl: emailController,
                formKey: _formKey,
                isFilled: isDataChanged,
                onSave: _handleUpdate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHeader({
  required BuildContext context,
  required String icon,
  required VoidCallback onTap,
  required VoidCallback onPickImage,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
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
            SizedBox(width: 25),
            Text('Edit Profil', style: AppTextStyles.heading3Bold),
          ],
        ),
        SizedBox(height: 35),
        Consumer<AuthProvider>(
          builder: (context, auth, child) {
            return Stack(
              children: [
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: onPickImage,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(44),
                      child: auth.imageFile != null
                          ? Image.file(auth.imageFile!, fit: BoxFit.cover)
                          : (auth.currentUser?.profilePhotoUrl != null
                                ? Image.network(
                                    auth.currentUser!.profilePhotoUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(23),
                                    child: Image.asset(
                                      icAnonymousProfile,
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.textPink,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(7, 6, 5, 6),
                        child: Image.asset(icImagePicker),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 15),
        Text(
          'Ketuk untuk mengubah foto profil',
          style: AppTextStyles.instructionsAddImage,
        ),
      ],
    ),
  );
}

Widget _buildFormEdit({
  required GlobalKey<FormState> formKey,
  required TextEditingController userCtrl,
  required TextEditingController emailCtrl,
  required bool isFilled,
  required VoidCallback onSave,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama Pengguna', style: AppTextStyles.headingProfile),
          SizedBox(height: 8),
          CustomInputFormUsername(controller: userCtrl),
          SizedBox(height: 18),
          Text('Email', style: AppTextStyles.headingProfile),
          SizedBox(height: 8),
          CustomInputFormEmail(controller: emailCtrl),
          SizedBox(height: 25),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final disabled = !isFilled || auth.isLoading;
              if (disabled) {
                return CustomButton4(
                  label: auth.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : Text('Simpan Perubahan', style: AppTextStyles.button1),
                );
              }
              return CustomButton1(onTap: onSave, label: 'Simpan Perubahan');
            },
          ),
        ],
      ),
    ),
  );
}
