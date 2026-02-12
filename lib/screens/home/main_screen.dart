import 'package:flutter/material.dart';
import 'package:mindfullshelter/screens/chat/chat_screen.dart';
import 'package:mindfullshelter/screens/home/home_screen.dart';
import 'package:mindfullshelter/screens/profile/profile_screen.dart';
import 'package:mindfullshelter/screens/tools/tools_screen.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/session_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  int? userRole;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  void _loadRole() async {
    int? role = await SessionManager().getRole();
    setState(() {
      userRole = role;
    });
  }

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
    if (userRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> screens = userRole == 0
        ? [
            const HomeScreen(),
            const ToolsScreen(tabIndex: 0),
            const ProfileScreen(),
          ]
        : [const HomeScreen(), const ChatScreen(), const ProfileScreen()];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
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
                padding: const EdgeInsets.symmetric(vertical: 5),
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
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  userRole == 0 ? icTools : icChat,
                  color: onIconSelected(1),
                  height: 22,
                ),
              ),
              label: userRole == 0 ? 'Alat' : 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  icProfile,
                  color: onIconSelected(2),
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
