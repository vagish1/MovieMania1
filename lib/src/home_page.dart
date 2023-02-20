import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:moviemania/src/web.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // getThroughApi();
    super.initState();
  }

  Future<List<dynamic>> getThroughApi() async {
    http.Response response =
        await http.post(Uri.parse("https://hoblist.com/api/movieList"), body: {
      "category": "movies",
      "language": "kannada",
      "genre": "all",
      "sort": "voting",
    });

    return json.decode(response.body)['result'] as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Movie Mania",
          style: Theme.of(context).textTheme.headline6!.merge(
                const TextStyle(
                  fontFamily: "Eculid",
                  fontWeight: FontWeight.w700,
                ),
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Container(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "About Company",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .merge(const TextStyle(
                                  fontFamily: "Euclid",
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          const ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.business_center_outlined,
                              ),
                            ),
                            title: Text("Company"),
                            subtitle: Text("Geeksynergy Technologies Pvt Ltd"),
                          ),
                          const ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.location_city_outlined,
                              ),
                            ),
                            title: Text("Address"),
                            subtitle: Text("Sanjayanagar, Bengaluru-56"),
                          ),
                          const ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.phone_outlined,
                              ),
                            ),
                            title: Text("Phone"),
                            subtitle: Text("XXXXXXXXX09"),
                          ),
                          const ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.email_outlined,
                              ),
                            ),
                            title: Text("Email"),
                            subtitle: Text("XXXXXX@gmail.com"),
                          ),
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bool isMale = false;
          bool isFemale = false;
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Selection();
              });
        },
        child: const Icon(
          Icons.select_all,
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: getThroughApi(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  separatorBuilder: (_, index) {
                    return const SizedBox(height: 24.0);
                  },
                  itemBuilder: (_, index) {
                    // print(DateTime.fromMillisecondsSinceEpoch(
                    //         snapshot.data!.elementAt(index)['releasedDate'])
                    //     );
                    return MovieItem(
                      title: snapshot.data!.elementAt(index)['title'],
                      duration: '',
                      image: snapshot.data!.elementAt(index)['poster'],
                      genre: snapshot.data!.elementAt(index)['genre'],
                      language: snapshot.data!.elementAt(index)['language'],
                      directors: getDirector(
                          snapshot.data!.elementAt(index)['director']),
                      starring:
                          getStarring(snapshot.data!.elementAt(index)['stars']),
                      downVoted: ((snapshot.data!.elementAt(index)['voted'][0]
                              ['downVoted'] as List<dynamic>)
                          .length),
                      upVoted: ((snapshot.data!.elementAt(index)['voted'][0]
                              ['upVoted'] as List<dynamic>)
                          .length),
                      pageview:
                          "${snapshot.data!.elementAt(index)['pageViews']}",
                      totalVotes: snapshot.data!.elementAt(index)['totalVoted'],
                    );
                  },
                  itemCount: snapshot.data!.length);
            }

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    "Fetching Data",
                    style: Theme.of(context).textTheme.headline6!.merge(
                          const TextStyle(
                            fontFamily: "Euclid",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Please wait while we fetch data for you",
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                          const TextStyle(fontFamily: "Euclid"),
                        ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  String getDirector(List<dynamic> lst) {
    String directors = "";
    lst.forEach((element) {
      directors += "$element, ";
    });
    return directors;
  }

  String getStarring(List<dynamic> lst) {
    String stars = "";
    lst.forEach((element) {
      stars += "$element, ";
    });
    return stars;
  }
}

class MovieItem extends StatefulWidget {
  final String image;
  final String title;
  final String genre;
  final String duration;
  final String language;
  final int upVoted;
  final int downVoted;
  final String directors;
  final String starring;
  final String pageview;
  final int totalVotes;

  const MovieItem({
    Key? key,
    required this.image,
    required this.title,
    required this.genre,
    required this.duration,
    required this.language,
    required this.upVoted,
    required this.downVoted,
    required this.directors,
    required this.starring,
    required this.pageview,
    required this.totalVotes,
  }) : super(key: key);

  @override
  State<MovieItem> createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  int fakeUpVote = 0;
  int fakeDownVote = 0;

  @override
  void initState() {
    fakeUpVote = widget.upVoted;
    fakeDownVote = widget.downVoted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              spreadRadius: 8.0,
              color: Colors.grey.shade100,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: RepaintBoundary(
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headline6!.merge(
                    const TextStyle(
                      fontFamily: "Euclid",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              "Genre : ${widget.genre}",
              style: const TextStyle(
                fontFamily: "Euclid",
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              "Director : ${widget.directors}",
              style: const TextStyle(
                fontFamily: "Euclid",
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              "Starring : ${widget.starring}",
              style: const TextStyle(
                fontFamily: "Euclid",
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              "View : ${widget.pageview}",
              style: const TextStyle(
                fontFamily: "Euclid",
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    backgroundColor:
                        Colors.blueAccent.shade100.withOpacity(0.1),
                  ),
                  onPressed: () {
                    fakeUpVote += 1;
                    setState(() {});
                  },
                  icon: const Icon(Icons.keyboard_arrow_up),
                  label: Text("$fakeUpVote"),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  widget.totalVotes.toString(),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    backgroundColor:
                        Colors.blueAccent.shade100.withOpacity(0.1),
                  ),
                  onPressed: () {
                    fakeDownVote += 1;
                    setState(() {});
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                  label: Text("$fakeDownVote"),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    backgroundColor: Colors.blueAccent,
                    elevation: 0,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text(
                    widget.language,
                    style: Theme.of(context).textTheme.button!.merge(
                          const TextStyle(
                            fontFamily: "Euclid",
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return MyWidget(
                    initialUrl: "https://www.geeksforgeeks.org/",
                  );
                }));
              },
              child: Text(
                "Watch Trailer",
                style: Theme.of(context).textTheme.button!.merge(
                      const TextStyle(
                        fontFamily: "Euclid",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaleCat extends StatefulWidget {
  const MaleCat({super.key});

  @override
  State<MaleCat> createState() => _MaleCatState();
}

class _MaleCatState extends State<MaleCat> {
  String shirtSize = "S";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DropdownButton(
              value: shirtSize,
              items: const [
                DropdownMenuItem(
                  value: "XXL",
                  child: Text("XXL"),
                ),
                DropdownMenuItem(
                  value: "XL",
                  child: Text("XL"),
                ),
                DropdownMenuItem(
                  value: "L",
                  child: Text("L"),
                ),
                DropdownMenuItem(
                  value: "M",
                  child: Text("M"),
                ),
                DropdownMenuItem(
                  value: "S",
                  child: Text("S"),
                ),
              ],
              onChanged: (size) {
                shirtSize = size!;
                setState(() {});
              })
        ],
      ),
    );
  }
}

class FemaleCat extends StatefulWidget {
  const FemaleCat({super.key});

  @override
  State<FemaleCat> createState() => _FemaleCatState();
}

class _FemaleCatState extends State<FemaleCat> {
  String stype = "Kurta";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(


        

        children: [
          DropdownButton(
              value: stype,
              items: const [
                DropdownMenuItem(
                  value: "Kurta",
                  child: Text("Kurta"),
                ),
                DropdownMenuItem(
                  value: "Saree",
                  child: Text("Saree"),
                ),
                DropdownMenuItem(
                  value: "Skirt",
                  child: Text("Skirt"),
                ),
                DropdownMenuItem(
                  value: "TopWear",
                  child: Text("TopWear"),
                ),
              ],
              onChanged: (type) {
                stype = type!;

                setState(() {});
              })
        ],
      ),
    );
  }
}

class Selection extends StatefulWidget {
  const Selection({super.key});

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  bool isMAle = true;

  String cat = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DropdownButton(
            value: cat,
            items: const [
              DropdownMenuItem(
                value: "Male",
                child: Text("Male"),
              ),
              DropdownMenuItem(
                value: "Female",
                child: Text("Female"),
              ),
            ],
            onChanged: (chane) {
              cat = chane!;
              setState(() {});
            },
          ),
          cat == "Male" ? MaleCat() : FemaleCat(),
        ],
      ),
    );
  }
}
