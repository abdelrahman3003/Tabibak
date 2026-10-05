import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorRemoteData {
  final Supabase supabase;

  DoctorRemoteData({required this.supabase});

  Future<DoctorModel> getDoctor(String doctorId) async {
    final response = await supabase.client
        .from('doctors')
        .select(ApiConstants.getDoctorProfile)
        .eq("doctor_id", doctorId)
        .single();
    return DoctorModel.fromJson(response);
  }

  Future<List<CommentModel>?> addComment({
    required CommentModel commentModel,
  }) async {
    final userId = supabase.client.auth.currentUser?.id;
    if (userId == null) throw StateError('Please sign in to write a review.');
    final comment = commentModel.comment?.trim() ?? '';
    if (comment.isEmpty) throw ArgumentError('Review text is required.');

    await supabase.client.from('comments').insert({
      'comment': comment,
      'doctor_id': commentModel.doctorId,
      'user_id': userId,
    });
    final response = await supabase.client
        .from('comments')
        .select("*,users(*)")
        .eq("doctor_id", commentModel.doctorId!)
        .order('created_at', ascending: false);

    final commentList =
        response.map<CommentModel>((e) => CommentModel.fromJson(e)).toList();
    return commentList;
  }

  Future<void> addRate({
    required int rate,
    required String doctorId,
    required String? review,
  }) async {
    final userId = supabase.client.auth.currentUser?.id;
    if (userId == null) throw StateError('Please sign in to submit a review.');

    final existingRating = await supabase.client
        .from('ratings')
        .select('id')
        .eq('doctor_id', doctorId)
        .eq('user_id', userId)
        .limit(1)
        .maybeSingle();

    final ratingValues = {
      'doctor_id': doctorId,
      'user_id': userId,
      'rate': rate,
    };
    if (existingRating == null) {
      await supabase.client.from('ratings').insert(ratingValues);
    } else {
      await supabase.client
          .from('ratings')
          .update(ratingValues)
          .eq('id', existingRating['id']);
    }

    final normalizedReview = review?.trim();
    if (normalizedReview != null && normalizedReview.isNotEmpty) {
      await supabase.client.from('comments').insert({
        'doctor_id': doctorId,
        'user_id': userId,
        'comment': normalizedReview,
      });
    }
  }
}
