import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/dto/tourplanmodel.dart';
import 'package:guideme/page/tourplandetail.dart';
import 'package:guideme/services/database_services.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class TourPlans extends StatefulWidget {
  const TourPlans({super.key});

  static PreferredSizeWidget get tourPlanAppBar {
    return AppBar(
      title: Text(
        'Tour Plan',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 25,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      centerTitle: true,
      foregroundColor: Colors.white,
    );
  }

  @override
  State<TourPlans> createState() => _TourPlansState();
}

class _TourPlansState extends State<TourPlans> {
  Future<List<TourPlan>>? tourPlans;
  DateTime? pickedDate;

  final headerController = TextEditingController();
  final tourNameController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  @override
  void dispose() {
    super.dispose();
    headerController.dispose();
    tourNameController.dispose();
    locationController.dispose();
    // DBService.instance.close();
  }

  void refreshList() async {
    try {
      await DBService.instance.initDB();
      setState(() {
        tourPlans = DBService.instance.readAllTourPlan();
      });
    } catch (error) {
      debugPrint('Error fetching Tour Plan: $error');
    }
  }

  void pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
      initialDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        this.pickedDate = pickedDate;
      });
    }
  }

  void addTourPlan() {
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
                  controller: headerController,
                  decoration: const InputDecoration(
                    hintText: 'Tour Header',
                    // labelText: 'Tour Plan\'s Name',
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
                  controller: tourNameController,
                  decoration: const InputDecoration(
                    hintText: 'Tour Name',
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
                  controller: locationController,
                  decoration: const InputDecoration(
                    hintText: 'Tour Location',
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
                headerController.clear();
                tourNameController.clear();
                locationController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                TourPlan createdTourPlan =
                    await DBService.instance.createTourPlan(
                  TourPlan(
                    id: null,
                    header: headerController.text,
                    name: tourNameController.text,
                    location: locationController.text,
                  ),
                );
                refreshList();
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TourPlanDetail(
                    tourPlan: createdTourPlan,
                  ),
                ));
                headerController.clear();
                tourNameController.clear();
                locationController.clear();
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
          onPressed: addTourPlan,
          backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: const Icon(
            Icons.add,
            size: 20,
          ),
          label: Text(
            'Add Tour Plan',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10) +
                  const EdgeInsets.only(bottom: 14),
              height: 70,
              color: Colors.blue,
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search here',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                future: tourPlans,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No Data'));
                  }
                  if (snapshot.hasData) {
                    return generateTourPlanList(snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget generateTourPlanList(List<TourPlan> tourPlans) {
    return ListView.separated(
      itemCount: tourPlans.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemBuilder: (context, index) {
        final tourPlan = tourPlans[index];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TourPlanDetail(tourPlan: tourPlan),
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(
              bottom: index == tourPlans.length - 1 ? 80 : 0,
            ),
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
                                DBService.instance.deleteTourPlan(tourPlan.id!);
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
              child: Container(
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
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(
                          Icons.flag,
                          color: Colors.white.withOpacity(0.9),
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          tourPlan.header!,
                          style: GoogleFonts.poppins(
                            color: const Color.fromRGBO(0, 0, 0, 0.451),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          tourPlan.name!,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
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
                              tourPlan.location!,
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
                              'Monday, April 8th, 2024',
                              style: GoogleFonts.poppins(
                                color: Colors.black45,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
