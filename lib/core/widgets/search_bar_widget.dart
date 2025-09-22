import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget(
      {super.key, this.controller, this.onChanged, this.onSubmitted});
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onSubmitted: onChanged,
      decoration: InputDecoration(
        hintText: ' ${AppStrings.searchDoctor}..',
        hintStyle: Theme.of(context).textTheme.bodyLarge,
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
