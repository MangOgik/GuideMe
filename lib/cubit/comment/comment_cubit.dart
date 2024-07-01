import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:guideme/dto/comment.dart';
import 'package:guideme/services/data_services.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

    Future<void> fetchComments(String userId) async {
    try {
      debugPrint("Processing tourplans data..");
      List<Comment> comments;
      comments = await DataService.fetchComment(userId);
      emit(CommentState(commentList: comments));
    } catch (e) {
      debugPrint("Error fetched data: $e");
    }
  }
}
