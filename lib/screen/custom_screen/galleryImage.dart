import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class GalleryImage extends StatelessWidget {
  GalleryImage({Key? key}) : super(key: key);

  final ImagePicker _picker = ImagePicker();
  String pickedFile = '';

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    Future<void> cropImage() async {
      print(pickedFile);
      if (pickedFile != '') {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile,
          aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.ratio16x9,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(
                width: 520,
                height: 520,
              ),
              viewPort: const CroppieViewPort(
                  width: 480, height: 480, type: 'circle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,
            ),
          ],
        );
        if (croppedFile != null) {
          if (pvdStore.index == -1) {
            pvdStoreTheme.selectImage(croppedFile);
            pvdStoreTheme.removeBackground();
          } else {
            pvdStore.storedThemes[pvdStore.index].selectImage(croppedFile);
            pvdStore.storedThemes[pvdStore.index].removeBackground();
          }
        }
      }
    }

    Future getImage() async {
      await _picker
          .pickImage(source: ImageSource.gallery, imageQuality: 100)
          .then((value) {
        pickedFile = value!.path;
        cropImage();
      });
    }

    return Align(
      alignment: Alignment(0.9, 0.63),
      child: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        backgroundColor: const Color(0xFF222324),
        child: const Icon(
            Icons.wallpaper,
          color: Colors.white,
        ),
      ),
    );
  }
}
