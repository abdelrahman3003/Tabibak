import 'package:flutter/material.dart';
import 'package:tabibak/features/pharamcy/data/models/pharamcy_employee_model.dart';

class EmployeeChip extends StatelessWidget {
  final PharmacyEmployeeModel employee;
  const EmployeeChip({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 70,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            backgroundImage:
                employee.image != null ? NetworkImage(employee.image!) : null,
            child: employee.image == null
                ? Icon(
                    Icons.person,
                    color: colorScheme.primary,
                  )
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            employee.name ?? '',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
