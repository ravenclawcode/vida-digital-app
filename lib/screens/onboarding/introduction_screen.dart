import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        int nextPage = _controller.page!.round() + 1;
        if (nextPage == 5) {
          nextPage = 0;
        }
        _controller.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildCarousel()),
            SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton1(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/multisign-in'),
                label: 'Buat Akun',
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton2(
                onTap: () => Navigator.pushNamed(context, '/sign-in'),
                label: 'Masuk',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 270,
          child: PageView(
            controller: _controller,
            children: [
              CarouselContent(
                image: illustration1,
                label: 'Jaga Kesehatan Mentalmu',
              ),
              CarouselContent(
                image: illustration2,
                label: 'Tenangkan Pikiran Lewat Suara',
              ),
              CarouselContent(
                image: illustration3,
                label: 'Bercerita Aman Tanpa Identitas',
              ),
              CarouselContent(
                image: illustration4,
                label: 'Teman Bicara Kapan Saja',
              ),
              CarouselContent(
                image: illustration5,
                label: 'Edukasi HIV/AIDS Lewat Video',
              ),
            ],
          ),
        ),
        SizedBox(height: 7.5),
        Image.asset(vector1, height: 5, width: 184),
        SizedBox(height: 20),
        SmoothPageIndicator(
          controller: _controller,
          count: 5,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.accent,
            expansionFactor: 3,
          ),
        ),
        SizedBox(height: 180),
      ],
    );
  }
}

class CarouselContent extends StatelessWidget {
  final String image;
  final String label;

  const CarouselContent({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset(image, height: 230)),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading3Bold,
          ),
        ),
      ],
    );
  }
}
