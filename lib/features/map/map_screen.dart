import 'package:flutter/material.dart';
import '../../app.dart';
import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../features/social/messages_screen.dart';
import '../../data/demo_data.dart';
import '../../shared/widgets.dart';

class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({
    super.key,
    required this.state,
    required this.onProfile,
    required this.onTabSelected,
  });
  final AppState state;
  final VoidCallback onProfile;
  final ValueChanged<int> onTabSelected;
  void _openMap(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) =>
          ChallengeMapScreen(state: state, onTabSelected: onTabSelected),
    ),
  );
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      PageHeading(
        title: 'Live Map',
        subtitle: 'Friendly challenges in town',
        onProfile: onProfile,
        avatar: state.avatar,
      ),
      Positioned(
        left: 42,
        top: 146,
        width: 291,
        height: 320,
        child: GestureDetector(
          key: const Key('open-map'),
          onTap: () => _openMap(context),
          child: Semantics(
            label: 'Open challenge route map',
            button: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  asset('map_preview.png', fit: BoxFit.cover),
                  const Positioned(
                    left: 58,
                    top: 24,
                    child: MapPin(image: 'avatar_ivan.png'),
                  ),
                  const Positioned(
                    left: 31,
                    top: 235,
                    child: MapPin(image: 'avatar_cecilia.png'),
                  ),
                  const Positioned(left: 121, top: 134, child: NavigationPin()),
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
        left: 254,
        top: 432,
        child: ActionCircle(
          key: const Key('map-play'),
          onTap: () => _openMap(context),
          tooltip: 'Explore challenge route',
        ),
      ),
      Positioned(
        left: 42,
        top: 506,
        child: label('Friends around you', bold: true),
      ),
      Positioned(
        left: 42,
        right: 42,
        top: 554,
        child: Column(
          children: [
            _friend(
              context,
              'Ivan Morais',
              'avatar_ivan.png',
              '741.3 Cal',
              '1 min left',
              friends.first,
            ),
            const SizedBox(height: 22),
            _friend(
              context,
              'Cecilia Pozo',
              'avatar_cecilia.png',
              '538.2 Cal',
              '3 min left',
              friends[2],
            ),
          ],
        ),
      ),
    ],
  );
  Widget _friend(
    BuildContext context,
    String name,
    String image,
    String calories,
    String time,
    Friend friend,
  ) => GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(state: state, friend: friend),
      ),
    ),
    child: Row(
      children: [
        Avatar(image: image),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(name, bold: true),
              const SizedBox(height: 5),
              label(calories, color: AppColors.muted),
            ],
          ),
        ),
        label(time, size: 14, color: AppColors.muted),
      ],
    ),
  );
}

class ChallengeMapScreen extends StatefulWidget {
  const ChallengeMapScreen({
    super.key,
    required this.state,
    required this.onTabSelected,
  });
  final AppState state;
  final ValueChanged<int> onTabSelected;
  @override
  State<ChallengeMapScreen> createState() => _ChallengeMapScreenState();
}

class _ChallengeMapScreenState extends State<ChallengeMapScreen> {
  bool _is3d = false;
  bool _showRoute = true;
  @override
  Widget build(BuildContext context) => DesignSurface(
    builder: (height) => Stack(
      children: [
        PageHeading(
          title: 'Your Friends',
          back: true,
          trailing: Semantics(
            label: 'Show challenge route',
            toggled: _showRoute,
            child: GestureDetector(
              key: const Key('route-switch'),
              onTap: () => setState(() => _showRoute = !_showRoute),
              child: Container(
                width: 38,
                height: 20,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: _showRoute
                      ? AppColors.orange
                      : const Color(0xFFDADADA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                  alignment: _showRoute
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 119,
          bottom: 127,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                asset(_is3d ? 'map_3d.png' : 'map_2d.png', fit: BoxFit.cover),
                if (_showRoute)
                  CustomPaint(painter: _RoutePainter(is3d: _is3d)),
                if (!_is3d) ...[
                  const Positioned(
                    left: 84,
                    top: 56,
                    child: _MapLabel('Ivan Morais'),
                  ),
                  const Positioned(
                    left: 119,
                    top: 111,
                    child: MapPin(image: 'avatar_ivan.png'),
                  ),
                  const Positioned(
                    left: 14,
                    top: 392,
                    child: _MapLabel('Cecilia Pozo'),
                  ),
                  const Positioned(
                    left: 43,
                    top: 445,
                    child: MapPin(image: 'avatar_cecilia.png'),
                  ),
                  const Positioned(left: 245, top: 387, child: NavigationPin()),
                  if (_showRoute)
                    Positioned(
                      left: 70,
                      top: 201,
                      child: Container(
                        width: 53,
                        height: 53,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF9400),
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ] else ...[
                  const Positioned(
                    left: 237,
                    top: 185,
                    child: _MapLabel('Ivan Morais'),
                  ),
                  const Positioned(
                    left: 281,
                    top: 237,
                    child: MapPin(image: 'avatar_ivan.png', size: 24),
                  ),
                  const Positioned(left: 56, top: 347, child: _MapLabel('You')),
                  if (_showRoute)
                    const Positioned(
                      left: 76,
                      top: 398,
                      child: Icon(
                        Icons.circle,
                        size: 18,
                        color: AppColors.orange,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          left: 269,
          top: 151,
          child: Semantics(
            button: true,
            label: _is3d ? 'Switch to 2D map' : 'Switch to 3D map',
            child: GestureDetector(
              key: const Key('map-dimension'),
              onTap: () => setState(() => _is3d = !_is3d),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .04),
                      blurRadius: 12,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: asset(
                  _is3d ? 'Shape2.svg' : 'Shape1.svg',
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 127,
          child: BottomTabs(
            selected: 1,
            onSelected: (i) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              widget.onTabSelected(i);
            },
          ),
        ),
      ],
    ),
  );
}

class MapPin extends StatelessWidget {
  const MapPin({super.key, required this.image, this.size = 46});
  final String image;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .15),
          blurRadius: 7,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Avatar(image: image, size: size - 6),
  );
}

class NavigationPin extends StatelessWidget {
  const NavigationPin({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.orange,
      border: Border.all(color: Colors.white, width: 4),
      boxShadow: [
        BoxShadow(
          color: AppColors.orange.withValues(alpha: .15),
          blurRadius: 12,
        ),
      ],
    ),
    child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 25),
  );
}

class _MapLabel extends StatelessWidget {
  const _MapLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 9),
      ],
    ),
    child: label(text, bold: true),
  );
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter({required this.is3d});
  final bool is3d;
  @override
  void paint(Canvas canvas, Size size) {
    final path = is3d
        ? (Path()
            ..moveTo(85, 407)
            ..lineTo(182, 344)
            ..lineTo(152, 323)
            ..lineTo(294, 250))
        : (Path()
            ..moveTo(94, 229)
            ..lineTo(127, 336)
            ..lineTo(234, 301)
            ..lineTo(269, 416));
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFF8210)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) => oldDelegate.is3d != is3d;
}
