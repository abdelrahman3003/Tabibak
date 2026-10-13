import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/screens/specialist_screen.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/filters_list/location_filter_bottom_sheet.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_offer_model.dart';

class MockHomeRepo implements HomeRepo {
  List<DoctorModel> doctorsList = [];
  List<CityModel> governoratesList = [
    CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena', type: 'governorate'),
  ];
  List<CityModel> markazesList = [
    CityModel(id: 10, nameAr: 'مركز قنا', nameEn: 'Qena', type: 'markaz'),
    CityModel(id: 9, nameAr: 'مركز دشنا', nameEn: 'Dishna', type: 'markaz'),
    CityModel(
        id: 7, nameAr: 'مركز نجع حمادي', nameEn: 'Nag Hammadi', type: 'markaz'),
  ];
  List<CityModel> villagesList = [
    CityModel(
        id: 49,
        nameAr: 'أبو مناع بحري',
        nameEn: 'Abu Manaa Bahri',
        type: 'village',
        parentId: 9),
    CityModel(
        id: 50,
        nameAr: 'أبو مناع قبلي',
        nameEn: 'Abu Manaa Qibli',
        type: 'village',
        parentId: 9),
    CityModel(
        id: 24,
        nameAr: 'أبنود',
        nameEn: 'Abnud',
        type: 'village',
        parentId: 10),
  ];

  @override
  Future<ApiResult<List<DoctorModel>>> getDoctorSpecialist({
    int? specialtyId,
    String? sortBy,
    int? markazId,
  }) async {
    var result = List<DoctorModel>.from(doctorsList);
    if (markazId != null) {
      result = result.where((d) {
        if (d.markazId == markazId) return true;
        final clinics = d.clinicList ?? (d.clinic != null ? [d.clinic!] : []);
        for (final c in clinics) {
          if (c.clinicAddresses != null) {
            for (final addr in c.clinicAddresses!) {
              if (addr.markazId == markazId || addr.markaz?.id == markazId) {
                return true;
              }
            }
          }
        }
        return false;
      }).toList();
    }
    if (sortBy == 'avg_rating') {
      result.sort((a, b) => (b.avrRating ?? 0).compareTo(a.avrRating ?? 0));
    }
    return ApiResult.sucess(result);
  }

  @override
  Future<ApiResult<List<CityModel>>> getGovernorates() async {
    return ApiResult.sucess(governoratesList);
  }

  @override
  Future<ApiResult<List<CityModel>>> getMarkazes() async {
    return ApiResult.sucess(markazesList);
  }

  @override
  Future<ApiResult<List<CityModel>>> getVillages({int? markazId}) async {
    if (markazId != null) {
      return ApiResult.sucess(
        villagesList.where((v) => v.parentId == markazId).toList(),
      );
    }
    return ApiResult.sucess(villagesList);
  }

  @override
  Future<ApiResult<List<DoctorModel>>> searchDoctor(String search,
      {int? specialtyId}) async {
    final result = doctorsList
        .where(
            (d) => (d.name ?? '').toLowerCase().contains(search.toLowerCase()))
        .toList();
    return ApiResult.sucess(result);
  }

  @override
  Future<ApiResult<UserModel>> getUserData() async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<List<SpecialtyModel>>> getSpecialties() async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<List<DoctorModel>>> geTopDoctors() async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<List<DoctorModel>>> fetchAllDoctors() async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<DoctorModel>> getDoctorId(String id) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<List<PharmacyOfferModel>>> getOffers(
          {int? specialtyId, String? sortBy}) async =>
      throw UnimplementedError();
}

