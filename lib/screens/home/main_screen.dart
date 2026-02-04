import 'package:flutter/material.dart';
import 'package:mindfullshelter/screens/home/home_screen.dart';
import 'package:mindfullshelter/screens/profile/profile_screen.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  void onNavItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Color onIconSelected(int index) {
    return selectedIndex == index ? AppColors.primary : AppColors.textLight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [HomeScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: onNavItemSelected,
          selectedLabelStyle: AppTextStyles.labelSelectNav,
          unselectedLabelStyle: AppTextStyles.labelUnselectNav,
          elevation: 1,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  icHome,
                  color: onIconSelected(0),
                  height: 22,
                ),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  icProfile,
                  color: onIconSelected(1),
                  height: 25,
                ),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
