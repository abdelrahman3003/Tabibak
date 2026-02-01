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
        .select(ApiConstants.getDoctors)
        .eq("doctor_id", doctorId)
        .single();
    return DoctorModel.fromJson(response);
  }

  Future<List<CommentModel>> addComment({
    required CommentModel commentModel,
  }) async {
    await supabase.client.from('comments').insert(commentModel.toJson());

    final response = await supabase.client
        .from('comments')
        .select("*,users(*)")
        .order('created_at', ascending: false);

    final commentList =
        response.map<CommentModel>((e) => CommentModel.fromJson(e)).toList();
    return commentList;
  }

  Future<void> addRate({required double rate, required int doctorId}) async {}
}
