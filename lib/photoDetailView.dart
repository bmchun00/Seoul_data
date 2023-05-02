import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetailView extends StatefulWidget{
  String url;
  PhotoDetailView(this.url);
  State<PhotoDetailView> createState() => _PhotoDetailView(url);
}

class _PhotoDetailView extends State<PhotoDetailView>{
  String url;
  _PhotoDetailView(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.close, color: Colors.white,), onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          child: PhotoView(
            imageProvider: Image.network(url).image,
          )
      ),
    );
  }
}
