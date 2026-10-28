import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';
import '../social/messages_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) => DesignSurface(
      builder: (height) => Stack(
        children: [
          const PageHeading(title: 'Your Profile', back: true),
          Positioned(
            left: 128,
            top: 119,
            child: Avatar(image: state.avatar, size: 120),
          ),
          Positioned(
            left: 42,
            right: 42,
            top: 258,
            child: label(state.name, bold: true, align: TextAlign.center),
          ),
          Positioned(
            left: 95,
            top: 312,
            child: _stat('610.5', 'Total calories'),
          ),
          Positioned(left: 218, top: 312, child: _stat('346', 'Followers')),
          Positioned(
            left: 42,
            right: 42,
            top: 412,
            child: Column(
              children: [
                const Divider(height: 1, color: AppColors.border),
                _row(
                  'Get Premium Acount',
                  'icon_premium.svg',
                  _premium,
                  context,
                  premium: true,
                  height: 90,
                ),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                _row(
                  'Messages',
                  'icon_messages.svg',
                  (context) => _open(context, MessagesScreen(state: state)),
                  context,
                ),
                _row('Invite a Friend', 'icon_invite.svg', _invite, context),
                _row(
                  'Settings',
                  'Shape.svg',
                  (context) => _open(context, SettingsScreen(state: state)),
                  context,
                ),
                _row(
                  'About',
                  'Path12.svg',
                  (context) => showNotice(
                    context,
                    'Daility 1.0.0',
                    'Make every day a little more active.\n\nActivity tracking, friendly challenges and staying connected.\n\nUI based on the Daility UI Kit by Piqo Design. This app uses local demonstration data.',
                  ),
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  void _open(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  Widget _stat(String value, String name) => Column(
    children: [
      label(value, size: 24, bold: true),
      const SizedBox(height: 5),
      label(name, size: 14, color: AppColors.muted),
    ],
  );
  Widget _row(
    String title,
    String icon,
    void Function(BuildContext) onTap,
    BuildContext context, {
    bool premium = false,
    double height = 66,
  }) => GestureDetector(
    key: Key('profile-$title'),
    behavior: HitTestBehavior.opaque,
    onTap: () => onTap(context),
    child: SizedBox(
      height: height,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: premium ? const Color(0xFFFFEED0) : AppColors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: asset(
              icon,
              color: premium ? const Color(0xFFFFB12B) : Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: label(title)),
          const Icon(Icons.chevron_right, size: 27, color: Color(0xFFBFBFC2)),
        ],
      ),
    ),
  );
  void _premium(BuildContext context) => showNotice(
    context,
    'Daility Premium',
    'Build better habits with deeper activity insights and more friendly challenges.\n\nThis is a preview. Subscriptions are not available in this demo.',
  );
  Future<void> _invite(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(
        text:
            '${state.name} invites you to Daility. Let’s stay active and take on a daily challenge together!',
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invitation copied. Share it with a friend.'),
        ),
      );
    }
  }
}
