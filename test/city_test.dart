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

    test('ClinicAddressModel.getLocation returns localized village name in en and ar', () {
      final address = ClinicAddressModel(
        governorate: CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena'),
        markaz: CityModel(id: 2, nameAr: 'دشنا', nameEn: 'Dishna'),
        village: CityModel(id: 3, nameAr: 'أبو مناع بحري', nameEn: 'Abu Manna Bahri'),
      );

      expect(address.getLocation('en'), 'Abu Manna Bahri');
      expect(address.getLocation('ar'), 'أبو مناع بحري');
      expect(address.getLocation(), 'أبو مناع بحري');
    });

    test('ClinicAddressModel.getLocation returns localized markaz if village is null', () {
      final address = ClinicAddressModel(
        governorate: CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena'),
        markaz: CityModel(id: 2, nameAr: 'دشنا', nameEn: 'Dishna'),
        village: null,
      );

      expect(address.getLocation('en'), 'Dishna');
      expect(address.getLocation('ar'), 'دشنا');
      expect(address.getLocation(), 'دشنا');
    });

    test('ClinicAddressModel.getLocation returns localized governorate if only governorate is present', () {
      final address = ClinicAddressModel(
        governorate: CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena'),
        markaz: null,
        village: null,
      );

      expect(address.getLocation('en'), 'Qena');
      expect(address.getLocation('ar'), 'قنا');
      expect(address.getLocation(), 'قنا');
    });
  });
}
