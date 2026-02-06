import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/education_provider.dart';
import 'package:mindfullshelter/screens/tools/phq9.dart';
import 'package:mindfullshelter/screens/tools/soap.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class ToolsScreen extends StatefulWidget {
  final int tabIndex;
  const ToolsScreen({super.key, required this.tabIndex});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen>
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
            _buildHeader(),
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
                Tab(text: 'PHQ-9'),
                Tab(text: 'Catatan SOAP'),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [Phq9(), Soap()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    {
      return Center(
        child: Text('Alat Diagnostik', style: AppTextStyles.heading3Bold),
      );
    }
  }
}
