import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:wbex2/detailPage.dart';
import 'package:wbex2/pageRouteAnimation.dart';


class ListPage extends StatefulWidget{
  List<dynamic> data;
  ListPage(this.data, this.categoryName);
  String categoryName;

  State<ListPage> createState ()=> _ListPage(data,categoryName);
}

class _ListPage extends State<ListPage>{
  List<dynamic> data;
  _ListPage(this.data, this.categoryName);
  String categoryName;
  String selDist = '';

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
            title: Text(categoryName, style: TextStyle(fontFamily: "SCDream"),),
            floating: true,
          ),
          SliverList(delegate: SliverChildListDelegate(List.generate(data!.length, (idx) => getCard(data![idx]))))
        ],
      ),
    );
  }

  Widget getEmptyView(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title : Text(categoryName, style: TextStyle(fontFamily: "SCDream"),),
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
      body: data.isEmpty? getEmptyView() : getSliver()
    );
  }

  @override
  void initState() {
    super.initState();
    print(data); //release에서는 제거
  }
}