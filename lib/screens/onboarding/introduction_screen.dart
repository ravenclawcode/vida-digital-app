import 'package:flutter/material.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button11.dart';

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

    // Timer.periodic(Duration(seconds: 3), (timer) {
    //   if (_controller.hasClients) {
    //     int nextPage = _controller.page!.round() + 1;
    //     if (nextPage == 5) {
    //       nextPage = 0;
    //     }
    //     _controller.animateToPage(
    //       nextPage,
    //       duration: Duration(milliseconds: 500),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 60),
            _buildHeaderWelcome(),
            SizedBox(height: 10),
            Expanded(child: Image.asset(illustration9)),
            // _buildCarousel(),
            // SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton11(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.activationAccountScreen,
                ),
                label: 'Daftar',
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton1(
                onTap: () => Navigator.pushNamed(context, Routes.signIn),
                label: 'Masuk',
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWelcome() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icLogo, height: 28),
            SizedBox(width: 10),
            Text('VIDA', style: AppTextStyles.headingIntroduction),
          ],
        ),
        SizedBox(height: 16),
        Text('Selamat Datang', style: AppTextStyles.subHeadingIntroduction),
        SizedBox(height: 11),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Yuk, masuk dan temukan ',
                style: AppTextStyles.descIntroduction.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextSpan(
                text: 'dukungan mental\ndan edukasi ',
                style: AppTextStyles.descIntroduction.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'bagi penyintas ',
                style: AppTextStyles.descIntroduction.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextSpan(
                text: 'HIV/AIDS.',
                style: AppTextStyles.descIntroduction.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //   Widget _buildCarousel() {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         SizedBox(
  //           height: 270,
  //           child: PageView(
  //             controller: _controller,
  //             children: [
  //               CarouselContent(image: illustration8),
  //               CarouselContent(image: illustration1),
  //               CarouselContent(image: illustration2),
  //               CarouselContent(image: illustration3),
  //               CarouselContent(image: illustration4),
  //               CarouselContent(image: illustration5),
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 35),
  //         SmoothPageIndicator(
  //           controller: _controller,
  //           count: 6,
  //           effect: ExpandingDotsEffect(
  //             dotHeight: 8,
  //             dotWidth: 8,
  //             activeDotColor: AppColors.primary,
  //             dotColor: AppColors.accent,
  //             expansionFactor: 3,
  //           ),
  //         ),
  //         SizedBox(height: 60),
  //       ],
  //     );
  //   }
  // }

  // class CarouselContent extends StatelessWidget {
  //   final String image;

  //   const CarouselContent({super.key, required this.image});

  //   @override
  //   Widget build(BuildContext context) {
  //     return Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 25),
  //       child: Image.asset(image, height: 230),
  //     );
  //   }
  // }
}
