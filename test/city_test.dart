import 'package:flutter_test/flutter_test.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';

void main() {
  group('CityModel and ClinicAddressFormatting Arabic location tests', () {
    test('CityModel.arabicName returns nameAr even in English context', () {
      final city = CityModel(
        id: 1,
        nameAr: 'دشنا',
        nameEn: 'Dishna',
        type: 'markaz',
      );

      expect(city.arabicName, 'دشنا');
    });

    test('ClinicAddressModel.getLocation returns Arabic village name in both en and ar', () {
      final address = ClinicAddressModel(
        governorate: CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena'),
        markaz: CityModel(id: 2, nameAr: 'دشنا', nameEn: 'Dishna'),
        village: CityModel(id: 3, nameAr: 'أبو مناع بحري', nameEn: 'Abu Manna Bahri'),
      );

      expect(address.getLocation('en'), 'أبو مناع بحري');
      expect(address.getLocation('ar'), 'أبو مناع بحري');
    });

    test('ClinicAddressModel.getLocation returns Arabic markaz if village is null', () {
      final address = ClinicAddressModel(
        governorate: CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena'),
        markaz: CityModel(id: 2, nameAr: 'دشنا', nameEn: 'Dishna'),
        village: null,
      );

      expect(address.getLocation('en'), 'دشنا');
      expect(address.getLocation('ar'), 'دشنا');
    });

    test('ClinicAddressModel.getLocation returns Arabic governorate if only governorate is present', () {
      final address = ClinicAddressModel(
        governorate: CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena'),
        markaz: null,
        village: null,
      );

      expect(address.getLocation('en'), 'قنا');
      expect(address.getLocation('ar'), 'قنا');
    });
  });
}
