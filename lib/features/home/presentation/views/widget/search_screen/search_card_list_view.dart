import 'package:flutter/material.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/search_screen/search_card.dart';

class SearchCardListView extends StatelessWidget {
  const SearchCardListView(
      {super.key, required this.searchDoctorList, required this.onItemTap});
  final List<DoctorModel> searchDoctorList;
  final void Function(int index) onItemTap;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => SearchCard(
        onTap: () {
          onItemTap(index);
        },
        doctorSummary: searchDoctorList[index],
      ),
      separatorBuilder: (context, index) => Divider(
        height: 4,
        color: Theme.of(context).colorScheme.secondary,
      ),
      itemCount: searchDoctorList.length,
      padding: EdgeInsets.zero,
    );
  }
}
