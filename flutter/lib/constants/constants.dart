import 'package:flutter/material.dart';

class AppColors {
  static const Color baseYellow = Color(0xFFf9c54e);
  static const Color baseRed = Color(0xFFF94346);
  static const Color baseGreen = Color(0xFF91BE6F);
  static const Color baseBlue = Color(0xFF56768F);
  static const Color baseOrange = Color(0xFFF3712B);

  static const Color softBlue = Color(0xFFA9D6E5);
  static const Color lavender = Color(0xFFCABBE9);
  static const Color warmWhite = Color(0xFFFFF8F0);
  static const Color mutedTeal = Color(0xFF5CB8A7);
  static const Color lightBeige = Color(0xFFFFF3E0);
}

class AppConfig {
  static const baseUrl =
      'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift';
  // number of hours before a user can re-edit profile
  static const cooldownTime = 24;
}

class FormVariables {
    static List<String> usStates = [
    'AL',
    'AK',
    'AZ',
    'AR',
    'CA',
    'CO',
    'CT',
    'DE',
    'FL',
    'GA',
    'HI',
    'ID',
    'IL',
    'IN',
    'IA',
    'KS',
    'KY',
    'LA',
    'ME',
    'MD',
    'MA',
    'MI',
    'MN',
    'MS',
    'MO',
    'MT',
    'NE',
    'NV',
    'NH',
    'NJ',
    'NM',
    'NY',
    'NC',
    'ND',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VT',
    'VA',
    'WA',
    'WV',
    'WI',
    'WY',
  ];
}
