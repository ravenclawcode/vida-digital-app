import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomInputFormOtp extends StatefulWidget {
  final TextEditingController controller;
  final bool hasError;
  final String? errorMessage;

  const CustomInputFormOtp({
    super.key,
    required this.controller,
    this.hasError = false,
    this.errorMessage,
  });

  @override
  State<CustomInputFormOtp> createState() => _CustomInputFormOtpState();
}

class _CustomInputFormOtpState extends State<CustomInputFormOtp> {
  final int otpLength = 5;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(otpLength, (index) {
      final c = TextEditingController();
      c.addListener(_updateOtp);
      return c;
    });

    focusNodes = List.generate(otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _updateOtp() {
    final otp = controllers.map((c) => c.text).join();
    widget.controller.text = otp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(otpLength, (index) {
            return SizedBox(
              width: 60,
              child: TextField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                maxLength: 1,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading4,
                cursorColor: AppColors.textPrimary,
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.backgroundForm,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      width: 2,
                      color: widget.hasError
                          ? AppColors.borderErrorColor
                          : AppColors.backgroundForm,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      width: 2,
                      color: widget.hasError
                          ? AppColors.borderErrorColor
                          : AppColors.backgroundForm,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < otpLength - 1) {
                    FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                  }
                  _updateOtp();
                },
              ),
            );
          }),
        ),
        if (widget.hasError && widget.errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              widget.errorMessage!,
              style: TextStyle(
                color: AppColors.borderErrorColor,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}
