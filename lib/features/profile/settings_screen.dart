import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.state});
  final AppState state;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late DateTime _birthday;
  late String _gender;
  int _tab = 0;
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.state.name);
    _birthday = widget.state.birthday;
    _gender = widget.state.gender;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  String get _date {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[_birthday.month - 1]} ${_birthday.day}, ${_birthday.year}';
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.state,
    builder: (context, _) => DesignSurface(
      builder: (height) => Stack(
        children: [
          const PageHeading(title: 'Settings', back: true),
          Positioned(
            left: 0,
            right: 0,
            top: 109,
            height: 49,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: List.generate(
                  2,
                  (i) => Expanded(
                    child: GestureDetector(
                      key: Key('settings-tab-$i'),
                      onTap: () => setState(() => _tab = i),
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 11),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                              color: i == _tab
                                  ? AppColors.orange
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: label(
                          i == 0 ? 'Profile' : 'General',
                          color: i == _tab ? AppColors.orange : AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_tab == 0) ...[
            Positioned(
              left: 128,
              top: 194,
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  Avatar(image: widget.state.avatar, size: 120),
                  Positioned(
                    right: 0,
                    bottom: 5,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.ink,
                      ),
                      child: IconButton(
                        key: const Key('edit-avatar'),
                        tooltip: 'Change profile photo',
                        onPressed: _chooseAvatar,
                        icon: const Icon(
                          Icons.edit,
                          size: 21,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 42,
              right: 42,
              top: 347,
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label('Full name', size: 14, color: AppColors.muted),
                    const SizedBox(height: 10),
                    TextFormField(
                      key: const Key('profile-name'),
                      controller: _name,
                      style: const TextStyle(fontSize: 16),
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Please enter your name'
                          : value.trim().length > 50
                          ? 'Use 50 characters or fewer'
                          : null,
                      decoration: const InputDecoration(),
                    ),
                    const SizedBox(height: 24),
                    label('Date of Birth', size: 14, color: AppColors.muted),
                    const SizedBox(height: 10),
                    _select('profile-birthday', _date, _chooseBirthday),
                    const SizedBox(height: 24),
                    label('Gender', size: 14, color: AppColors.muted),
                    const SizedBox(height: 10),
                    _select('profile-gender', _gender, _chooseGender),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 42,
              right: 42,
              bottom: 44,
              child: PrimaryButton(
                key: const Key('profile-submit'),
                title: _saving ? 'Saving…' : 'Submit',
                onPressed: _saving ? null : _submit,
              ),
            ),
          ] else
            Positioned(
              left: 42,
              right: 42,
              top: 204,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Make Daility yours', size: 20, bold: true),
                  const SizedBox(height: 12),
                  label(
                    'Choose how you stay connected.',
                    size: 14,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: 30),
                  SwitchListTile(
                    key: const Key('notifications-setting'),
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.orange,
                    title: label('Notifications', bold: true),
                    subtitle: label(
                      'Daily activity reminders',
                      size: 13,
                      color: AppColors.muted,
                    ),
                    value: widget.state.notifications,
                    onChanged: (value) =>
                        widget.state.setPreference('notifications', value),
                  ),
                  const Divider(color: AppColors.border),
                  SwitchListTile(
                    key: const Key('location-setting'),
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.orange,
                    title: label('Share my location', bold: true),
                    subtitle: label(
                      'Show me to nearby friends',
                      size: 13,
                      color: AppColors.muted,
                    ),
                    value: widget.state.shareLocation,
                    onChanged: (value) =>
                        widget.state.setPreference('shareLocation', value),
                  ),
                  const SizedBox(height: 28),
                  label(
                    'Preferences are saved on this device.',
                    size: 13,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );

  Widget _select(String key, String value, VoidCallback onTap) =>
      GestureDetector(
        key: Key(key),
        onTap: onTap,
        child: Container(
          height: 59,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(child: label(value)),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFBFBFC2),
                size: 27,
              ),
            ],
          ),
        ),
      );

  Future<void> _chooseBirthday() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected != null && mounted) setState(() => _birthday = selected);
  }

  void _chooseGender() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final gender in ['Male', 'Female', 'Prefer not to say'])
            ListTile(
              title: Text(gender),
              trailing: _gender == gender
                  ? const Icon(Icons.check, color: AppColors.orange)
                  : null,
              onTap: () {
                setState(() => _gender = gender);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    ),
  );

  void _chooseAvatar() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            label('Choose your profile photo', size: 20, bold: true),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final image in [
                  'avatar_harmen.png',
                  'avatar_ivan_social.png',
                  'avatar_fatima.png',
                  'avatar_oea.png',
                ])
                  Avatar(
                    image: image,
                    size: 60,
                    onTap: () {
                      widget.state.setAvatar(image);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    await widget.state.saveProfile(_name.text, _birthday, _gender);
    if (!mounted) return;
    setState(() => _saving = false);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }
}
