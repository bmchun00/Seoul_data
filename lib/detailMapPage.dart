import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:webviewx/webviewx.dart';
import 'html.dart';

class DetailMapPage extends StatefulWidget{
  double x,y;
  DetailMapPage(this.x, this.y);
  State<DetailMapPage> createState() => _DetailMapPage(x,y);
}
class coord{
  double x,y;
  coord(this.x,this.y);
}


class _DetailMapPage extends State<DetailMapPage>{
  double x,y;
  coord loc = coord(32.566535,122.9779692);
  Widget? fixedMap =null ;

  void fetchData() async {
    final Location location = new Location();
    var _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);
    setState(() {
      loc = coord(_locationData.latitude ?? 37.566535,_locationData.longitude ?? 126.9779692);
      fixedMap = WebViewX(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, initialSourceType: SourceType.html, initialContent: mover(x,y,_locationData.latitude ?? 37.566535,_locationData.longitude ?? 126.9779692),);
    });
  }

  _DetailMapPage(this.x, this.y);
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상세 지도 보기", style: TextStyle(fontFamily: "SCDream"),),
      ),
      body: Container(
        child: Center(
          child: fixedMap ?? CircularProgressIndicator(),
        ),
      ),
    );
  }
}