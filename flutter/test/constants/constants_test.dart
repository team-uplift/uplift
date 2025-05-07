import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/constants/constants.dart';

void main() {
  group('AppColors', () {
    test('baseYellow is 0xFFf9c54e', () {
      expect(AppColors.baseYellow.value, 0xFFf9c54e);
    });
    test('baseRed is 0xFFF94346', () {
      expect(AppColors.baseRed.value, 0xFFF94346);
    });
    test('baseGreen is 0xFF91BE6F', () {
      expect(AppColors.baseGreen.value, 0xFF91BE6F);
    });
    test('baseBlue is 0xFF56768F', () {
      expect(AppColors.baseBlue.value, 0xFF56768F);
    });
    test('baseOrange is 0xFFF3712B', () {
      expect(AppColors.baseOrange.value, 0xFFF3712B);
    });

    test('softBlue is 0xFFA9D6E5', () {
      expect(AppColors.softBlue.value, 0xFFA9D6E5);
    });
    test('lavender is 0xFFCABBE9', () {
      expect(AppColors.lavender.value, 0xFFCABBE9);
    });
    test('warmWhite is 0xFFFFF8F0', () {
      expect(AppColors.warmWhite.value, 0xFFFFF8F0);
    });
    test('mutedTeal is 0xFF5CB8A7', () {
      expect(AppColors.mutedTeal.value, 0xFF5CB8A7);
    });
    test('lightBeige is 0xFFFFF3E0', () {
      expect(AppColors.lightBeige.value, 0xFFFFF3E0);
    });
  });

  group('AppConfig', () {
    test('baseUrl points to the Uplift backend', () {
      expect(
        AppConfig.baseUrl,
        'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift',
      );
    });
    test('apiVersion is v1', () {
      expect(AppConfig.cooldownTime, 24);
    });
  });

  

  group('FormVariables', () {
    test('usStates has 50 entries and contains CA, NY, TX', () {
      final states = FormVariables.usStates;
      expect(states.length, 50);
      expect(states, containsAll(['CA', 'NY', 'TX']));
    });

    test('usStates is exactly the standard USPS abbreviations in order', () {
      expect(
        FormVariables.usStates,
        <String>[
          'AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA',
          'HI','ID','IL','IN','IA','KS','KY','LA','ME','MD',
          'MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ',
          'NM','NY','NC','ND','OH','OK','OR','PA','RI','SC',
          'SD','TN','TX','UT','VT','VA','WA','WV','WI','WY',
        ],
      );
    });
  });
}
