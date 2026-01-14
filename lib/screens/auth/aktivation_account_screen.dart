import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_activation_code.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivationAccountScreen extends StatefulWidget {
  const ActivationAccountScreen({super.key});

  @override
  State<ActivationAccountScreen> createState() =>
      _ActivationAccountScreenState();
}

class _ActivationAccountScreenState extends State<ActivationAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tokenController = TextEditingController();
  bool get isFormFilled => _tokenController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _tokenController.addListener(() => setState(() {}));
  }

  void _handleActivation() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = _tokenController.text.trim();

    bool ok = await authProvider.validateActivation(token);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Token Valid! Silakan lanjutkan pendaftaran."),
        ),
      );

      Navigator.pushNamed(context, '/sign-up', arguments: token);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode aktivasi tidak terdaftar atau sudah digunakan.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildHeader(
                icon: icBackLeft1,
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 20),
              _buildActionForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required String icon, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: onTap,
          child: Image(image: AssetImage(icon), width: 18),
        ),
        SizedBox(height: 30),
        Text('Aktivasi Akun', style: AppTextStyles.heading2),
        SizedBox(height: 20),
        Text(
          'Demi keamanan komunitas, silakan\nmasukkan kode aktivasi yang telah diberikan.',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildActionForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputActivationCode(controller: _tokenController),
          SizedBox(height: 35),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final disabled = !isFormFilled || auth.isLoading;
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
                      : Text('Lanjutkan', style: AppTextStyles.button1),
                );
              }
              return CustomButton1(
                onTap: _handleActivation,
                label: 'Lanjutkan',
              );
            },
          ),
          SizedBox(height: 35),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Belum memiliki kode? ',
                  style: AppTextStyles.bodyMedium,
                ),
                TextSpan(
                  text: 'Hubungi Tim VIDA',
                  style: AppTextStyles.bodyMediumBold,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final Uri url = Uri.parse(
                        'https://www.instagram.com/vidadigital.ung/',
                      );

                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tidak dapat membuka Instagram.'),
                          ),
                        );
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
