import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/NewsView.dart';
import 'package:news_app/category.dart';
import 'package:news_app/model.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = [];
  List<NewsQueryModel> newsModelListCarousel = [];
  List<String> navBarItem = ["Bihar","India","Business","Entertainment","General","Health","Science","Sports","Technology"];


  bool isLoading = true;
  getNewsByQuery(String query) async {
    try {
      Map element;
      int i = 0;
      String url = "https://newsapi.org/v2/everything?q=$query&apiKey=4ba4bd0d13f9451f90d81de258e609ef";
      Response response = await get(Uri.parse(url));
      Map data = jsonDecode(response.body);
      // log(data.toString());
      setState(() {
        for (element in data["articles"]){
          try{
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if (i == 5){
            break;
          }
          }catch(e){print(e);}
        };
      });
    }catch(e){
      log("Error: $e");
    }
  }

  getNewsUs() async {
    try {
      Map element;
      int i = 0;
      String url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=4ba4bd0d13f9451f90d81de258e609ef";
      Response response = await get(Uri.parse(url));
      Map data = jsonDecode(response.body);
      // log(data.toString());
      setState(() {
        for (element in data["articles"]) {
          try{
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if (i == 5){
            break;
          }
          }catch(e){print(e);}
        };
      });
    }catch(e){
      log("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery("general");
    getNewsUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24)
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: searchController.text)));
                    },
                    child: Container(
                      child: Icon(Icons.search,color: Colors.blueAccent,),
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                  ),
                  Expanded(child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value){
                      if (value == ""){
                        print("Blank Search");
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: value)));
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search News",
                    ),
                  ))
                ],
              ),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: navBarItem.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: navBarItem[index])));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.yellow[300],
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(navBarItem[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20,),
            CarouselSlider(
                items: newsModelListCarousel.map((instance) {
                  return Builder(
                    builder: (BuildContext context) {
                      try{
                      return Container(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Newsview(instance.newsUrl)));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(instance.newsImg, fit: BoxFit.fitHeight,width: double.infinity,),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10) ),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black12.withValues(alpha: 0.2),
                                            Colors.black],
                                        begin: Alignment.topCenter,end: Alignment.bottomCenter)
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 10
                                      ),
                                      child: Text(instance.newsHead, style: TextStyle(color: Colors.white),),
                                    ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                      }catch(e){print(e); return Container();}
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  height: 200
                )
            ),
            Container(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsModelList.length,
                  itemBuilder: (context, index){
                  try{
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Newsview(newsModelList[index].newsUrl)));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 1,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(newsModelList[index].newsImg, fit: BoxFit.fitHeight,width: double.infinity, height: 200,
                  
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight:Radius.circular(15) ),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.black12.withValues(alpha: 0.2),
                                      Colors.black],
                                    begin: Alignment.topCenter, end: Alignment.bottomCenter
                                )
                              ),
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(newsModelList[index].newsHead.length>30 ? "${newsModelList[index].newsHead.substring(0,35)}..." : newsModelList[index].newsHead,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(newsModelList[index].newsDes.length >35 ? "${newsModelList[index].newsDes.substring(0,42)}..." : newsModelList[index].newsDes, style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
                  }catch(e){print(e); return Container();}
              }),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Category(Query: "india")));
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[300], // Change to your desired color
                      foregroundColor: Colors.black, // Text color
                    ),
                    child: Text("Show More"),  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
