import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String? prediction= null;
  late File? _image= null;
  final picker = ImagePicker();

//Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> predict(File image)async{
    final uri = Uri.parse('http://192.168.1.20:8000/predict'); // Replace with your API URL
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResp = jsonDecode(respStr);
      setState(() {
        prediction = jsonResp['label'];
      });
    } else {
      setState(() {
        prediction = 'Failed to get prediction';
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await getImageFromGallery();
                        predict(_image!);
                      },
                      icon: Icon(Icons.upload),
                      color: Colors.blue,
                      iconSize: 48,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Upload Photo",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                SizedBox(width: 50,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await getImageFromCamera();
                        predict(_image!);
                      },
                      icon: Icon(Icons.camera),
                      iconSize: 48,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Take a photo.",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ],
            ),
            _image == null ? Text('No Image selected') : Image.file(_image!),
            prediction == null ? Text('') : Text(prediction!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),),
          ],
        ),
      ),

    );
  }
}
