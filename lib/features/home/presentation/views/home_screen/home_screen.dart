import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "aaaaaaaaaaaaaaa",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          // SliverToBoxAdapter(
          //     child: Text("التخصص", style: Apptextstyles.font20BlackRegular)),
          // SliverToBoxAdapter(child: SizedBox(height: 15)),
          // SliverToBoxAdapter(child: CategoriesList()),
          // SliverToBoxAdapter(child: SizedBox(height: 20)),
          // SliverToBoxAdapter(
          //     child: Text("الدكتور", style: Apptextstyles.font20BlackRegular)),
          // SliverToBoxAdapter(child: SizedBox(height: 20)),
          // DoctorList()
        ],
      ),
    );
  }
}
