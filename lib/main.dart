// ignore_for_file: camel_case_types, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    checkper();
    super.initState();
  }

  checkper() async
  {
    await Permission.storage.isDenied.then((value) => 
    Permission.storage.request());
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tack_Screenshot(),
    );
  }
}

class Tack_Screenshot extends StatefulWidget {
  const Tack_Screenshot({super.key});

  @override
  State<Tack_Screenshot> createState() => _Tack_ScreenshotState();
}

class _Tack_ScreenshotState extends State<Tack_Screenshot> {

  Directory directory = Directory('/storage/emulated/0/Pictures/Flutter');

  @override
  void initState() {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Screenshot',style: TextStyle(color: Colors.white,fontSize: 18,),),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: previewContainers,
                child: Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: const Image(
                      image: AssetImage('assets/images/flutter image.jpg'),
                      fit: BoxFit.cover,                
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              InkWell(
                onTap: () {
                  takeScreenShot();
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width/2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Text('Take Screenshot',style: TextStyle(color: Colors.white,),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GlobalKey previewContainers = GlobalKey();
  
  Future<void> takeScreenShot() async {

    var rng = Random();
    
    final RenderRepaintBoundary boundary = previewContainers.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile = File('/storage/emulated/0/Pictures/Flutter/Status_${rng.nextInt(1000000)}.png');
    await imgFile.writeAsBytes(pngBytes);
    SnackBarrr(context, 'Take screenshort and save in local storage');
  }

  SnackBarrr(BuildContext context, String title){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20,),
          child: Text(title, style: const TextStyle(color: Colors.white),),
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(label: "",textColor: Colors.white, onPressed: (){}),
        padding: const EdgeInsets.only(top: 5,left: 8),
        duration: const Duration(seconds: 5),
      ),
    );
  }

}
