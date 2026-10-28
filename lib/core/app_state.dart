import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  AppState(this._preferences) {
    name = _preferences.getString('name') ?? 'Harmen Porter';
    avatar = _preferences.getString('avatar') ?? 'avatar_harmen.png';
    gender = _preferences.getString('gender') ?? 'Male';
    birthday =
        DateTime.tryParse(_preferences.getString('birthday') ?? '') ??
        DateTime(1998, 9, 7);
    notifications = _preferences.getBool('notifications') ?? true;
    shareLocation = _preferences.getBool('shareLocation') ?? true;
    final saved = _preferences.getString('messages');
    if (saved != null) {
      final data = jsonDecode(saved) as Map<String, dynamic>;
      messages.addAll(
        data.map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      );
    }
  }

  final SharedPreferences _preferences;
  late String name;
  late String avatar;
  late String gender;
  late DateTime birthday;
  late bool notifications;
  late bool shareLocation;
  bool workoutRunning = false;
  final Map<String, List<String>> messages = {};
  final Set<int> likedPosts = {};
  int selectedActivity = 0;

  Future<void> setAvatar(String image) async {
    avatar = image;
    await _preferences.setString('avatar', image);
    notifyListeners();
  }

  Future<void> saveProfile(
    String newName,
    DateTime date,
    String newGender,
  ) async {
    name = newName.trim();
    birthday = date;
    gender = newGender;
    await Future.wait([
      _preferences.setString('name', name),
      _preferences.setString('birthday', birthday.toIso8601String()),
      _preferences.setString('gender', gender),
    ]);
    notifyListeners();
  }

  Future<void> setPreference(String key, bool value) async {
    if (key == 'notifications') notifications = value;
    if (key == 'shareLocation') shareLocation = value;
    await _preferences.setBool(key, value);
    notifyListeners();
  }

  void toggleWorkout() {
    workoutRunning = !workoutRunning;
    notifyListeners();
  }

  void selectActivity(int index) {
    selectedActivity = index;
    notifyListeners();
  }

  void toggleLike(int post) {
    likedPosts.contains(post) ? likedPosts.remove(post) : likedPosts.add(post);
    notifyListeners();
  }

  Future<void> sendMessage(String friend, String message) async {
    final text = message.trim();
    if (text.isEmpty) return;
    messages.putIfAbsent(friend, () => []).add(text);
    await _preferences.setString('messages', jsonEncode(messages));
    notifyListeners();
  }
}
