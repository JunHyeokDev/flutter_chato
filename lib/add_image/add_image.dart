import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';




class AddImage extends StatefulWidget {
  const AddImage({super.key, required this.addImageFunc});

  final Function(File pickedImage) addImageFunc;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {

  File? pickedImage;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 150,
    );
    setState(() {
      if(pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
      }
    });
    widget.addImageFunc(pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue,
          backgroundImage: pickedImage != null ?  FileImage(pickedImage!) : null,
        ),
        SizedBox(height: 10,),
        OutlinedButton.icon(
          onPressed: (){
            print("클릭??");
            _pickImage();
          },
          label: Text("add Photo"),
          icon: Icon(Icons.image),
        ),
        SizedBox(height: 80,),
        TextButton.icon(onPressed: (){
          Navigator.pop(context);
        },
          label: Text("close"),
          icon: Icon(Icons.close),
        ),
      ],
    );
  }
}
