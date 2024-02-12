import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String? imagepath;
class BottomSheetWidget extends StatefulWidget {
  final Function() action;
  const BottomSheetWidget({super.key, required this.action});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}


class _BottomSheetWidgetState extends State<BottomSheetWidget> {

  final ImagePicker picker = ImagePicker();
  Future<void> _getImageFromCamera() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    imagepath = image!.path;
    widget.action();
    // Handle the image obtained from the camera
    if (image != null) {
      // Do something with the image file
      print('Image from camera: ${image.path}');
    }
  }

  Future<void> _getImageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    imagepath = image!.path;
    widget.action();
    // Handle the image obtained from the gallery
    if (image != null) {
      // Do something with the image file
      print('Image from gallery: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera,size: 25),
            title: Text('Take Photo',style: TextStyle(fontSize: 20),),
            onTap: () {
              _getImageFromCamera();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.image,size: 25),
            title: Text('Pick from Gallery',style: TextStyle(fontSize: 20),),
            onTap: () {
              _getImageFromGallery();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}