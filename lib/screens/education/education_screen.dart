import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/education_provider.dart';
import 'package:mindfullshelter/screens/education/article.dart';
import 'package:mindfullshelter/screens/education/video.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class EducationScreen extends StatefulWidget {
  final int tabIndex;
  const EducationScreen({super.key, required this.tabIndex});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.tabIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EducationProvider>(context, listen: false).initEducation();
    });
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
                Tab(text: 'Video'),
                Tab(text: 'Artikel'),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [Video(), Article()],
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
          Text('Edukasi HIV/AIDS', style: AppTextStyles.heading3Bold),
          Spacer(),
        ],
      ),
    );
  }
}
