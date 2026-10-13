import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/ratings_row.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/schedule_section.dart';
import 'package:tabibak/features/home/data/model/day_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/rating_model.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    ),
  );
}

void main() {
  group('DoctorModel.hasRating tests', () {
    test('hasRating returns false when ratingsCount and avrRating are null or zero and ratings empty', () {
      final doc1 = DoctorModel(doctorId: 'doc_1');
      expect(doc1.hasRating, isFalse);

      final doc2 = DoctorModel(
        doctorId: 'doc_2',
        avrRating: 0.0,
        ratingsCount: 0,
        ratings: [],
      );
      expect(doc2.hasRating, isFalse);
    });

    test('hasRating returns true when doctor has rating, ratingsCount, or ratings list', () {
      final doc1 = DoctorModel(
        doctorId: 'doc_1',
        avrRating: 4.5,
        ratingsCount: 12,
      );
      expect(doc1.hasRating, isTrue);

      final doc2 = DoctorModel(
        doctorId: 'doc_2',
        ratings: [RatingModel(doctorId: 'doc_2', rate: 5)],
      );
      expect(doc2.hasRating, isTrue);
    });
  });

  group('RatingsRow widget tests', () {
    testWidgets('renders SizedBox.shrink when rate or ratingCount is null or 0', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const RatingsRow(rate: null, ratingCount: null)),
      );
      expect(find.byType(Icon), findsNothing);

      await tester.pumpWidget(
        _buildTestApp(const RatingsRow(rate: 0, ratingCount: 0)),
      );
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('renders star icons when rate and ratingCount are positive', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const RatingsRow(rate: 4.5, ratingCount: 8)),
      );
      expect(find.byType(Icon), findsNWidgets(5));
      expect(find.textContaining('8'), findsOneWidget);
    });
  });

  group('ScheduleSection widget tests', () {
    testWidgets('displays "Working days unknown" when workingDayList is null or empty', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const ScheduleSection(workingDayList: null)),
      );
      expect(find.text('Working days unknown'), findsOneWidget);

      await tester.pumpWidget(
        _buildTestApp(const ScheduleSection(workingDayList: [])),
      );
      expect(find.text('Working days unknown'), findsOneWidget);
    });

    testWidgets('displays "Working days unknown" when workingDayList has no valid shift hours', (tester) async {
      final workdayWithoutHours = WorkingDay(
        id: 1,
        day: DayModel(id: 1, dayEn: 'Sunday', dayAr: 'الأحد'),
        isSelected: true,
        shiftMorning: ShiftModel(id: 1, start: '', end: ''),
      );

      await tester.pumpWidget(
        _buildTestApp(ScheduleSection(workingDayList: [workdayWithoutHours])),
      );
      expect(find.text('Working days unknown'), findsOneWidget);
    });

    testWidgets('displays schedule when valid shift hours exist', (tester) async {
      final workdayWithHours = WorkingDay(
        id: 1,
        day: DayModel(id: 1, dayEn: 'Sunday', dayAr: 'الأحد'),
        isSelected: true,
        shiftMorning: ShiftModel(id: 1, start: '09:00:00', end: '17:00:00'),
      );

      await tester.pumpWidget(
        _buildTestApp(ScheduleSection(workingDayList: [workdayWithHours])),
      );
      expect(find.text('Working days unknown'), findsNothing);
    });
  });
}
