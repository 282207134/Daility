import 'package:daility/app.dart';
import 'package:daility/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final font = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    await font.load();
  });
  Future<AppState> state() async {
    SharedPreferences.setMockInitialValues({});
    return AppState(await SharedPreferences.getInstance());
  }

  test('profile, preferences and outgoing messages survive reload', () async {
    final model = await state();
    await model.saveProfile('  Alex Porter  ', DateTime(2000, 2, 3), 'Female');
    await model.setPreference('notifications', false);
    await model.setAvatar('avatar_fatima.png');
    await model.sendMessage('Ivan Morais', '  See you at the park!  ');
    await model.sendMessage('Ivan Morais', '   ');
    final reloaded = AppState(await SharedPreferences.getInstance());
    expect(reloaded.name, 'Alex Porter');
    expect(reloaded.birthday, DateTime(2000, 2, 3));
    expect(reloaded.gender, 'Female');
    expect(reloaded.notifications, false);
    expect(reloaded.avatar, 'avatar_fatima.png');
    expect(reloaded.messages['Ivan Morais'], ['See you at the park!']);
  });

  testWidgets('main navigation, maps, settings and message search work', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(DailityApp(state: await state()));
    await tester.pumpAndSettle();
    expect(find.text('Your Activities'), findsOneWidget);
    await tester.tap(find.byKey(const Key('tab-1')));
    await tester.pumpAndSettle();
    expect(find.text('Friends around you'), findsOneWidget);
    await tester.tap(find.byKey(const Key('map-play')));
    await tester.pumpAndSettle();
    expect(find.text('Your Friends'), findsOneWidget);
    await tester.tap(find.byKey(const Key('map-dimension')));
    await tester.pumpAndSettle();
    expect(find.text('You'), findsOneWidget);
    await tester.tap(find.byKey(const Key('tab-3')));
    await tester.pumpAndSettle();
    expect(find.text('22,240'), findsOneWidget);
    await tester.tap(find.byKey(const Key('profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-Messages')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('message-search')), 'Cecilia');
    await tester.pumpAndSettle();
    expect(find.text('Cecilia Pozo'), findsOneWidget);
    expect(find.text('Ivan Morais'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
