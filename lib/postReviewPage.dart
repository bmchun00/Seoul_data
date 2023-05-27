import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:wbex2/reviewPage.dart';

class PostReviewPage extends StatefulWidget{
  String storeId;
  String userName;
  String userLocation;
  PostReviewPage(this.storeId,this.userName,this.userLocation);

  State<PostReviewPage> createState() => _PostReviewPage(storeId,userName,userLocation);
}

class _PostReviewPage extends State<PostReviewPage>{
  String storeId;
  String userName;
  String userLocation;
  _PostReviewPage(this.storeId,this.userName,this.userLocation);
  List<Uint8List> bytesFromPicker = [];
  TextEditingController? contentController;

  Widget getBoxContents(){
    return IconButton(onPressed: (){pickImage();}, icon: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: Icon(
        CupertinoIcons.camera,
        color: Colors.black
      ),
    ));
  }

  Future<String> putImageData() async{
    final storageRef = FirebaseStorage.instance.ref();
    if(bytesFromPicker.isEmpty)
      return "";

    Uint8List bytes = bytesFromPicker[0];
    var imageRef = storageRef.child("images/"+storeId+DateFormat('yyyy-MM-dd-mm-ss').format(DateTime.now())+".jpg");
    await imageRef.putData(bytes);

    String toRet = await imageRef.getDownloadURL();
    return toRet;
  }

  postReview() async{
    context.loaderOverlay.show();
    String imgUrl = await putImageData();
    String content = contentController!.value.text;

    await db.collection("comments").add({'photo' : imgUrl, 'userName' : userName, 'time' :Timestamp.fromDate(DateTime.now()), 'content' : content, 'storeId' : storeId, 'userLocation' : userLocation}).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
    context.loaderOverlay.hide();
    Navigator.of(context).pop();
  }

  Future<void> pickImage() async{
    Uint8List? bytes = await ImagePickerWeb.getImageAsBytes();
    if(bytes == null)
      bytesFromPicker = [];
    else
      bytesFromPicker = [bytes];
    setState(() {
    });
  }
  @override
  void initState() {
    contentController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return LoaderOverlay(child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("리뷰 작성", style: TextStyle(fontFamily: "SCDream"),),
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0), child: IconButton(icon: Icon(Icons.save), color: Colors.black, onPressed: () {
            postReview();
          },),)
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width-20,
            height: MediaQuery.of(context).size.width-20,
            padding: EdgeInsets.all(10),
            child: DottedBorder(
              child: Container(
                width: MediaQuery.of(context).size.width-20,
                height: MediaQuery.of(context).size.width-20,
                child: Center(
                  child: getBoxContents(),
                ),
                decoration: bytesFromPicker.isEmpty ? null : BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.memory(bytesFromPicker[0]).image,
                    )
                ),
              ),
              color: Colors.black,
              dashPattern: [5,4],
              borderType: BorderType.RRect,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10,0,10,10),
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: null,
              controller: contentController,
              decoration: InputDecoration(
                hintText: "리뷰를 작성해주세요.",
                hintStyle: TextStyle(fontSize: 15.0,fontFamily: 'SCDream'),
              ),
              style:  TextStyle(fontSize: 15.0,fontFamily: 'SCDream'),
            ),
          )
        ],
      ),
    ),);
  }
}