import 'package:flutter/widgets.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/filters_list/filter_item.dart';

class FilterList extends StatefulWidget {
  const FilterList({super.key, required this.filters});
  final List<String> filters;
  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  int? selectIndex;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => FilterItem(
        text: widget.filters[index],
        isActive: index == selectIndex,
        onTap: () {
          selectIndex = index;
          setState(() {});
        },
      ),
      separatorBuilder: (context, index) => 10.wBox,
      itemCount: widget.filters.length,
    );
  }
}
