import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:wbex2/detailPage.dart';
import 'package:wbex2/pageRouteAnimation.dart';

import 'main.dart';


class ListPage extends StatefulWidget{
  List<dynamic> data;
  ListPage(this.data, this.categoryName, this.categoryNum, this.loc);
  String categoryName;
  String categoryNum;
  String loc;

  State<ListPage> createState ()=> _ListPage(data,categoryName,categoryNum,loc);
}

class _ListPage extends State<ListPage>{
  List<dynamic> listData;
  _ListPage(this.listData, this.categoryName, this.categoryNum, this.loc);
  String categoryName;
  String categoryNum;
  String selDist = '';
  String loc;
  TextEditingController searchController = TextEditingController();

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

  Widget getCard(Map dt){
    return Card(
        shape: RoundedRectangleBorder(),
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(fadeRoute(DetailPage(dt), 200));
          }, //toDo
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(height: 200, decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(image: Image.network(dt['sh_photo']).image,fit: BoxFit.cover)
                ),
                  alignment: Alignment.topRight,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dt['sh_name'], style: TextStyle(fontFamily: 'SCDream', fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Container(
                          child: Icon(Icons.pin_drop_outlined,size: 10, color: Colors.grey,),
                          alignment: Alignment.center,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(child: Container(
                          child: Text(getCorrectString(dt['sh_way']), style: TextStyle(fontFamily: 'SCDream', fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis, maxLines: 1,),
                        ))
                      ],
                    ),
                    SizedBox(height: 5,),
                    Text(getCorrectString(dt['sh_pride']), style: TextStyle(fontFamily: 'SCDream', fontSize: 15, color: Colors.black87), overflow: TextOverflow.ellipsis, maxLines: 3,),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget getSliver(){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 50.0,
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
                children:[
              Text(categoryName+" | ", style: TextStyle(fontFamily: "SCDream", fontSize: 14),),
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  buttonStyleData: ButtonStyleData(
                    height: 30,
                    width: 120,
                    padding: const EdgeInsets.only(left: 0, right: 40),

                  ),
                  alignment: Alignment.center,
                  style: TextStyle(fontFamily: "SCDream"),
                  isExpanded: true,
                  hint: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
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
                      ),
                    ),
                  ))
                      .toList(),
                  value: loc,
                  onChanged: (value) {
                    setState(() {
                      loc = value as String;
                      listData = sortDataWithParams(categoryNum, loc == "전체" ? "ALL" : loc, fixedData);
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
                        bottom: 4,
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
            ]),
            floating: true,
          ),
          SliverList(delegate: SliverChildListDelegate(List.generate(listData!.length, (idx) => getCard(listData![idx]))))
        ],
      ),
    );
  }

  Widget getEmptyView(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title : Row( children:[
          Text(categoryName+" | ", style: TextStyle(fontFamily: "SCDream", fontSize: 14),),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              buttonStyleData: ButtonStyleData(
                height: 30,
                width: 120,
                padding: const EdgeInsets.only(left: 0, right: 40),

              ),
              alignment: Alignment.center,
              style: TextStyle(fontFamily: "SCDream"),
              isExpanded: true,
              hint: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
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
                  ),
                ),
              ))
                  .toList(),
              value: loc,
              onChanged: (value) {
                setState(() {
                  loc = value as String;
                  listData = sortDataWithParams(categoryNum, loc == "전체" ? "ALL" : loc, fixedData);
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
                    bottom: 4,
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
        ]),
      ),
      body: Center(
        child: Container(
          child: Text("😥 검색된 결과가 없습니다.", style: TextStyle(fontFamily: "SCDream", fontSize: 20, ),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: listData.isEmpty? getEmptyView() : getSliver()
    );
  }

  @override
  void initState() {
    super.initState();
    print(listData); //release에서는 제거
  }
}