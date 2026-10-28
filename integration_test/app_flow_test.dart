import 'package:daility/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('all Pixso screens and essential local workflows', (
    tester,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await app.main();
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    Future<void> tap(String key) async {
      await tester.tap(find.byKey(Key(key)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    Future<void> screenshot(String name) async {
      await tester.pumpAndSettle();
      await binding.takeScreenshot(name);
    }

    await screenshot('01_home');
    await tap('workout-toggle');
    expect(find.text('Active'), findsOneWidget);
    await tap('workout-toggle');
    await tap('activity-overview');
    await screenshot('02_activity_overview');

    await tap('tab-1');
    await screenshot('03_live_map');
    await tap('map-play');
    await screenshot('04_map_2d');
    await tap('map-dimension');
    expect(find.text('You'), findsOneWidget);
    await screenshot('05_map_3d');
    await tap('route-switch');
    await tap('route-switch');
    await tap('tab-2');
    expect(find.text('Social Friends'), findsOneWidget);
    await screenshot('06_social');

    await tap('tab-3');
    await screenshot('07_challenge');
    await tap('activity-1');
    expect(find.text('Rope'), findsOneWidget);
    await tap('profile');
    await screenshot('08_profile');
    await tap('profile-Settings');
    await screenshot('10_settings');
    await tap('settings-tab-1');
    await screenshot('11_general_settings');
    await tap('notifications-setting');
    expect(preferences.getBool('notifications'), false);
    await tap('notifications-setting');
    await tap('settings-tab-0');
    await tester.enterText(find.byKey(const Key('profile-name')), '');
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    await tester.pumpAndSettle();
    await tap('profile-submit');
    expect(find.text('Please enter your name'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('profile-name')),
      'Harmen Porter',
    );
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    await tester.pumpAndSettle();
    await tap('profile-submit');
    expect(preferences.getString('name'), 'Harmen Porter');
    await tester.pump(const Duration(seconds: 4));
    await tap('back');

    await tap('profile-Messages');
    await screenshot('09_messages');
    await tester.enterText(find.byKey(const Key('message-search')), 'Cecilia');
    await tester.pumpAndSettle();
    expect(find.text('Cecilia Pozo'), findsOneWidget);
    expect(find.text('Ivan Morais'), findsNothing);
    await tester.enterText(find.byKey(const Key('message-search')), '');
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    await tester.pumpAndSettle();
    await tap('conversation-Ivan Morais');
    await tester.enterText(
      find.byKey(const Key('chat-input')),
      'Ready for today’s challenge?',
    );
    await tap('chat-send');
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await tester.pumpAndSettle();
    expect(find.text('Ready for today’s challenge?'), findsOneWidget);
    await screenshot('12_chat');
    await tap('chat-back');
    expect(find.text('Ready for today’s challenge?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
