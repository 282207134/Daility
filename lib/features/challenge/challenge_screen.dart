import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({
    super.key,
    required this.state,
    required this.onProfile,
  });
  final AppState state;
  final VoidCallback onProfile;
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      PageHeading(
        title: 'Daily Challenge',
        subtitle: 'If you dream it, you can do it!',
        onProfile: onProfile,
        avatar: state.avatar,
      ),
      Positioned(
        left: 116,
        top: 145,
        width: 154,
        height: 158,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: 154,
              height: 76,
              child: asset('Partyobject.svg'),
            ),
            Positioned(
              left: 21,
              top: 6,
              width: 98,
              height: 139,
              child: asset('Flag.png'),
            ),
            Positioned(
              left: 21,
              top: 148,
              width: 102,
              height: 10,
              child: asset('Shadow.png'),
            ),
          ],
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        top: 313,
        child: Column(
          children: [
            label('22,240', size: 24, bold: true),
            const SizedBox(height: 5),
            label('Points', size: 14, color: AppColors.muted),
          ],
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        top: 399,
        child: ActivityCards(
          compact: true,
          selected: state.selectedActivity,
          onSelected: state.selectActivity,
        ),
      ),
      Positioned(
        left: 42,
        right: 42,
        top: 549,
        child: Column(
          children: [
            _leader('Victor Pacheco', 'avatar_victor.png', '192,120', true),
            const SizedBox(height: 20),
            _leader('Oea Romana', 'avatar_oea.png', '12,120', false),
          ],
        ),
      ),
    ],
  );
  Widget _leader(String name, String image, String points, bool gold) => Row(
    children: [
      Avatar(image: image),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label(name, bold: true),
            const SizedBox(height: 5),
            label('2 Days Ago', color: AppColors.muted),
          ],
        ),
      ),
      Container(
        width: 60,
        height: 57,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            asset(
              gold ? 'icon_gold.svg' : 'icon_silver.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(height: 3),
            label(points, size: 11),
          ],
        ),
      ),
    ],
  );
}
