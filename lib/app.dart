import 'package:flutter/material.dart';
import 'core/app_state.dart';
import 'core/theme.dart';
import 'features/activity/activity_screen.dart';
import 'features/challenge/challenge_screen.dart';
import 'features/map/map_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/social/social_screen.dart';
import 'shared/widgets.dart';

class DailityApp extends StatelessWidget {
  const DailityApp({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Daility',
    debugShowCheckedModeBanner: false,
    theme: appTheme(),
    home: AppShell(state: state),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.state});
  final AppState state;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;
  void _profile() => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => ProfileScreen(state: widget.state)),
  );
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.state,
    builder: (context, _) => DesignSurface(
      builder: (height) => Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 127,
            child: IndexedStack(
              index: _tab,
              children: [
                ActivityScreen(state: widget.state, onProfile: _profile),
                LiveMapScreen(
                  state: widget.state,
                  onProfile: _profile,
                  onTabSelected: (tab) => setState(() => _tab = tab),
                ),
                SocialScreen(state: widget.state, onProfile: _profile),
                ChallengeScreen(state: widget.state, onProfile: _profile),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 127,
            child: BottomTabs(
              selected: _tab,
              onSelected: (tab) => setState(() => _tab = tab),
            ),
          ),
        ],
      ),
    ),
  );
}

class BottomTabs extends StatelessWidget {
  const BottomTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(31, 30, 31, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (i) {
          const names = [
            'Home',
            'Live Map',
            'Social Friends',
            'Daily Challenge',
          ];
          const icons = [
            'Shape4.svg',
            'CombinedShape16.svg',
            'Path1.svg',
            'CombinedShape21.svg',
          ];
          return Semantics(
            selected: i == selected,
            button: true,
            label: names[i],
            child: Tooltip(
              message: names[i],
              child: GestureDetector(
                key: Key('tab-$i'),
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(i),
                child: SizedBox(
                  width: 78,
                  height: 54,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      asset(
                        icons[i],
                        width: 24,
                        height: 24,
                        color: i == selected
                            ? AppColors.orange
                            : const Color(0xFFBFBFC2),
                      ),
                      const SizedBox(height: 7),
                      if (i == selected)
                        CustomPaint(
                          size: const Size(22, 7),
                          painter: _TabMark(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

class _TabMark extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(1, 0)
      ..quadraticBezierTo(11, 7, 21, 0);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.orange.withValues(alpha: .45)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TabMark oldDelegate) => false;
}
