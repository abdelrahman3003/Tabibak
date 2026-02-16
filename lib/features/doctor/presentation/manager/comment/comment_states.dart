import 'package:tabibak/features/home/data/model/comment_model.dart';

class CommentStates {
  final bool isLoading;
  final String? errorMessage;

  final List<CommentModel>? commentList;
  CommentStates({
    this.commentList,
    this.errorMessage,
    this.isLoading = false,
  });
  CommentStates copyWith({
    final bool? isLoading,
    final String? errorMessage,
    final List<CommentModel>? commentList,
  }) {
    return CommentStates(
      isLoading: isLoading ?? false,
      commentList: commentList ?? this.commentList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
