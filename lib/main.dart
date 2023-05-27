import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wbex2/pageRouteAnimation.dart';
import 'package:wbex2/startPage.dart';
import 'detailPage.dart';
import 'listPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

String userName="하얀구름95";
String userLocation="전체";

final districts = ['전체','강남구','강동구','강북구','강서구','관악구','광진구','구로구','금천구','노원구','도봉구','동대문구','동작구','마포구','서대문구','서초구','성동구','성북구','송파구','양천구','영등포구','용산구','은평구','종로구','중구','중랑구'];


List<Map> categoryList = [
  {"categoryNum" : "001", "categoryName" : "한식", "categoryIcon" : Icons.rice_bowl},
  {"categoryNum" : "002", "categoryName" : "중식", "categoryIcon" : Icons.ramen_dining},
  {"categoryNum" : "003", "categoryName" : "일식", "categoryIcon" : Icons.set_meal},
  {"categoryNum" : "004", "categoryName" : "외식", "categoryIcon" : Icons.local_cafe},
  {"categoryNum" : "005", "categoryName" : "미용", "categoryIcon" : Icons.store},
  {"categoryNum" : "006", "categoryName" : "사우나", "categoryIcon" : Icons.hot_tub},
  {"categoryNum" : "007", "categoryName" : "세탁", "categoryIcon" : Icons.local_laundry_service},
  {"categoryNum" : "008", "categoryName" : "숙박", "categoryIcon" : Icons.king_bed},
  {"categoryNum" : "009", "categoryName" : "영화", "categoryIcon" : Icons.local_movies}, // vtr대여와 통합 (010)
  {"categoryNum" : "011", "categoryName" : "노래방", "categoryIcon" : Icons.mic_external_on},
  {"categoryNum" : "012", "categoryName" : "스포츠", "categoryIcon" : Icons.sports_gymnastics},
  {"categoryNum" : "013", "categoryName" : "기타", "categoryIcon" : Icons.more_horiz},
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

List<dynamic> fixedData = [];
bool _onload = false;

List<dynamic> sortDataWithParams(String code, String location, List<dynamic> data){
  if(location=='전체'){
    location='ALL';
  }
  location = location.substring(0,3);
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

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: StartPage(),
    );
  }
}

class MainPage extends StatefulWidget{
  State<MainPage> createState ()=> _MainPage();
}

class _MainPage extends State<MainPage>{
  TextEditingController? searchController;
  List<dynamic> data = [];

  void getData() async {
    String uri = 'http://bmchun00.github.io/assets/seoul.json';
    http.Response response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      fixedData = jsonDecode(response.body)['DATA'];
    }
    setState(() {
      _onload = true;
      data = sortDataWithParams('000', userLocation == "전체" ? "ALL" : userLocation, fixedData);
    });
  }


  List<Widget> getRandomCard(int times){
    DateTime today = DateTime.now();
    int seed = today.day + today.year + today.month;
    if(data.isEmpty){
      return [Text("")];
    }
    List<Widget> toRet = [];
    for(int i = 0; i<times; i++){
      int key = Random(seed+i).nextInt(data.length);
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
                SizedBox(height: 40,),
                Text("설렘", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jeju', fontSize: 25),),
                SizedBox(height: 5,),
                Text("서울시의 착한 가격 업소", style: TextStyle(fontWeight: FontWeight.w200, fontFamily: 'Jeju', fontSize: 15),),
                SizedBox(height: 20,),
                Row(
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        buttonStyleData: ButtonStyleData(
                          height: 20,
                          width: 110,
                          padding: const EdgeInsets.only(left: 16, right: 16),

                        ),
                        alignment: Alignment.center,
                        style: TextStyle(fontFamily: "SCDream"),
                        isExpanded: true,
                        hint: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        items: districts
                            .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "SCDream",
                              color: Colors.black
                            ),
                          ),
                        ))
                            .toList(),
                        value: userLocation,
                        onChanged: (value) {
                          setState(() {
                            userLocation = value as String;
                            data = sortDataWithParams('000', userLocation == "전체" ? "ALL" : userLocation, fixedData);
                          });
                        },
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: searchController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 0,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              style: TextStyle(fontFamily: "SCDream"),
                              expands: true,
                              maxLines: null,
                              controller: searchController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: '검색',
                                hintStyle: const TextStyle(fontSize: 12),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return (item.value.toString().contains(searchValue));
                          },
                        ),
                        //This to clear the search value when you close the menu
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            searchController!.clear();
                          }
                        },
                      ),

                    ),
                    Expanded(child: Text('')),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 16,),
                    Text(userName+" 님 ", style: TextStyle(fontFamily: "SCDream", color: Colors.black, fontSize: 14),),
                    InkWell(onTap: (){
                      Navigator.of(context).pushReplacement(fadeRoute(StartPage(), 200));
                    }, child: Icon(Icons.refresh, size: 15,)),
                    Expanded(child: Text(''))
                  ],
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),

          GridView.count(
            crossAxisCount: 6,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(categoryList.length, (index) {
              return Center(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(fadeRoute(ListPage(sortDataWithParams(categoryList[index]['categoryNum'], userLocation, fixedData), categoryList[index]['categoryName'],categoryList[index]['categoryNum'],userLocation),200));
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(),
                        Icon(categoryList[index]['categoryIcon'], color: Colors.black, size: 30,),
                        SizedBox(height: 5,),
                        Text(categoryList[index]['categoryName'], style: TextStyle(fontFamily: "SCDream", color: Colors.black, fontSize: 10),),
                      ],
                    ),
                  )
                )
              );
            }),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
            child: Row(
              children: [
                Icon(Icons.stars_sharp, color: Colors.black, size: 23,),
                Text(" 오늘의 PICK", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "SCDream"),)
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
            padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
            child: Row(
              children: [
                Icon(Icons.pin_drop_outlined, color: Colors.black, size: 23,),
                Text(" 내 주변 (아직 미구현)", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "SCDream"),)
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
    searchController = TextEditingController();
    _onload = false;
    super.initState();
    getData();
  }
}