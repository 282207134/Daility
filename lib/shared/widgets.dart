import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme.dart';
import '../data/demo_data.dart';

Widget asset(
  String name, {
  double? width,
  double? height,
  Color? color,
  BoxFit fit = BoxFit.contain,
}) {
  final path = 'assets/images/$name';
  return name.endsWith('.svg')
      ? SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color, BlendMode.srcIn),
        )
      : Image.asset(path, width: width, height: height, fit: fit);
}

Text label(
  String value, {
  double size = 16,
  Color? color,
  bool bold = false,
  TextAlign? align,
  int? maxLines,
}) => Text(
  value,
  maxLines: maxLines,
  overflow: maxLines == null ? null : TextOverflow.ellipsis,
  textAlign: align,
  style: TextStyle(
    fontSize: size,
    height: 1.22,
    letterSpacing: .05,
    color: color ?? AppColors.ink,
    fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
  ),
);

/// Keeps the original 375 pt layout on phones and a bounded canvas on tablets.
/// Short viewports scroll instead of clipping forms or controls.
class DesignSurface extends StatelessWidget {
  const DesignSurface({super.key, required this.builder});
  final Widget Function(double height) builder;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      top: false,
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = constraints.maxWidth / 375;
              final height = math.max(812.0, constraints.maxHeight / scale);
              return SingleChildScrollView(
                physics: constraints.maxHeight / scale >= 812
                    ? const NeverScrollableScrollPhysics()
                    : null,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: height * scale,
                  child: FittedBox(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: 375,
                      height: height,
                      child: builder(height),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.image = 'avatar_harmen.png',
    this.size = 46,
    this.onTap,
    this.notification = false,
  });
  final String image;
  final double size;
  final VoidCallback? onTap;
  final bool notification;
  @override
  Widget build(BuildContext context) => Semantics(
    label: onTap == null ? null : 'Open your profile',
    button: onTap != null,
    child: GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: ClipOval(child: asset(image, fit: BoxFit.cover)),
            ),
            if (notification)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.dark = false,
    this.onProfile,
    this.back = false,
    this.trailing,
    this.avatar = 'avatar_harmen.png',
  });
  final String title;
  final String? subtitle;
  final bool dark;
  final VoidCallback? onProfile;
  final bool back;
  final Widget? trailing;
  final String avatar;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 119,
    child: Stack(
      children: [
        if (back)
          Positioned(
            left: 27,
            top: 46,
            width: 34,
            height: 40,
            child: IconButton(
              key: const Key('back'),
              tooltip: 'Go back',
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.chevron_left,
                color: Color(0xFFBFBFC2),
                size: 26,
              ),
            ),
          ),
        Positioned(
          left: back ? 70 : 42,
          top: 51,
          right: onProfile != null ? 92 : 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(
                title,
                size: 24,
                bold: true,
                color: dark ? Colors.white : null,
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: label(
                    subtitle!,
                    size: 14,
                    color: dark ? Colors.white54 : AppColors.muted,
                  ),
                ),
            ],
          ),
        ),
        if (onProfile != null)
          Positioned(
            left: 277,
            top: 48,
            child: Avatar(
              key: const Key('profile'),
              image: avatar,
              size: 56,
              notification: true,
              onTap: onProfile,
            ),
          ),
        if (trailing != null) Positioned(right: 42, top: 49, child: trailing!),
      ],
    ),
  );
}

class ActionCircle extends StatelessWidget {
  const ActionCircle({
    super.key,
    required this.onTap,
    this.icon = Icons.play_arrow_rounded,
    this.tooltip = 'Start workout',
    this.size = 69,
  });
  final VoidCallback onTap;
  final IconData icon;
  final String tooltip;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.orange,
      boxShadow: [
        BoxShadow(
          color: AppColors.orange.withValues(alpha: .25),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 32, color: Colors.white),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
  });
  final String title;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Container(
    height: 69,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: AppColors.orange.withValues(alpha: .26),
          blurRadius: 28,
          offset: const Offset(0, 13),
        ),
      ],
    ),
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: label(title, color: Colors.white, bold: true),
    ),
  );
}

class ActivityCards extends StatelessWidget {
  const ActivityCards({
    super.key,
    required this.onSelected,
    this.selected = 0,
    this.compact = false,
    this.withRing = false,
    this.onOverview,
  });
  final ValueChanged<int> onSelected;
  final int selected;
  final bool compact;
  final bool withRing;
  final VoidCallback? onOverview;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: compact ? 105 : 158,
    child: ListView.separated(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: withRing ? 22 : 42, right: 42),
      itemCount: activities.length + (withRing ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(width: 18),
      itemBuilder: (_, i) {
        if (withRing && i == 0) {
          return GestureDetector(
            key: const Key('activity-overview'),
            onTap: onOverview,
            child: Semantics(
              label: 'View activity overview',
              button: true,
              child: SizedBox(width: 154, child: ProgressRing(size: 154)),
            ),
          );
        }
        final index = i - (withRing ? 1 : 0);
        final a = activities[index];
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: (withRing ? 11.0 : 0.0) + (index == selected ? 0 : 10),
            ),
            child: Semantics(
              button: true,
              selected: index == selected,
              label: '${a.name} activity',
              child: GestureDetector(
                key: Key('activity-$index'),
                onTap: () => onSelected(index),
                child: Container(
                  width: 85,
                  height: compact ? 85 : 121,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: a.background,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: index == selected
                        ? [
                            BoxShadow(
                              color: a.background.withValues(alpha: .32),
                              blurRadius: 27,
                              offset: const Offset(0, 14),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      asset(a.icon, width: 18, height: 18, color: a.color),
                      const Spacer(),
                      label(
                        compact
                            ? (index == selected ? a.name : '')
                            : '+${a.calories}\nKcal',
                        size: compact ? 14 : 16,
                        color: compact
                            ? a.color.withValues(alpha: .6)
                            : a.color,
                        bold: !compact,
                        maxLines: compact ? 1 : 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, this.size = 214});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(size: Size.square(size), painter: _RingPainter()),
        label('35%', size: 24, bold: true),
      ],
    ),
  );
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * .36;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .066
      ..strokeCap = StrokeCap.round;
    const colors = [Color(0xFF329CF5), Color(0xFF60E1F3), AppColors.purple];
    final arcs = [.55, .2, .1, .7, .2, .1, .7, .2, .1, .7, .2, .1, .7, .2, .1];
    final total = arcs.fold<double>(0, (sum, a) => sum + a) + arcs.length * .1;
    var start = -math.pi / 2 + .25;
    for (var i = 0; i < arcs.length; i++) {
      paint.color = colors[i % 3];
      final angle = arcs[i] * math.pi * 2 / total;
      canvas.drawArc(rect, start, angle, false, paint);
      start += angle + .1 * math.pi * 2 / total;
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) => false;
}

void showNotice(BuildContext context, String title, String message) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}
