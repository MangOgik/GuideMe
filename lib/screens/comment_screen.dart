import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/comment_item.dart';
import 'package:guideme/cubit/comment/comment_cubit.dart';
import 'package:guideme/dto/tourguide.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.tourGuide});

  final TourGuide tourGuide;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommentCubit>().fetchComments(widget.tourGuide.tourguideId);
  }

  void refresh() {
    context.read<CommentCubit>().fetchComments(widget.tourGuide.tourguideId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, state) {
          final commentList = state.commentList;
          if (commentList.isEmpty) {
            return const Center(
              child: Text('No Review Yet'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async{
                refresh();
              },
              child: ListView.separated(
                itemCount: commentList.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  thickness: 5,
                ),
                itemBuilder: (context, index) {
                  final comment = commentList[index];
                  return CommentItem(
                    comment: comment,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
