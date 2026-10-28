import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../data/demo_data.dart';
import '../../shared/widgets.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({
    super.key,
    required this.state,
    required this.onProfile,
  });
  final AppState state;
  final VoidCallback onProfile;
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final _pages = PageController();
  int _day = 25;
  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _overview() => _pages.animateToPage(
    1,
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeOutCubic,
  );

  void _activity(int index) {
    widget.state.selectActivity(index);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) {
        final a = activities[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label('${a.name} activity', size: 24, bold: true),
              const SizedBox(height: 14),
              label(
                '${a.calories} Kcal recorded in your activity history.',
                color: AppColors.muted,
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                title: widget.state.workoutRunning
                    ? 'Pause workout'
                    : 'Start workout',
                onPressed: () {
                  widget.state.toggleWorkout();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => PageView(
    key: const Key('activity-pages'),
    controller: _pages,
    scrollDirection: Axis.vertical,
    children: [
      Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            width: 375,
            height: 483,
            child: asset('ChartBackground.svg', fit: BoxFit.fill),
          ),
          PageHeading(
            title: 'Your Activities',
            subtitle: 'Good morning!',
            dark: true,
            onProfile: widget.onProfile,
            avatar: widget.state.avatar,
          ),
          Positioned(
            left: 17,
            top: 151,
            right: 17,
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final day = 22 + i;
                return GestureDetector(
                  key: Key('day-$day'),
                  onTap: () => setState(() => _day = day),
                  child: Container(
                    width: _day == day ? 110 : 37,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _day == day ? Colors.white10 : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: label(
                        _day == day
                            ? '$day , ${['Friday', 'Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'][i]}'
                            : '$day',
                        size: 15,
                        color: _day == day ? Colors.white : Colors.white30,
                        bold: _day == day,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            left: 42,
            top: 225,
            child: label(
              '${1200 + (_day - 25) * 72} Kcal',
              color: Colors.white,
              bold: true,
            ),
          ),
          Positioned(
            left: 42,
            top: 267,
            width: 292,
            height: 100,
            child: asset('activity_bars.svg', fit: BoxFit.fill),
          ),
          Positioned(
            left: 42,
            top: 386,
            width: 292,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                label('00:01', color: Colors.white30),
                label(
                  widget.state.workoutRunning ? 'Active' : '06:21',
                  color: Colors.white,
                ),
                label('23:59', color: Colors.white30),
              ],
            ),
          ),
          Positioned(
            left: 265,
            top: 432,
            width: 88,
            height: 88,
            child: CustomPaint(
              painter: _OrbitPainter(),
              child: Center(
                child: ActionCircle(
                  key: const Key('workout-toggle'),
                  onTap: widget.state.toggleWorkout,
                  tooltip: widget.state.workoutRunning
                      ? 'Pause workout'
                      : 'Start workout',
                  icon: widget.state.workoutRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 541,
            child: ActivityCards(
              withRing: true,
              onOverview: _overview,
              onSelected: _activity,
              selected: widget.state.selectedActivity,
            ),
          ),
        ],
      ),
      Stack(
        key: const Key('activity-overview-screen'),
        children: [
          PageHeading(
            title: 'Your Activities',
            subtitle: 'Good morning!',
            onProfile: widget.onProfile,
            avatar: widget.state.avatar,
          ),
          const Positioned(left: 81, top: 138, child: ProgressRing()),
          Positioned(
            left: 79,
            top: 369,
            child: Row(
              children: [
                label('610.5', size: 14, bold: true),
                const SizedBox(width: 5),
                label(
                  'Average calories per day',
                  size: 14,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 7),
                const Icon(
                  Icons.local_fire_department,
                  size: 15,
                  color: AppColors.orange,
                ),
              ],
            ),
          ),
          Positioned(
            left: -14,
            top: 408,
            width: 402,
            height: 120,
            child: asset('Wavegarph.svg', fit: BoxFit.fill),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 552,
            child: ActivityCards(
              onSelected: _activity,
              selected: widget.state.selectedActivity,
            ),
          ),
        ],
      ),
    ],
  );
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.orange.withValues(alpha: .45)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      canvas.drawArc(
        Offset.zero & size,
        i * math.pi / 2 - .4,
        .8,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter oldDelegate) => false;
}
