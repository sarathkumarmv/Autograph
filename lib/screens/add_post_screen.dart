import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:autograph/providers/user_provider.dart';
import 'package:autograph/resources/firestore_methods.dart';
import 'package:autograph/utils/colors.dart';
import 'package:autograph/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  AddPostScreenState createState() => AddPostScreenState();
}

class AddPostScreenState extends State<AddPostScreen> {
  Uint8List? ifile;
  bool isLoading = false;
  final TextEditingController descriptionController = TextEditingController();

  selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                 Navigator.pop(context);
                  //Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    ifile = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    ifile = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        descriptionController.text,
        ifile!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context,'Posted!');
        clearImage();
      } else {
        showSnackBar(context,res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context,err.toString(),);
    }
  }

  void clearImage() {
    setState(() {
      ifile = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return ifile == null ? Center(
          child: IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => selectImage(context),
          ),
        ): Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: clearImage,
            ),
            title: const Text('Post to'),
            centerTitle: false,
            actions: <Widget>[
              TextButton(
                onPressed: () => postImage(userProvider.getUser.uid,
                  userProvider.getUser.username,userProvider.getUser.photoUrl),
                child: const Text("Post", style: TextStyle(color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0)),
                )
            ],
          ),
      // POST FORM
          body: Column(
            children: <Widget>[
              isLoading ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.only(top: 0.0)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    userProvider.getUser.photoUrl,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      border: InputBorder.none),
                  maxLines: 8,
                  ),
                ),
                SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(ifile!),
                        )),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      );
    }
}