import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/dto/news.dart';
import 'package:guideme/services/data_services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TestApi extends StatefulWidget {
  const TestApi({super.key});

  @override
  State<TestApi> createState() => _TestApiState();
}

class _TestApiState extends State<TestApi> {
  Future<List<News>>? _news;

  Future<List<News>> searchData() {
    if (_searchController.text.isEmpty) {
      return DataService.fetchNews();
    } else {
      return DataService.fetchNews().then((news) => news
          .where((newsData) => newsData.title
              .trim()
              .toLowerCase()
              .contains(_searchController.text.trim().toLowerCase()))
          .toList());
    }
  }

  @override
  void initState() {
    _news = searchData();
    super.initState();
  }

  bool search = false;

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void editAPI(News post) {
    _titleController.text = post.title;
    _bodyController.text = post.body;
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Title'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Body'),
                  hintText: 'Body'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DataService.editNews(
                        _titleController.text, _bodyController.text, post.id);

                    await Future.delayed(const Duration(milliseconds: 100));
                    setState(() {
                      _news = DataService.fetchNews();
                    });
                    Navigator.of(context).pop();
                    _titleController.clear();
                    _bodyController.clear();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 10,),
                      Text('Update')
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void postAPI() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Title'),
                hintText: 'Title',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Body'),
                  hintText: 'Body'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      DataService.postNews(
                          _titleController.text, _bodyController.text);

                      await Future.delayed(const Duration(milliseconds: 100));
                      setState(() {
                        _news = DataService.fetchNews();
                      });
                      Navigator.of(context).pop();
                      _titleController.clear();
                      _bodyController.clear();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 10,),
                        Text('Create News')
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showAPIDetail(News post) {
    setState(() {
      showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => SizedBox(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      post.photo,
                      width: 340,
                      height: 260,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DetailCardFormat(
                    keys: 'Title',
                    value: post.title,
                  ),
                  DetailCardFormat(
                    keys: 'Body',
                    value: post.body,
                  ),
                  DetailCardFormat(
                    keys: 'ID Category',
                    value: post.idCategory.toString(),
                  ),
                  DetailCardFormat(
                    keys: 'ID',
                    value: post.id,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: postAPI,
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          'API Screen',
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
                      onChanged: (value) {
                        setState(() {
                          _news = searchData();
                        });
                      },
                      controller: _searchController,
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
                      onPressed: () {
                        setState(() {
                          _news = searchData();
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder<List<News>>(
              future: _news,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data![index];
                        return Container(
                          margin: EdgeInsets.only(
                              bottom:
                                  index == snapshot.data!.length - 1 ? 80 : 0),
                          child: Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 0.5,
                              motion: const ScrollMotion(),
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            setState(() {
                                              editAPI(post);
                                            });
                                          },
                                          flex: 1,
                                          icon: Icons.edit,
                                          backgroundColor: Colors.green,
                                          label: 'Update',
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          padding: const EdgeInsets.all(15),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SlidableAction(
                                          onPressed: (context) async {
                                            DataService.deleteNews(post.id);
                                            await Future.delayed(const Duration(
                                                milliseconds: 100));
                                            setState(() {
                                              _news = DataService.fetchNews();
                                            });
                                            _titleController.clear();
                                            _bodyController.clear();
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
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              minVerticalPadding: 5,
                              onTap: () {
                                showAPIDetail(post);
                              },
                              title: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.green,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(width: 0.6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          post.photo,
                                          width: 90,
                                          height: 60,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          post.title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Padding(padding: EdgeInsets.only(top: 300), child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCardFormat extends StatelessWidget {
  const DetailCardFormat({
    super.key,
    required this.keys,
    required this.value,
  });

  final String keys;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                keys,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                ':',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
