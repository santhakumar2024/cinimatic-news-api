import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
class playmovie {
  late String original_title;
  late String overview;
  late String poster_path;
  playmovie(this.original_title,this.overview,this.poster_path);
  playmovie.fromJson(Map<String, dynamic> json) {
    original_title= json['original_title'];
    overview =json['overview'];
    poster_path = json['poster_path'];

  }
}
class Toprated extends StatefulWidget {
  @override
  _HomePageStates createState() => _HomePageStates();
}
class _HomePageStates extends State<Toprated> {
  late List data;
  bool reverseSort = false;
  late ScrollController  scrollController;
  bool ontop = true;
  List<playmovie> values = <playmovie>[];
  List<playmovie> SearchDisplay = <playmovie>[];
  Future<List<playmovie>> getData() async {
    final String endPointUrl =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed";
    var response = await http.get(Uri.parse(endPointUrl));
    var notes = <playmovie>[];
    if (response.statusCode == 200) {
      data = json.decode(response.body)['results'];
      print("data for the jSON");

       print(data);
      for (var noteJson in data) {
        notes.add(playmovie.fromJson(noteJson));
      }
      notes.sort((a, b) {
        return a.original_title.toLowerCase().compareTo(
            b.original_title.toLowerCase());
      });
    }
    return notes;
  }

  @override
  void initState() {
    getData().then((value) {
      setState(() {
        values.addAll(value);
        SearchDisplay = values;
      });
    });
    super.initState();
  }
  void Sort() {
    setState(() {
      reverseSort = ! reverseSort;
      SearchDisplay.sort((playmovie a,  playmovie b) => reverseSort
          ? b.original_title.compareTo(a.original_title)
          : a.original_title.compareTo(b.original_title));
    });
  }
  @override
  Widget build(BuildContext context) {
    if(data == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [0, 1, 2, 3, 4, 5, 6, 7]
                .map((_) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48.0, height: 48.0, color: Colors.white,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: double.infinity,
                            height: 8.0,
                            color: Colors.white,),
                          Padding(padding: const EdgeInsets.symmetric(
                              vertical: 2.0),),
                          Container(width: double.infinity,
                            height: 8.0,
                            color: Colors.white,),
                          Padding(padding: const EdgeInsets.symmetric(
                              vertical: 2.0),),
                          Container(
                            width: 40.0, height: 8.0, color: Colors.white,),
                        ],
                      ),
                      )
                    ],
                  ),
                ))
                .toList(),
          ),
        ),
      );
    }
    else {
      return Scaffold(
        body:SingleChildScrollView(
        child:Stack(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 85),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child:
            new ListView.builder(
              itemBuilder: (context, index) {
                return Dismissible(
                    direction: DismissDirection.startToEnd,
                    resizeDuration: Duration(milliseconds: 200),
                    key: ObjectKey(SearchDisplay.elementAt(index)),
                    onDismissed: (direction) {
                      _deleteMessage(index);
                    },
                    background: Container(
                      padding: EdgeInsets.only(left: 28.0),
                      alignment: AlignmentDirectional.centerStart,
                      color: Colors.white,
                      child: Icon(Icons.delete_forever, color: Colors.black,),
                    ),
                child: InkWell(
                  onTap: () {

                  },
                  child: Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3.0,
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage("https://image.tmdb.org/t/p/w342" + SearchDisplay[index].poster_path), fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text(
                            SearchDisplay[index].original_title,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          SearchDisplay[index].overview,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ));
              },itemCount: SearchDisplay.length ,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        onChanged: (text) {
                          text = text.toLowerCase();
                          setState(() {
                            SearchDisplay = values.where((note) {
                              var noteTitle = note.original_title.toLowerCase();
                              return noteTitle.contains(text);
                            }).toList();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child:  Center(child:Text(SearchDisplay.length.toString() + "Record Founds" ,textAlign: TextAlign.center,),),),
                          Expanded(
                              child:IconButton(icon:Icon(Icons.arrow_downward), onPressed: () {
                                Sort();
                              },) ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],),

          ),],),
      ));

    }



  }
  _deleteMessage(index){
    setState(() {
      SearchDisplay.removeAt(index);
    });
  }
}
