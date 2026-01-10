import 'package:flutter/material.dart';
import 'package:mindfullshelter/screens/terms%20&%20conditions/privacy_policy.dart';
import 'package:mindfullshelter/screens/terms%20&%20conditions/terms_of_service.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final int tabIndex;
  const TermsAndConditionsScreen({super.key, required this.tabIndex});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.tabIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 11),
            _buildHeader(
              context: context,
              icon: icBackLeft2,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 5),
            TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 0.5,
              dividerColor: AppColors.textLight,
              labelStyle: AppTextStyles.labelSelect,
              unselectedLabelStyle: AppTextStyles.labelUnselect,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 3, color: AppColors.primary),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              tabs: [
                Tab(text: 'Ketentuan Layanan'),
                Tab(text: 'Kebijakan Privasi'),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [PrivacyPolicy(), TermsOfService()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: onTap,
            child: Image(image: AssetImage(icon), width: 10),
          ),
          Spacer(),
          Text('Syarat & Ketentuan', style: AppTextStyles.heading3Bold),
          Spacer(),
        ],
      ),
    );
  }
}
