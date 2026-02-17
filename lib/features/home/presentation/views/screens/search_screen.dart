import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/search_bar_widget.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/search_screen/search_card_list_states.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  TextEditingController? searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProviderNotifier.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProviderNotifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.hBox,
              SearchBarWidget(
                controller: searchController,
                onChanged: _onSearchChanged,
              ),
              16.hBox,
              if (!state.isLoading)
                Text(
                  searchController!.text.isNotEmpty
                      ? AppStrings.searchResults
                      : AppStrings.recentSearches,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              Expanded(child: SearchCardListStates()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController?.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
