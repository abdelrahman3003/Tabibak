import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/doctor/data/remote_data/doctor_remote_data.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo_impl.dart';
import 'package:tabibak/features/doctor/presentaion/manager/comment/comment_states.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';

final doctorRepoProvider = StateProvider<DoctorRepo>(
  (ref) => DoctorRepoImpl(doctorRemoteData: DoctorRemoteData()),
);
final commentNotifierProvider =
    StateNotifierProvider.autoDispose<CommentProvider, CommentStates>(
  (ref) => CommentProvider(ref),
);

class CommentProvider extends StateNotifier<CommentStates> {
  CommentProvider(this.ref) : super(CommentStates());
  final Ref ref;

  void init(List<CommentModel> initialComments) {
    if (state.commentList == null || state.commentList!.isEmpty) {
      state = state.copyWith(commentList: initialComments);
    }
  }

  Future<void> addComment(CommentModel commentModel) async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(doctorRepoProvider).addComment(commentModel);

    result.when(
      sucess: (commentList) {
        state = state.copyWith(commentList: commentList);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
