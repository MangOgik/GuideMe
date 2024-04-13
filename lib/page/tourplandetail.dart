import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/dto/tourplandetailsmodel.dart';
import 'package:guideme/dto/tourplanmodel.dart';
import 'package:guideme/services/database_services.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TourPlanDetail extends StatefulWidget {
  const TourPlanDetail({super.key, required this.tourPlan});

  final TourPlan tourPlan;

  @override
  State<TourPlanDetail> createState() => _TourPlanDetailState();
}

class _TourPlanDetailState extends State<TourPlanDetail> {
  int timelineIndex = 10;
  Map<int, bool> visited = {};

  final activityController = TextEditingController();
  final descController = TextEditingController();
  final detailedLocationController = TextEditingController();

  Future<List<TourPlanDetails>>? tourPlanDetails;
  late List<TourPlanDetail> updatedTourPlanDetail = [];

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    try {
      await DBService.instance.initDB();
      setState(() {
        tourPlanDetails = DBService.instance.readAllTourPlanDetails();
      });
    } catch (error) {
      debugPrint('Error fetching Tour Plan Detail: $error');
    }
  }

  void addTourPlanDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Tour Plan'),
          content: SizedBox(
            height: 220,
            width: 285,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: activityController,
                  decoration: const InputDecoration(
                    hintText: 'Activity Name',
                    labelText: 'Activity Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    hintText: 'Mini Desc',
                    labelText: 'Mini Desc',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: detailedLocationController,
                  decoration: const InputDecoration(
                    hintText: 'Detailed Location',
                    labelText: 'Detailed Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                activityController.clear();
                descController.clear();
                detailedLocationController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await DBService.instance.createTourPlanDetails(TourPlanDetails(
                    id: null,
                    tourPlanID: widget.tourPlan.id!,
                    activity: activityController.text,
                    desc: descController.text,
                    detailLocation: detailedLocationController.text));
                refreshList();
                Navigator.pop(context);
                activityController.clear();
                descController.clear();
                detailedLocationController.clear();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 45,
        width: 140,
        child: FloatingActionButton.extended(
          onPressed: addTourPlanDetails,
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
                            widget.tourPlan.name!,
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
                            'Current Activity',
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
                            '-',
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
                            '-',
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
                            '-',
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  child: FutureBuilder(
                    future: tourPlanDetails,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: Text('No Data'));
                      }
                      if (snapshot.hasData) {
                        final filteredTourPlanDetails = snapshot.data!
                            .where((detail) =>
                                detail.tourPlanID == widget.tourPlan.id)
                            .toList();
                        if (filteredTourPlanDetails.isEmpty) {
                          return const Center(child: Text('No Activity'));
                        }
                        return generateTourPlanDetails(filteredTourPlanDetails);
                      }
                      return const CircularProgressIndicator();
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget generateTourPlanDetails(List<TourPlanDetails> tourPlanDetails) {
    return ListView.builder(
        itemCount: tourPlanDetails.length,
        itemBuilder: (context, index) {
          final visitedDestination = visited[index] ?? false;
          final tourPlanDetail = tourPlanDetails[index];
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                DBService.instance
                                    .deleteTourPlanDetails(tourPlanDetail.id!);
                                refreshList();
                              });
                            },
                            flex: 1,
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            label: 'Delete',
                            borderRadius: BorderRadius.circular(10),
                            padding: const EdgeInsets.all(15),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              child: TimelineTile(
                isFirst: index == 0 ? true : false,
                isLast: index == tourPlanDetails.length - 1 ? true : false,
                beforeLineStyle: LineStyle(
                    color:
                        visitedDestination ? Colors.blue : Colors.grey[300]!),
                indicatorStyle: IndicatorStyle(
                  width: 35,
                  color: visitedDestination
                      ? Colors.lightBlue[200]!
                      : Colors.grey[350]!,
                  iconStyle: visitedDestination
                      ? IconStyle(iconData: Icons.check, color: Colors.white)
                      : null,
                ),
                endChild: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: 90,
                  decoration: BoxDecoration(
                      // color: const Color.fromARGB(255, 217, 217, 217),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            tourPlanDetail.activity,
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          Text(
                            tourPlanDetail.desc,
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                          // const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                tourPlanDetail.detailLocation,
                                style: GoogleFonts.poppins(
                                  color: Colors.black45,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '08.00 WITA',
                                style: GoogleFonts.poppins(
                                  color: Colors.black45,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      (index == 0 && visited[index] != true ||
                              visited[index - 1] == true &&
                                  visited[index] != true &&
                                  visited[index + 1] != true)
                          ? SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    visited[index] = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: const Text('Done'),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
