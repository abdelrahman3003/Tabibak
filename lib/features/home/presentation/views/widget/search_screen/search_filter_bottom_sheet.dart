import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_provider.dart';

void showSearchFilterBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _SearchFilterSheet());
}

class _SearchFilterSheet extends ConsumerStatefulWidget {
  const _SearchFilterSheet();
  @override
  ConsumerState<_SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends ConsumerState<_SearchFilterSheet> {
  int? specialty;
  int? governorate;
  int? markaz;

  @override
  void initState() {
    super.initState();
    final state = ref.read(searchProviderNotifier);
    specialty = state.specialtyId;
    governorate = state.governorateId;
    markaz = state.markazId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(searchProviderNotifier.notifier);
      if (governorate != null) notifier.loadMarkazes(governorate);
    });
  }

  List<DropdownMenuItem<int>> _items(
      Iterable<dynamic> values, String language) {
    return values
        .map<DropdownMenuItem<int>>((item) => DropdownMenuItem<int>(
              value: item.id as int?,
              child: Text(item.getName(language) as String),
            ))
        .toList();
  }

  Widget _field(String label, int? value, List<DropdownMenuItem<int>> items,
      ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        items: <DropdownMenuItem<int>>[
          DropdownMenuItem<int>(value: null, child: Text(AppStrings.all)),
          ...items,
        ],
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProviderNotifier);
    final language = Localizations.localeOf(context).languageCode;
    final specialtyItems = _items(state.specialties, language);
    final governorateItems = _items(state.governorates, language);
    final markazItems = _items(state.markazes, language);
    final notifier = ref.read(searchProviderNotifier.notifier);

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppStrings.filters,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _field(AppStrings.specialty, specialty, specialtyItems,
              (value) => setState(() => specialty = value)),
          _field(AppStrings.governorate, governorate, governorateItems,
              (value) {
            setState(() {
              governorate = value;
              markaz = null;
            });
            notifier.loadMarkazes(value);
          }),
          _field(AppStrings.markaz, markaz, markazItems, (value) {
            setState(() {
              markaz = value;
            });
          }),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: OutlinedButton(
              onPressed: () {
                notifier.applyFilters();
                Navigator.pop(context);
              },
              child: Text(AppStrings.clearFilter),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: FilledButton(
              onPressed: () {
                notifier.applyFilters(
                    specialtyId: specialty,
                    governorateId: governorate,
                    markazId: markaz);
                Navigator.pop(context);
              },
              child: Text(AppStrings.applyFilter),
            )),
          ]),
        ],
      )),
    ));
  }
}
