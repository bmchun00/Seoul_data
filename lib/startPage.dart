import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wbex2/pageRouteAnimation.dart';
import 'main.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget{
  State<StartPage> createState() => _StartPage();
}

class _StartPage extends State<StartPage>{
  TextEditingController? searchController;
  TextEditingController? userNameController;
  @override
  void initState() {
    searchController = TextEditingController();
    userNameController = TextEditingController();
    userNameController!.text = userName;
    super.initState();
  }
  String getRandomName(){
    List names=[
      "빨강", "노랑", "주황", "파랑", "초록", "구름", "하얀", "곰돌", "사과", "식초", "이불", "하늘", "구두", "검정", "이름", "나비"
    ];
    String toret = names[Random().nextInt(names.length)]+names[Random().nextInt(names.length)]+Random().nextInt(100).toString();
    return toret;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            Text("설렘", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jeju', fontSize: 25),),
            SizedBox(height: 5,),
            Text("서울시의 착한 가격 업소", style: TextStyle(fontWeight: FontWeight.w200, fontFamily: 'Jeju', fontSize: 15),),
            SizedBox(height: 40,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 18,),
                Icon(Icons.pin_drop_outlined, size: 15, color: Colors.black,),
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
                          bottom: 6,
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
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  child: TextField(
                    controller: userNameController,
                    style: TextStyle(
                      fontFamily: "SCDream",
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(5),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    String tmp = getRandomName();
                    userNameController!.text = tmp;
                  },
                  child: Icon(Icons.refresh, size: 17,),
                )
              ],
            ),
            SizedBox(height: 40,),
            InkWell(
              child: Icon(Icons.arrow_forward),
              onTap: (){
                userName = userNameController!.text;
                Navigator.of(context).pushReplacement(fadeRoute(MainPage(),200));
              },
            ),
          ],
        ),
      ),
    );
  }
}