import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mylistv2/databasehelper.dart';
import 'package:mylistv2/mylist.dart';
import 'package:mylistv2/newitemscreen.dart';
import 'package:path_provider/path_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MyList> mylist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyList V2"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadData();
            },
          ),
        ],
      ),
      body: Center(
        child: mylist.isEmpty
            ? const Text("No items found")
            : ListView.builder(
                itemCount: mylist.length,
                itemBuilder: (context, index) {
                  if (mylist[index].imagename == "NA") {
                    mylist[index].imagename = "assets/camera128.png";
                  } else {
                    // mylist[index].imagename = appDir.path + "/" + mylist[index].imagename;
                  }

                  return Card(
                    child: ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _loadImage(mylist[index].imagename),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(mylist[index].title),
                      subtitle: Text(mylist[index].description),
                      trailing: Text(mylist[index].status),
                      onTap: () {},
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewItemScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> loadData() async {
    //load data from sqlite db and display as list.
    mylist = [];
    mylist = await DatabaseHelper().getAllMyLists();
    setState(() {});
  }

  ImageProvider _loadImage(String imagename) {
    // CASE 1: No image -> use default asset
    if (imagename == "NA") {
      return const AssetImage("assets/camera128.png");
    }

    // CASE 2: Image stored in app dir
    final file = File(imagename);
    if (file.existsSync()) {
      return FileImage(file);
    }

    // CASE 3: If file missing, fallback to asset
    return const AssetImage("assets/camera128.png");
  }
}
