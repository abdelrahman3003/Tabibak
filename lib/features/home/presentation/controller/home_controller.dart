import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/gen/assets.gen.dart';

final indexScreenProvider = StateProvider<int>((ref) {
  return 0;
});
final categoryListNameProvider = StateProvider<List<String>>((ref) {
  return [
    "مخ",
    "انف واذن",
    "سنان",
    "عام",
    "عام",
    "عام",
  ];
});
final categoryListIconsProvider = StateProvider<List<String>>((ref) {
  return [
    Assets.asssets.images.kidneys1.path,
    Assets.asssets.images.manDoctor.path,
    Assets.asssets.images.brain1.path,
    Assets.asssets.images.iamge.path,
    Assets.asssets.images.iamge.path,
    Assets.asssets.images.iamge.path,
  ];
});
