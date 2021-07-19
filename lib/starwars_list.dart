import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_list_view/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StarwarsListState();
}

class _StarwarsListState extends State<StarwarsList> {
  late bool _hasMore;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _defaultPeoplePerPageCount = 10;
  final StarwarsRepo _repo;
  late List<People> _people;
  final int _nextPageThreshold = 5;

  _StarwarsListState() : _repo = new StarwarsRepo();

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _people = [];
    fetchPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    if (_people.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              fetchPeople();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading people, tap to try agin"),
          ),
        ));
      }
    } else {
      return ListView.builder(
          itemCount: _people.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _people.length - _nextPageThreshold) {
              if (_pageNumber < 10) {
                fetchPeople();
              }
            }
            if (index == _people.length) {
              if (_error) {
                return Center(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _loading = true;
                      _error = false;
                      fetchPeople();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Error while loading people, tap to try agin"),
                  ),
                ));
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ));
              }
            }
            final People people = _people[index];
            return Card(
              child: Column(
                children: <Widget>[
                  Container(
                      width: 80,
                      height: 80,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        foregroundImage: NetworkImage(
                            'https://starwars-visualguide.com/assets/img/characters/${people.no}.jpg'),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('Name : ${people.name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                              'Height : ${people.height}     Mass : ${people.mass}',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14)),
                          Text(
                              'Gender : ${people.gender}      Birth of Year : ${people.birthYear}',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14)),
                        ],
                      )),
                ],
              ),
            );
          });
    }
    return Container();
  }

  Future<void> fetchPeople() async {
    try {
      var people = await _repo.fetchPeople(page: _pageNumber);
      List<People> fetchedPeople = people;
      setState(() {
        _hasMore = fetchedPeople.length == _defaultPeoplePerPageCount;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _people.addAll(fetchedPeople);
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }
}
