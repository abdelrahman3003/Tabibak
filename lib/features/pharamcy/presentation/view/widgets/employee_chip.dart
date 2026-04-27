import 'package:flutter/material.dart';
import 'package:tabibak/features/pharamcy/data/models/pharamcy_employee_model.dart';

class EmployeeChip extends StatelessWidget {
  final PharmacyEmployeeModel employee;

  const EmployeeChip({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFFE8F4FD),
          backgroundImage:
              employee.image != null ? NetworkImage(employee.image!) : null,
          child: employee.image == null
              ? const Icon(Icons.person, color: Color(0xFF2D7DD2))
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          employee.name ?? '',
          style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
