import 'dart:convert';
import 'package:news_app/NewsView.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'model.dart';

class Category extends StatefulWidget {
  String Query;
  Category({required this.Query});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  bool isLoading = true;
  List<NewsQueryModel> newsModelList = [];

  @override
  void initState() {
    super.initState();
    getNewsByQuery(widget.Query);
  }


  getNewsByQuery(String query) async {
    try {
      Map element;
      int i =0;
      String url = "https://newsapi.org/v2/everything?q=$query&apiKey=4ba4bd0d13f9451f90d81de258e609ef";
      Response response = await get(Uri.parse(url));
      Map data = jsonDecode(response.body);
      // log(data.toString());
      setState(() {
        for (element in data["articles"]) {
          try{
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if (i==5){
            break;
          }
          }catch(e){print(e);}
        };
      });
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("News App"),
      centerTitle: true,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.Query,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(height: 10,),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: newsModelList.length,
                itemBuilder: (context, index){
                  try{
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Newsview(newsModelList[index].newsUrl)));
                      },
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
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                },
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
          ],
        ),
      ),

    );
  }
}