void main() {
  group('DoctorModel markaz serialization tests', () {
    test('fromJson and toJson correctly handle markaz and markaz_id', () {
      final json = {
        'doctor_id': 'doc-123',
        'name': 'د. أحمد',
        'markaz_id': 9,
        'markaz': 'مركز دشنا',
      };

      final doctor = DoctorModel.fromJson(json);
      expect(doctor.doctorId, 'doc-123');
      expect(doctor.name, 'د. أحمد');
      expect(doctor.markazId, 9);
      expect(doctor.markaz, 'مركز دشنا');

      final serialized = doctor.toJson();
      expect(serialized['markaz_id'], 9);
      expect(serialized['markaz'], 'مركز دشنا');
    });
  });

  group('DoctorsSpecialtyProvider Location filtering and sorting tests', () {
    late MockHomeRepo mockRepo;
    late ProviderContainer container;

    final docDishnaVillage49 = DoctorModel(
      doctorId: 'dishna-village-doc',
      name: 'د. أبو مناع بحري',
      markazId: 9,
      markaz: 'مركز دشنا',
      avrRating: 4.5,
      clinicList: [
        ClinicModel(
          id: 1,
          clinicAddresses: [
            ClinicAddressModel(
              governorateId: 1,
              markazId: 9,
              villageId: 49,
            ),
          ],
        ),
      ],
    );

    final docDishnaVillage50 = DoctorModel(
      doctorId: 'dishna-village-50-doc',
      name: 'د. أبو مناع قبلي',
      markazId: 9,
      markaz: 'مركز دشنا',
      avrRating: 4.0,
      clinicList: [
        ClinicModel(
          id: 2,
          clinicAddresses: [
            ClinicAddressModel(
              governorateId: 1,
              markazId: 9,
              villageId: 50,
            ),
          ],
        ),
      ],
    );

    final docQena = DoctorModel(
      doctorId: 'qena-doc',
      name: 'د. قنا',
      markazId: 10,
      markaz: 'مركز قنا',
      avrRating: 4.8,
      clinicList: [
        ClinicModel(
          id: 3,
          clinicAddresses: [
            ClinicAddressModel(
              governorateId: 1,
              markazId: 10,
              villageId: 24,
            ),
          ],
        ),
      ],
    );

    setUp(() {
      mockRepo = MockHomeRepo();
      mockRepo.doctorsList = [
        docDishnaVillage49,
        docDishnaVillage50,
        docQena,
      ];

      container = ProviderContainer(
        overrides: [
          homeRepoProvider.overrideWith((ref) => mockRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('getSpecialtiesDoctors loads all doctors, governorates, markazes, and villages',
        () async {
      final notifier = container.read(doctorsSpecialtyProvider.notifier);
      await notifier.loadLocations();
      await notifier.getSpecialtiesDoctors(specialtyId: 1);

      final state = container.read(doctorsSpecialtyProvider);
      expect(state.specialtyDoctors?.length, 3);
      expect(state.selectedGovernorateId, isNull);
      expect(state.selectedMarkazId, isNull);
      expect(state.selectedVillageId, isNull);
      expect(state.hasLocationFilter, false);
      expect(state.isHighestRated, false);
      expect(state.governorates.isNotEmpty, true);
      expect(state.markazes.isNotEmpty, true);
      expect(state.villages.isNotEmpty, true);
    });

    test('filterByLocation filters by markaz and village correctly', () async {
      final notifier = container.read(doctorsSpecialtyProvider.notifier);
      await notifier.getSpecialtiesDoctors(specialtyId: 1);

      // 1. Filter by Markaz 9 (Dishna)
      notifier.filterByLocation(markazId: 9);
      var state = container.read(doctorsSpecialtyProvider);
      expect(state.hasLocationFilter, true);
      expect(state.selectedMarkazId, 9);
      expect(state.selectedVillageId, isNull);
      expect(state.specialtyDoctors?.length, 2);
      expect(
        state.specialtyDoctors?.map((d) => d.doctorId),
        containsAll(['dishna-village-doc', 'dishna-village-50-doc']),
      );

      // 2. Filter by Markaz 9 + Village 49 (Abu Manaa Bahri)
      notifier.filterByLocation(markazId: 9, villageId: 49);
      state = container.read(doctorsSpecialtyProvider);
      expect(state.selectedVillageId, 49);
      expect(state.specialtyDoctors?.length, 1);
      expect(state.specialtyDoctors?.first.doctorId, 'dishna-village-doc');

      // 3. Filter by Village 50 (Abu Manaa Qibli)
      notifier.filterByLocation(markazId: 9, villageId: 50);
      state = container.read(doctorsSpecialtyProvider);
      expect(state.selectedVillageId, 50);
      expect(state.specialtyDoctors?.length, 1);
      expect(state.specialtyDoctors?.first.doctorId, 'dishna-village-50-doc');
    });

    test('clearLocationFilter restores all doctors', () async {
      final notifier = container.read(doctorsSpecialtyProvider.notifier);
      await notifier.getSpecialtiesDoctors(specialtyId: 1);

      notifier.filterByLocation(markazId: 9, villageId: 49);
      expect(
          container.read(doctorsSpecialtyProvider).specialtyDoctors?.length, 1);

      notifier.clearLocationFilter();
      final state = container.read(doctorsSpecialtyProvider);
      expect(state.hasLocationFilter, false);
      expect(state.selectedGovernorateId, isNull);
      expect(state.selectedMarkazId, isNull);
      expect(state.selectedVillageId, isNull);
      expect(state.specialtyDoctors?.length, 3);
    });

    test('toggleSortByRating sorts current filtered doctors by rating descending',
        () async {
      final notifier = container.read(doctorsSpecialtyProvider.notifier);
      await notifier.getSpecialtiesDoctors(specialtyId: 1);

      // Filter by Markaz 9 (has docs with rating 4.5 and 4.0)
      notifier.filterByLocation(markazId: 9);
      notifier.toggleSortByRating();

      final state = container.read(doctorsSpecialtyProvider);
      expect(state.isHighestRated, true);
      expect(state.specialtyDoctors?.length, 2);
      expect(state.specialtyDoctors?.first.doctorId, 'dishna-village-doc'); // 4.5
      expect(state.specialtyDoctors?.last.doctorId, 'dishna-village-50-doc'); // 4.0
    });
  });

  group('SpecialistScreen UI tests', () {
    testWidgets(
        'renders filter icon next to search bar and no old filter chips',
        (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockRepo = MockHomeRepo();
      mockRepo.doctorsList = [];

      final container = ProviderContainer(
        overrides: [
          homeRepoProvider.overrideWith((ref) => mockRepo),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(1000, 800),
            builder: (context, child) => const MaterialApp(
              locale: Locale('ar'),
              supportedLocales: [Locale('ar'), Locale('en')],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: SpecialistScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify filter icon button exists next to search bar
      expect(find.byKey(const Key('specialty_filter_icon_button')), findsOneWidget);

      // Verify old filter chips do NOT exist on the screen
      expect(find.text(AppStrings.lowestPrice), findsNothing);
      expect(find.text(AppStrings.filterByLocation), findsNothing);
      expect(find.text('مركز قنا'), findsNothing);
    });

    testWidgets('tapping filter icon opens bottom sheet with location filter and no highest rated filter',
        (tester) async {
      final mockRepo = MockHomeRepo();
      mockRepo.doctorsList = [];

      final container = ProviderContainer(
        overrides: [
          homeRepoProvider.overrideWith((ref) => mockRepo),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => const MaterialApp(
              home: SpecialistScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the filter icon button next to search bar
      await tester.tap(find.byKey(const Key('specialty_filter_icon_button')));
      await tester.pumpAndSettle();

      // Verify Bottom sheet appears
      expect(find.byType(LocationFilterBottomSheet), findsOneWidget);

      // Verify highest rated filter section does NOT exist
      expect(find.text(AppStrings.highestRated), findsNothing);

      // Verify governorate section exists
      expect(find.text(AppStrings.governorate), findsOneWidget);

      // Verify markaz section exists
      expect(find.text(AppStrings.markaz), findsOneWidget);

      // Verify village section exists
      expect(find.text(AppStrings.village), findsOneWidget);

      // Verify Apply Filter and Clear Filter buttons exist
      expect(find.text(AppStrings.applyFilter), findsOneWidget);
      expect(find.text(AppStrings.clearFilter), findsOneWidget);
    });

    test('CityModel localizes governorate, markaz, and village in Arabic and English', () {
      final gov = CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena', type: 'governorate');
      final markaz = CityModel(id: 9, nameAr: 'مركز دشنا', nameEn: 'Dishna', type: 'markaz');
      final village = CityModel(id: 49, nameAr: 'أبو مناع بحري', nameEn: 'Abu Manaa Bahri', type: 'village');

      // Arabic
      expect(gov.getName('ar'), 'قنا');
      expect(markaz.getName('ar'), 'مركز دشنا');
      expect(village.getName('ar'), 'أبو مناع بحري');

      // English
      expect(gov.getName('en'), 'Qena');
      expect(markaz.getName('en'), 'Dishna');
      expect(village.getName('en'), 'Abu Manaa Bahri');
    });

    testWidgets('SpecialistScreen renders filter icon next to search bar and opens bottom sheet with localized names',
        (tester) async {
      final mockRepo = MockHomeRepo();
      mockRepo.doctorsList = [];

      final container = ProviderContainer(
        overrides: [
          homeRepoProvider.overrideWith((ref) => mockRepo),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => const MaterialApp(
              locale: Locale('en'),
              home: SpecialistScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify filter icon button next to search bar exists
      final filterBtn = find.byKey(const Key('specialty_filter_icon_button'));
      expect(filterBtn, findsOneWidget);

      // Tap filter button
      await tester.tap(filterBtn);
      await tester.pumpAndSettle();

      // Verify bottom sheet opened
      expect(find.byType(LocationFilterBottomSheet), findsOneWidget);

      // Verify English names are displayed when locale is 'en'
      expect(find.text('Qena'), findsWidgets);
      expect(find.text('Dishna'), findsWidgets);
    });

    test('Localization files contain governorate and markaz translations in Arabic and English', () {
      final arFile = File('assets/langs/ar.json');
      final enFile = File('assets/langs/en.json');

      expect(arFile.existsSync(), isTrue);
      expect(enFile.existsSync(), isTrue);

      final arMap = jsonDecode(arFile.readAsStringSync()) as Map<String, dynamic>;
      final enMap = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;

      // Arabic localization assertions
      expect(arMap['governorate'], 'المحافظة');
      expect(arMap['markaz'], 'المركز');
      expect(arMap['allGovernorates'], 'كل المحافظات');
      expect(arMap['allMarkazes'], 'كل المراكز');

      // English localization assertions
      expect(enMap['governorate'], 'Governorate');
      expect(enMap['markaz'], 'Markaz');
      expect(enMap['allGovernorates'], 'All Governorates');
      expect(enMap['allMarkazes'], 'All Markazes');
    });
  });
}
