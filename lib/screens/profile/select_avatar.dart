import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';

class SelectAvatar extends StatefulWidget {
  const SelectAvatar({super.key, required this.onAvatarSelected});

  final Function(String) onAvatarSelected;

  @override
  State<SelectAvatar> createState() => _SelectAvatarState();
}

class _SelectAvatarState extends State<SelectAvatar> {
  int? selectedIndex;
  List<String> avatarUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    avatarUrls = [
      avatar1,
      avatar2,
      avatar3,
      avatar4,
      avatar5,
      avatar6,
      avatar7,
      avatar8,
      avatar9,
    ];
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 25.0 * 2;
    const spacing = 20.0;
    const totalSpacing = spacing * 2;
    final baseItemSize = (screenWidth - horizontalPadding - totalSpacing) / 3;
    final itemSize = baseItemSize - 10;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0XFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 108,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0XFF000000),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Pilih Avatar',
                  style: GoogleFonts.poppins(
                    color: const Color(0XFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0XFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.close_rounded, size: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: avatarUrls.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedIndex == index) {
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                          final selectedAvatar = avatarUrls[selectedIndex!];
                          widget.onAvatarSelected(selectedAvatar);
                        }
                      });
                    },
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: itemSize,
                            height: itemSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                avatarUrls[index],
                                width: itemSize,
                                height: itemSize,
                                fit: BoxFit.cover,
                                color: isSelected
                                    ? const Color(
                                        0XFF000000,
                                      ).withValues(alpha: 0.3)
                                    : null,
                                colorBlendMode: isSelected
                                    ? BlendMode.darken
                                    : null,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Image(
                              width: 25,
                              height: 19,
                              image: AssetImage(icCheck),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

void showSelectAvatar(BuildContext context, Function(String) onAvatarSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SelectAvatar(onAvatarSelected: onAvatarSelected),
    ),
  );
}
