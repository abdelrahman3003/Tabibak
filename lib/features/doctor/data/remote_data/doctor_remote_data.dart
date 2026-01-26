import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorRemoteData {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<DoctorModel> getDoctor(String doctorId) async {
    final response = await supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq("doctor_id", doctorId)
        .single();
    return DoctorModel.fromJson(response);
  }

  Future<List<CommentModel>> addComment({
    required CommentModel commentModel,
  }) async {
    await supabase.from('comments').insert(commentModel.toJson());

    final response = await supabase
        .from('comments')
        .select()
        .order('created_at', ascending: false)
        .limit(7);

    final commentList =
        response.map<CommentModel>((e) => CommentModel.fromJson(e)).toList();
    return commentList;
  }

  Future<void> addRate({required double rate, required int doctorId}) async {}
}
