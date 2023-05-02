import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wbex2/pageRouteAnimation.dart';
import 'package:wbex2/photoDetailView.dart';
import 'package:wbex2/postReviewPage.dart';
import 'main.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class ReviewPage extends StatefulWidget{
  String storeName;
  String storeId;
  String storePhotoUrl;

  ReviewPage(this.storeName,this.storeId, this.storePhotoUrl);
  State<ReviewPage> createState() => _ReviewPage(storeName,storeId, storePhotoUrl);
}

class _ReviewPage extends State<ReviewPage>{
  String storeName;
  String storeId;
  String storePhotoUrl;
  int reviewCount = 0;
  int photoReviewCount = 0;
  List<Map> commentDataList = [];

  _ReviewPage(this.storeName,this.storeId,this.storePhotoUrl);

  _countReview() {
    reviewCount = commentDataList.length;
    photoReviewCount = 0;
    commentDataList.forEach((element) {
      if(element['photo'] != "")
        photoReviewCount++;
    });
  }

  _getComment(String stId) async{
    await db.collection("comments").where("storeId",isEqualTo: stId).orderBy("time", descending: true).get().then((event) {
      commentDataList = List.empty(growable: true);
      for (var doc in event.docs) {
        var data = doc.data();
        commentDataList.add({'content' : data['content'], 'storeId' : data['storeId'], 'time' : DateTime.fromMillisecondsSinceEpoch(data['time'].seconds * 1000), 'userName' : data['userName'], 'photo' : data['photo'], 'userLocation' : data['userLocation']});
      }
    });
    print(commentDataList);
    setState(() {
      _countReview();
    });
  }
  Widget buildImage(String url){
    if(url=="")
      return Container();
    else{
      return InkWell(
        onTap: (){
          Navigator.of(context).push(fadeRoute(PhotoDetailView(url), 200));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          width: MediaQuery.of(context).size.width-20,
          height: MediaQuery.of(context).size.width-20,
          decoration : BoxDecoration(
              image: DecorationImage(image: Image.network(url).image,fit: BoxFit.cover)
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    _getComment(storeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text("리뷰", style: TextStyle(fontFamily: "SCDream"),),
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: Colors.white,
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 70,width: 70, decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(image: Image.network(storePhotoUrl).image,fit: BoxFit.cover)),
                  margin: EdgeInsets.only(right: 10),
                ),
                Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(storeName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "SCDream"),),
                        Expanded(child: Text("")),
                      ],
                    ),
                    Row(
                      children: [
                        Text("총 $reviewCount개의 리뷰", style: TextStyle(fontSize: 15, fontFamily: "SCDream"),),
                        Expanded(child: Text("")),
                      ],
                    ),
                    Row(
                      children: [
                        Text("사진 리뷰 $photoReviewCount개", style: TextStyle(fontSize: 13, color:Colors.grey, fontFamily: "SCDream"),),
                        Expanded(child: Text("")),
                      ],
                    ),
                  ],
                ),
                )
              ],
            )
          ),
          InkWell(
            onTap: () async {
              await Navigator.of(context).push(bottomUpRoute(PostReviewPage(storeId, userName, userLocation)));
              setState(() {
                _getComment(storeId);
              });
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message_sharp, color: Colors.black,size: 18,),
                  Text(" 리뷰 작성하기", style: TextStyle(color: Colors.black, fontFamily: "SCDream"),)
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white, child: ListView.builder(
            shrinkWrap : true,
            physics : NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
              return Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(height: 40,width: 40, decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(image: Image.network("https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg").image,fit: BoxFit.cover)),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(commentDataList[index]['userName'],overflow: TextOverflow.fade, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'SCDream'),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.pin_drop_outlined, size: 12,),
                                    Text(" "+commentDataList[index]['userLocation'] , style: TextStyle(fontSize: 12, fontFamily: 'SCDream'),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      buildImage(commentDataList[index]['photo']),
                      Wrap(
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        children: [
                          Row(),
                          Text(commentDataList[index]['content'], textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontFamily: 'SCDream'),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text(DateFormat.yMMMd().add_jm().format(commentDataList[index]['time']), textAlign: TextAlign.start, style: TextStyle(fontSize: 10,fontFamily: 'SCDream',color: Colors.grey),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(),
                    ],
                  ),
                ),
              );
            },
            itemCount: commentDataList.length,
          )),

        ],
      ),
    );
  }
}