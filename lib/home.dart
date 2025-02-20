import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController searchController = new TextEditingController();
  List<String> navBarItem = ["Business","Entertainment","General","Health","Science","Sports","Technology"];
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
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchController.text)));
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
                      print(value);
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
                        print(navBarItem[index]);
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
                items: items.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("images/news_image.webp"),
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
                                    child: Text("News Headline Idhar Hai", style: TextStyle(color: Colors.white),),
                                  ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
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
                  itemCount: 3,
                  itemBuilder: (context, index){
                return Container(
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
                          child: Image.asset("images/news_image.webp"),
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
                                Text("News headline",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text("Bala Bala Bala Bala ....", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  final List items = ["hallo world", "hallo worlddd", "aaaaa", "hallo world", "hallo worlddd", "aaaaa", "hallo world", "hallo worlddd", "aaaaa"];
}
