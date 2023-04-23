import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wbex2/pageRouteAnimation.dart';
import 'detailPage.dart';
import 'listPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<Map> categoryList = [
  {"categoryNum" : "001", "categoryName" : "한식", "categoryIcon" : Icons.rice_bowl},
  {"categoryNum" : "002", "categoryName" : "중식", "categoryIcon" : Icons.ramen_dining},
  {"categoryNum" : "003", "categoryName" : "일식", "categoryIcon" : Icons.set_meal},
  {"categoryNum" : "004", "categoryName" : "기타 외식", "categoryIcon" : Icons.local_cafe},
  {"categoryNum" : "005", "categoryName" : "미용", "categoryIcon" : Icons.store},
  {"categoryNum" : "006", "categoryName" : "사우나", "categoryIcon" : Icons.hot_tub},
  {"categoryNum" : "007", "categoryName" : "세탁", "categoryIcon" : Icons.local_laundry_service},
  {"categoryNum" : "008", "categoryName" : "숙박", "categoryIcon" : Icons.king_bed},
  {"categoryNum" : "009", "categoryName" : "영화", "categoryIcon" : Icons.local_movies}, // vtr대여와 통합 (010)
  {"categoryNum" : "011", "categoryName" : "노래방", "categoryIcon" : Icons.mic_external_on},
  {"categoryNum" : "012", "categoryName" : "스포츠", "categoryIcon" : Icons.sports_gymnastics},
  {"categoryNum" : "013", "categoryName" : "기타 서비스", "categoryIcon" : Icons.more_horiz},
];

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

List<dynamic> data = [];
bool _onload = false;

List<dynamic> sortDataWithParams(String code, String location, List<dynamic> data){
  List<dynamic> sortedList = [];
  bool codeVerify = false;
  bool locationVerify = false;
  bool is009 = code == '009';
  data.forEach((element) {
    codeVerify = code=='000' || code==element['induty_code_se'];
    locationVerify = location == 'ALL' || location==(element['sh_addr'].substring(6, 9));
    if(locationVerify && codeVerify){
      sortedList.add(element);
    }
  });
  if(is009){
    data.forEach((element) {
      codeVerify = '010'==element['induty_code_se'];
      locationVerify = location == 'ALL' || location==(element['sh_addr'].substring(6, 9));
      if(locationVerify && codeVerify){
        sortedList.add(element);
      }
    });
  }
  return sortedList;
}

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seoul Data',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget{
  State<MainPage> createState ()=> _MainPage();
}

class _MainPage extends State<MainPage>{
  void getData() async {
    String uri = 'http://bmchun00.github.io/assets/seoul.json';
    http.Response response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body)['DATA'];
    }
    setState(() {
      _onload = true;
    });
  }


  List<Widget> getRandomCard(int times){
    List<Widget> toRet = [];
    for(int i = 0; i<times; i++){
      int key = Random().nextInt(data.length);
      Container con = Container(
        child: Card(
            shape: RoundedRectangleBorder(),
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(fadeRoute(DetailPage(data[key]), 200));
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Container(height: 100, width: 200, decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                        image: DecorationImage(image: Image.network(data[key]['sh_photo']).image,fit: BoxFit.cover)
                    ),
                      alignment: Alignment.topRight,
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            Icon(Icons.pin_drop_outlined, size: 10, color: Colors.grey,),
                            Text(" " + data[key]['sh_addr'].substring(6,9), style: TextStyle(fontFamily: "SCDream", color: Colors.grey, fontSize: 10),),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(data[key]['sh_name'], style: TextStyle(fontFamily: 'SCDream', fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      );
      toRet.add(con);
    }
    return toRet;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(height: 30,),
                Text("SEOUL BARGAIN", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jeju', fontSize: 25),),
                SizedBox(height: 5,),
                Text("Find the perfect price", style: TextStyle(fontWeight: FontWeight.w200, fontFamily: 'Jeju', fontSize: 15),),
              ],
            ),
          ),

          GridView.count(
            crossAxisCount: 4,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(categoryList.length, (index) {
              return Center(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(fadeRoute(ListPage(sortDataWithParams(categoryList[index]['categoryNum'], 'ALL', data), categoryList[index]['categoryName']),200));
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(),
                        Icon(categoryList[index]['categoryIcon'], color: Colors.black,),
                        Text(categoryList[index]['categoryName'], style: TextStyle(fontFamily: "SCDream", color: Colors.black, fontSize: 10),),
                      ],
                    ),
                  )
                )
              );
            }),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                Icon(Icons.stars_sharp, color: Colors.black, size: 23,),
                Text(" 오늘의 추천", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "SCDream"),)
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _onload ? getRandomCard(7) : [CircularProgressIndicator()],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                Icon(Icons.pin_drop_outlined, color: Colors.black, size: 23,),
                Text(" 내 주변 (아직 미구?현)", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "SCDream"),)
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _onload ? getRandomCard(7) : [CircularProgressIndicator()],
            ),
          ),
          SizedBox(height: 1000,)
        ],
      )
    );
  }

  @override
  void initState() {
    _onload = false;
    super.initState();
    getData();
  }
}