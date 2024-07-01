import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/custom_alert_dialog.dart';
import 'package:guideme/cubit/activity/activity_cubit.dart';
import 'package:guideme/dto/activity.dart';
import 'package:guideme/dto/tourplan.dart';
import 'package:guideme/services/data_services.dart';
import 'package:guideme/utils/constants.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TourPlanDetailScreen extends StatefulWidget {
  const TourPlanDetailScreen(
      {super.key, required this.tourPlan, required this.isCustomer});

  final TourPlan tourPlan;
  final bool isCustomer;

  @override
  State<TourPlanDetailScreen> createState() => _TourPlanDetailState();
}

class _TourPlanDetailState extends State<TourPlanDetailScreen> {
  int timelineIndex = 10;
  Map<int, bool> visited = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final activityTitleController = TextEditingController();
  final descController = TextEditingController();

  Future<List<Activity>>? tourPlanDetails;
  late List<Activity> updatedTourPlanDetail = [];

  @override
  void initState() {
    super.initState();
    context.read<ActivityCubit>().fetchActivity(widget.tourPlan.tourplanId);
  }

  void postActivity() async {
    final response = await DataService.postActivity(
      tourplanId: widget.tourPlan.tourplanId,
      activityTitle: activityTitleController.text,
      miniDesc: descController.text,
    );
    fetchActivity();

    if (response.statusCode == 201) {
    } else {}
  }

  void fetchActivity() {
    context.read<ActivityCubit>().fetchActivity(widget.tourPlan.tourplanId);
  }

  void addActivity() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Activity'),
          content: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SizedBox(
              height: 190,
              width: 285,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: activityTitleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter activity title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Activity Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                activityTitleController.clear();
                descController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  postActivity();
                  activityTitleController.clear();
                  descController.clear();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Activity Created'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showConfirmDialog(String idActivity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Delete Activity?',
          description: 'Are you sure you want to delete this activity?',
          cancelButtonText: 'Cancel',
          okButtonText: 'Delete',
          isWarning: false,
          isDelete: true,
          onCancel: () {
            Navigator.of(context).pop();
          },
          onOk: () {
            deleteActivity(idActivity);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Activity Deleted'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  void deleteActivity(String idActivity) async {
    await DataService.deleteActivity(idActivity);
    fetchActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 45,
        width: 140,
        child: FloatingActionButton.extended(
          onPressed: addActivity,
          backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: const Icon(
            Icons.add,
            size: 20,
          ),
          label: Text(
            'Add Activity',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Tour Plan Details',
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
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Text(
                            'Tour Plan Name',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Text(
                            ':',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.tourPlan.tourplanName,
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Text(
                            'Location',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Text(
                            ':',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.tourPlan.locationName,
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Text(
                            'Date',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Text(
                            ':',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            dateFormatter.format(widget.tourPlan.tourplanDate),
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    widget.isCustomer
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Text(
                                  'Assigned Guide',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                                child: Text(
                                  ':',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  widget.tourPlan.tourguideName,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
            const Divider(
              height: 10,
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<ActivityCubit, ActivityState>(
                    builder: (context, state) {
                      final listActivity = state.activityList;
                      if (listActivity.isEmpty) {
                        return const Center(
                            child: Text('No Activity Planned Yet'));
                      } else {
                        return ListView.builder(
                          itemCount: listActivity.length,
                          itemBuilder: (context, index) {
                            final activity = listActivity[index];
                            return SizedBox(
                              height: 100,
                              child: Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.25,
                                  motion: const ScrollMotion(),
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) {
                                                showConfirmDialog(
                                                    activity.activityId);
                                              },
                                              flex: 1,
                                              icon: Icons.delete,
                                              backgroundColor: Colors.red,
                                              label: 'Delete',
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              padding: const EdgeInsets.all(15),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                child: TimelineTile(
                                  isFirst: true,
                                  isLast: true,
                                  indicatorStyle: IndicatorStyle(
                                    width: 35,
                                    color: activity.activityCompleted
                                        ? Colors.lightBlue[200]!
                                        : Colors.grey[350]!,
                                    iconStyle: activity.activityCompleted
                                        ? IconStyle(
                                            iconData: Icons.check,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  endChild: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    height: 95,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              activity.activityTitle,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              height: 40,
                                              child: Text(activity.description),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        (!activity.activityCompleted)
                                            ? SizedBox(
                                                height: 40,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await DataService
                                                        .completeActivity(
                                                            activity
                                                                .activityId);
                                                    fetchActivity();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                  child: const Text('Done'),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 40,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await DataService
                                                        .completeActivity(
                                                            activity
                                                                .activityId);
                                                    fetchActivity();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                  child: const Text('Un-Done'),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
