import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/logic/home_controller.dart';

void showRatingDialog(BuildContext context) {
  final ratingProvider = StateProvider<double>((ref) => 0);

  showDialog(
    context: context,
    builder: (_) => Consumer(
      builder: (context, ref, _) {
        final rating = ref.watch(ratingProvider);

        return AlertDialog(
          title: const Text("قيّم الدكتور"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => IconButton(
                icon: Icon(
                  Icons.star,
                  color: index < rating ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  ref.read(ratingProvider.notifier).state = index + 1.0;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(homeControllerPrvider.notifier).addRate(
                    rating, ref.read(homeControllerPrvider).doctorModel!.id);
                Navigator.pop(context);
              },
              child: const Text("إرسال"),
            ),
          ],
        );
      },
    ),
  );
}
