part of 'comment_cubit.dart';

@immutable
class CommentState {
  final List<Comment> commentList;
  const CommentState({required this.commentList});
}

final class CommentInitial extends CommentState {
  CommentInitial() : super(commentList: []);
}
