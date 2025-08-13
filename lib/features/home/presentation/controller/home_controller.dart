import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/string_constants.dart';
import 'package:tabibak/gen/assets.gen.dart';

final indexScreenProvider = StateProvider<int>((ref) {
  return 0;
});
final categoryListNameProvider = StateProvider<List<String>>((ref) {
  return [
    StringConstants.general.tr(),
    StringConstants.urology.tr(),
    StringConstants.neurology.tr(),
    StringConstants.pediatrics.tr(),
    StringConstants.dentistry.tr(),
    StringConstants.optometry.tr(),
  ];
});
final categoryListIconsProvider = StateProvider<List<String>>((ref) {
  return [
    Assets.images.manDoctor.path,
    Assets.images.kidneys1.path,
    Assets.images.brain1.path,
    Assets.images.iamge.path,
    Assets.images.dentistry.path,
    Assets.images.optometry.path
  ];
});
