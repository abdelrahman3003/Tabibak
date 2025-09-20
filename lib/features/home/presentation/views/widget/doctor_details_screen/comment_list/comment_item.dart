import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.comment});
  final String comment;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.comment, color: AppColors.primary),
      title: Text(
        comment,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
