import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mylistv2/databasehelper.dart';
import 'package:mylistv2/mylist.dart';
import 'package:mylistv2/newitemscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MyList> mylist = [];
  late double screenwidth, screenHeight;
  String status = "Loading...";
  int curpageno = 0;
  int limit = 5;
  int pages = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    if (screenwidth > 600) {
      screenwidth = 600;
    } else {
      screenwidth = screenwidth;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("MyList V2"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadData();
            },
          ),
          //delete all data
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDeleteAllDialog();
            },
          ),
        ],
      ),
      body: SizedBox(
        width: screenwidth,
        child: Center(
          child: mylist.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(status, style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Icon(Icons.find_in_page_outlined, size: 50),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(height: 2),
                    Text("Your Current List", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 2),
                    Expanded(
                      child: ListView.builder(
                        itemCount: mylist.length,
                        itemBuilder: (context, index) {
                          bool value = true;
                          if (mylist[index].imagename == "NA") {
                            mylist[index].imagename = "assets/camera128.png";
                          }
                          if (mylist[index].status == "Pending") {
                            value = false;
                          } else {
                            value = true;
                          }

                          return Card(
                            child: ListTile(
                              minTileHeight: screenHeight / 7,
                              leading: Container(
                                width: 80,
                                height:
                                    double.infinity, // Fills full tile height
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Colors.grey[200], // background for icon
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: loadImageWidget(
                                      mylist[index].imagename,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                mylist[index].title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (mylist[index].description.trim().isEmpty)
                                        ? "NA"
                                        : mylist[index].description,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      //edit item
                                      editItemDialog(mylist[index]);
                                    },
                                    child: Icon((Icons.edit)),
                                  ),
                                  Checkbox(
                                    value: value,
                                    onChanged: (value) {
                                      //dialog to confirm
                                      confirmDialogStatus(index, value!);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                //show details
                                showDetailsDialog(mylist[index]);
                              },
                              onLongPress: () {
                                //show dialog to delete item
                                deleteDialog(mylist[index].id);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    //build row with pagination buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            if (curpageno > 1) {
                              curpageno = curpageno - 1;
                              loadData();
                            }
                          },
                        ),
                        Text("Page $curpageno of $pages"),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            if (curpageno < pages) {
                              curpageno = curpageno + 1;
                              loadData();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewItemScreen()),
          );
          loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> loadData() async {
    //load data from sqlite db and display as list.
    mylist = [];
    setState(() {
      status = "Loading...";
    });
    int totalItems = await DatabaseHelper().getTotalCount();
    print(totalItems);
    pages = (totalItems / limit).ceil();
    int index = (curpageno - 1) * limit;
    mylist = await DatabaseHelper().getMyListsPaginated(
      limit,
      index,
    ); //limit 10();
    if (mylist.isEmpty) {
      status = "No List found. Add one now!";
    }
    setState(() {});
  }

  void deleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Item"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                await DatabaseHelper().deleteMyList(id);
                //show snackbar
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Item deleted")));
                loadData();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget loadImageWidget(String imagename) {
    // If no image stored
    if (imagename == "NA") {
      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
    }

    // If image exists
    final file = File(imagename);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.fill);
    }

    // If file path invalid or missing
    return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
  }

  void confirmDialogStatus(int index, bool value) {
    String st = "";

    if (value) {
      st = "Completed";
    } else {
      st = "Pending";
    }
    //dialog to confirm
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Status"),
          content: Text("Are you sure you want to update status to $st?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Update"),
              onPressed: () {
                Navigator.pop(context);
                if (value == true) {
                  mylist[index].status = "Completed";
                } else {
                  mylist[index].status = "Pending";
                }
                DatabaseHelper().updateMyList(mylist[index]);
                loadData();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void editItemDialog(MyList mylist) {
    TextEditingController titleController = TextEditingController(
      text: mylist.title,
    );
    TextEditingController descriptionController = TextEditingController(
      text: mylist.description,
    );
    bool value = false;
    if (mylist.status == "Pending") {
      value = false;
    } else {
      value = true;
    }
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, newSetState) {
            return AlertDialog(
              title: const Text("Update Item"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    maxLines: 5,
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),

                  //List status row
                  Row(
                    children: [
                      const Text("Status: "),
                      Checkbox(
                        value: value,
                        onChanged: (newValue) {
                          //dialog to confirm
                          value = newValue!;
                          newSetState(() {});
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("Update"),
                        onPressed: () async {
                          mylist.title = titleController.text;
                          mylist.status = value ? "Completed" : "Pending";
                          mylist.description = descriptionController.text;
                          await DatabaseHelper().updateMyList(mylist);
                          loadData();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showDetailsDialog(MyList mylist) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("List Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              loadImageWidget(mylist.imagename),
              SizedBox(height: 10),
              Text(
                mylist.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(mylist.description, textAlign: TextAlign.justify),
              Text("Status: ${mylist.status}"),
              Text("Date: ${mylist.date}"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Search Item"),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: "Search by title/Description",
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Search"),
              onPressed: () async {
                Navigator.pop(context);
                mylist = [];
                mylist = await DatabaseHelper().searchMyList(
                  searchController.text,
                );
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete All Items"),
          content: const Text("Are you sure you want to delete all items?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                await DatabaseHelper().deleteAll();
                //show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All items deleted.")),
                );
                loadData();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
