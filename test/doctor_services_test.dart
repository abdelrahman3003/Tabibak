import 'package:flutter_test/flutter_test.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/doctor_service_model.dart';

void main() {
  group('DoctorServiceModel and DoctorModel Services Parsing', () {
    test('parses doctor_services directly on doctor json', () {
      final json = {
        'doctor_id': 'doc_123',
        'name': 'Dr. Ahmed',
        'doctor_services': [
          {
            'id': 1,
            'doctor_id': 'doc_123',
            'name': 'Medical Examination',
            'name_ar': 'كشف باطنة',
            'name_en': 'General Checkup',
          },
          {
            'id': 2,
            'doctor_id': 'doc_123',
            'name': 'ECG',
            'name_ar': 'رسم قلب',
            'name_en': 'ECG',
          }
        ]
      };

      final doctor = DoctorModel.fromJson(json);
      expect(doctor.services, isNotNull);
      expect(doctor.services!.length, 2);
      expect(doctor.services![0].name, 'Medical Examination');
      expect(doctor.services![0].nameAr, 'كشف باطنة');
      expect(doctor.services![0].nameEn, 'General Checkup');
      expect(doctor.services![1].name, 'ECG');
    });

    test('aggregates doctor_services from clinic_data when not on top level', () {
      final json = {
        'doctor_id': 'doc_456',
        'name': 'Dr. Mona',
        'clinic_data': [
          {
            'id': 10,
            'clinic_name': 'Downtown Clinic',
            'doctor_services': [
              {
                'id': 1,
                'clinic_id': 10,
                'name': 'Teeth Cleaning',
                'name_ar': 'تنظيف أسنان',
              }
            ]
          },
          {
            'id': 11,
            'clinic_name': 'Uptown Clinic',
            'doctor_services': [
              {
                'id': 2,
                'clinic_id': 11,
                'name': 'Root Canal',
                'name_ar': 'علاج جذور',
              }
            ]
          }
        ]
      };

      final doctor = DoctorModel.fromJson(json);
      expect(doctor.services, isNotNull);
      expect(doctor.services!.length, 2);
      expect(doctor.services![0].name, 'Teeth Cleaning');
      expect(doctor.services![1].name, 'Root Canal');
    });

    test('DoctorServiceModel serialization and deserialization', () {
      final service = DoctorServiceModel(
        id: 5,
        doctorId: 'doc_1',
        clinicId: 12,
        name: 'Consultation',
        nameAr: 'استشارة',
        nameEn: 'Consultation',
      );

      final json = service.toJson();
      expect(json['id'], 5);
      expect(json['doctor_id'], 'doc_1');
      expect(json['clinic_id'], 12);
      expect(json['name'], 'Consultation');
      expect(json['name_ar'], 'استشارة');

      final fromJson = DoctorServiceModel.fromJson(json);
      expect(fromJson.id, 5);
      expect(fromJson.nameAr, 'استشارة');
    });
  });
}
