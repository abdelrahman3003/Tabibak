import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension LocalizedNum on num {
  String localized(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final formatter = NumberFormat.decimalPattern(locale);
    return formatter.format(this);
  }
}
