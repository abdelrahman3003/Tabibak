import 'package:flutter/material.dart';

bool isArabic(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'ar';
