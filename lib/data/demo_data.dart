import 'package:flutter/material.dart';
import '../core/theme.dart';

class Friend {
  const Friend(this.name, this.avatar, this.preview, this.time);
  final String name;
  final String avatar;
  final String preview;
  final String time;
}

const friends = [
  Friend(
    'Ivan Morais',
    'avatar_ivan_social.png',
    'Hello man, where are…',
    '16 sc',
  ),
  Friend('Lovely neighbors', '', "Let's go tonight guys?", '1 min'),
  Friend('Cecilia Pozo', 'avatar_cecilia.png', 'Ok, thank u man', '2 min'),
  Friend(
    'Fatima Delgadillo',
    'avatar_fatima.png',
    'I like to see you…',
    '1 wk',
  ),
  Friend('Francisco Maia', 'avatar_francisco.png', "I'm close to you", '1 wk'),
  Friend('Izabella Tabakova', 'avatar_izabella.png', "Let's go out.", '3 wk'),
  Friend('Huo Shu', 'avatar_huo.png', "I'm Coming! Wear you…", '4 mon'),
];

class Activity {
  const Activity(
    this.name,
    this.icon,
    this.calories,
    this.color,
    this.background,
  );
  final String name;
  final String icon;
  final int calories;
  final Color color;
  final Color background;
}

const activities = [
  Activity('Power', 'icon_dumbbell.svg', 1213, Colors.white, AppColors.purple),
  Activity('Rope', 'icon_rope.svg', 6113, AppColors.cyan, Color(0xFFE4F8FF)),
  Activity(
    'Run',
    'icon_treadmill.svg',
    3223,
    Color(0xFFFF8F8F),
    Color(0xFFFFF3F4),
  ),
  Activity(
    'Rugby',
    'icon_rugby.svg',
    653,
    Color(0xFF8A24FF),
    Color(0xFFF3E8FF),
  ),
];
