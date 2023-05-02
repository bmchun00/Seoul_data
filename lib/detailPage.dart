import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wbex2/html.dart';
import 'package:wbex2/pageRouteAnimation.dart';
import 'package:wbex2/reviewPage.dart';
import 'package:webviewx/webviewx.dart';
import 'detailMapPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

double initX =33.450701, initY= 126.570667;

Widget SmallMapsWebView(int x, int y, String addr) {
  print(initX);
  return WebViewX(width: 1000, height: 200, initialSourceType: SourceType.html, initialContent: ht(initX,initY),);
}

class DetailPage extends StatefulWidget{
  Map data;

  DetailPage(this.data);

  @override
  State<StatefulWidget> createState() {
    return _DetailPage(data);
  }
}

class _DetailPage extends State<DetailPage>{
  Map data;
  _DetailPage(this.data);
  bool _onload = false;

  String getCorrectString(String? toRefine){
    if(toRefine == null){
      return "정보가 없습니다.";
    }
    toRefine = toRefine.trim();
    if(toRefine == "null" || toRefine == "null." || toRefine == ""){
      return "정보가 없습니다.";
    }
    else return toRefine;
  }
  
  Future<void> setCoor(String addr) async{
    String uri = "https://dapi.kakao.com/v2/local/search/address.json?query=$addr";
    http.Response response = await http.get(Uri.parse(uri), headers: {HttpHeaders.authorizationHeader: "KakaoAK d5fbcd779099859e2c38c9997d323347"},);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      initX = double.parse(data['documents'][0]['address']['y']);
      initY = double.parse(data['documents'][0]['address']['x']);
    }
    setState(() {
      _onload = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 50.0,
            backgroundColor: Colors.white,
            elevation: 0.0,
            floating: false,
            centerTitle: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image:DecorationImage(image: Image.network(data['sh_photo']).image,fit: BoxFit.cover)),
                    ),
                  ],
                )
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(height: 3,),
                  Row(
                    children: [
                      Text(data['sh_name'], style: TextStyle(fontFamily: 'SCDream', fontSize: 25, fontWeight: FontWeight.bold),),
                      Expanded(child: Text(""),),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(data['sh_addr'].substring(6,9) + "에 위치한 착한 가격 업소", style: TextStyle(fontFamily: 'SCDream', fontSize: 15, color: Colors.black87)),
                      Expanded(child: Text("")),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Flexible(child: Container(
                        child: Text(getCorrectString(data['sh_way']), style: TextStyle(fontFamily: 'SCDream', fontSize: 12, color: Colors.grey),),
                      ))
                    ],
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(bottomUpRoute(ReviewPage(data['sh_name'], data['sh_id'], data['sh_photo'])));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.message_sharp, color: Colors.black,size: 18,),
                          Text(" 리뷰", style: TextStyle(color: Colors.black, fontFamily: "SCDream"),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  Text("매장 소개", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "SCDream"),)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(getCorrectString(data['sh_pride']), style: TextStyle(color: Colors.black87, fontFamily: "SCDream"),),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  Text("운영 정보", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "SCDream"),)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
              child: Text(getCorrectString(data['sh_info']), style: TextStyle(color: Colors.black87, fontFamily: "SCDream")),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
              child: Row(
                children: [
                  Text("매장 위치", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "SCDream"),)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(getCorrectString(data['sh_addr']), style: TextStyle(color: Colors.black87, fontFamily: "SCDream")),
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                child: Center(
                  child: _onload ? SmallMapsWebView(2, 2, data['sh_addr']) : CircularProgressIndicator(),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(bottomUpRoute(DetailMapPage(initX,initY)));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(8, 0, 8, 10),
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pin_drop_outlined, color: Colors.black,size: 18,),
                    Text("상세 지도 보기", style: TextStyle(color: Colors.black, fontFamily: "SCDream"),)
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  Text("연락처", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "SCDream"),)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
              child: Text(getCorrectString(data['sh_phone']), style: TextStyle(color: Colors.black87, fontFamily: "SCDream")),
            ),
          ]),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    setCoor(data['sh_addr']);
  }
}