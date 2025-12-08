import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mylistv2/databasehelper.dart';
import 'package:mylistv2/loginscreen.dart';
import 'package:mylistv2/mylist.dart';
import 'package:mylistv2/newitemscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MyList> mylist = [];
  int curpageno = 1;
  int limit = 5;
  int pages = 1;
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F7),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8E3B8E),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewItemScreen()),
          );
          loadData();
        },
      ),

      body: Column(
        children: [
          // ---------------------------------------------------------
          // HEADER
          // ---------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E3B8E), Color(0xFF6A1B9A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    // Centered title
                    Center(
                      child: Text(
                        "MyList V2",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Icon aligned far right
                    Positioned(
                      right: 40,
                      child: IconButton(
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          //push to login dialog
                          showLogoutDialog();
                        },
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.info, color: Colors.white),
                        onPressed: () {
                          showAboutAndDonate();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Search bar
                // 🔍 Search Bar (Modern Floating Style + Reset Button)
                Container(
                  width: screenWidth * 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),

                      const SizedBox(width: 8),

                      // Tappable search field
                      Expanded(
                        child: GestureDetector(
                          onTap: showSearchDialog,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              "Search tasks...",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ❌ Reset Search Button
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        tooltip: "Reset search",
                        onPressed: () {
                          loadData(); // reload full list
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Search reset")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------
          // CONTENT AREA
          // ---------------------------------------------------------
          Expanded(
            child: mylist.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.folder_open_rounded,
                            size: 60,
                            color: Color(0xFF8E3B8E),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "No task found. Add one to get started!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: mylist.length,
                    itemBuilder: (_, index) {
                      final item = mylist[index];
                      final isCompleted = item.status == "Completed";
                      return InkWell(
                        onTap: () => showDetailsDialog(item),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // =====================================================================
                              // 1) IMAGE SECTION - takes 30% width
                              // =====================================================================
                              SizedBox(
                                width: screenWidth * 0.20,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: loadImageWidget(item.imagename),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // =====================================================================
                              // 2) CONTENT SECTION - takes ~50% width
                              // =====================================================================
                              SizedBox(
                                width: screenWidth * 0.50 - 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      item.description.trim().isEmpty
                                          ? "NA"
                                          : item.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? Colors.green[100]
                                            : Colors.orange[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        item.status,
                                        style: TextStyle(
                                          color: isCompleted
                                              ? Colors.green[800]
                                              : Colors.orange[800],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // =====================================================================
                              // 3) ACTION BUTTONS SECTION - remaining width (~20%)
                              // =====================================================================
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Top Row: Edit + Delete icons
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 22,
                                          ),
                                          onPressed: () => editItemDialog(item),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 22,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              deleteDialog(item.id),
                                        ),
                                      ],
                                    ),

                                    // Bottom: Checkbox
                                    Checkbox(
                                      value: isCompleted,
                                      onChanged: (val) =>
                                          confirmDialogStatus(index, val!),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Pagination
          if (mylist.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: curpageno > 1
                        ? () {
                            curpageno--;
                            loadData();
                          }
                        : null,
                  ),
                  Text(
                    "Page $curpageno of $pages",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: curpageno < pages
                        ? () {
                            curpageno++;
                            loadData();
                          }
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // IMAGE LOADER
  // ---------------------------------------------------------
  Widget loadImageWidget(String imagename) {
    if (imagename == "NA") {
      return const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      );
    }
    final file = File(imagename);
    return file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : const Icon(Icons.broken_image, size: 40, color: Colors.grey);
  }

  // ---------------------------------------------------------
  // LOAD DATA + PAGINATION
  // ---------------------------------------------------------
  Future<void> loadData() async {
    setState(() {
      status = "Loading...";
      mylist = [];
    });

    final total = await DatabaseHelper().getTotalCount();
    pages = (total / limit).ceil();

    int offset = (curpageno - 1) * limit;
    mylist = await DatabaseHelper().getMyListsPaginated(limit, offset);

    if (mylist.isEmpty) status = "Not Available.";
    setState(() {});
  }

  // ---------------------------------------------------------
  // DELETE ITEM
  // ---------------------------------------------------------
  void deleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),

                // Title
                const Text(
                  "Delete Entry?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  "This action cannot be undone.\nAre you sure you want to remove this entry from your list?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Delete Button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          await DatabaseHelper().deleteMyList(id);
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Entry deleted successfully"),
                              ),
                            );
                          }
                          loadData();
                        },
                        child: const Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // UPDATE STATUS
  // ---------------------------------------------------------
  void confirmDialogStatus(int index, bool value) {
    final MyList item = mylist[index];
    final String newStatus = value ? "Completed" : "Pending";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎨 Icon
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E3B8E).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    value ? Icons.check_circle : Icons.pending_actions,
                    size: 45,
                    color: const Color(0xFF8E3B8E),
                  ),
                ),

                const SizedBox(height: 20),

                // 📝 Title
                Text(
                  "Update Status",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A1B9A),
                  ),
                ),

                const SizedBox(height: 10),

                // 📌 Message
                Text(
                  "Do you want to mark this task as $newStatus?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),

                const SizedBox(height: 25),

                // 🔘 Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8E3B8E),
                          side: const BorderSide(color: Color(0xFF8E3B8E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Update button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E3B8E),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Update"),
                        onPressed: () async {
                          Navigator.pop(context);

                          // Update backend
                          item.status = newStatus;
                          await DatabaseHelper().updateMyList(item);

                          // Refresh UI
                          loadData();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Status updated to $newStatus"),
                                // backgroundColor: Colors.green[600],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // EDIT ITEM
  // ---------------------------------------------------------
  void editItemDialog(MyList item) {
    TextEditingController titleController = TextEditingController(
      text: item.title,
    );

    TextEditingController descriptionController = TextEditingController(
      text: item.description,
    );

    bool isCompleted = item.status == "Completed";

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------
                    // TITLE
                    // ---------------------------------------------------
                    const Text(
                      "Edit Entry",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ---------------------------------------------------
                    // TITLE INPUT
                    // ---------------------------------------------------
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ---------------------------------------------------
                    // DESCRIPTION INPUT
                    // ---------------------------------------------------
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Description",
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ---------------------------------------------------
                    // STATUS SWITCH
                    // ---------------------------------------------------
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green[50]
                            : Colors.orange[50],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.pending_outlined,
                            color: isCompleted
                                ? Colors.green[700]
                                : Colors.orange[700],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isCompleted ? "Completed" : "Pending",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isCompleted
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: isCompleted,
                            activeThumbColor: Colors.green,
                            onChanged: (val) {
                              setState(() => isCompleted = val);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------------------------------------------------
                    // ACTION BUTTONS
                    // ---------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                          ),
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),

                        const SizedBox(width: 10),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8E3B8E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Update"),
                          onPressed: () async {
                            if (titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Title cannot be empty."),
                                ),
                              );
                              return;
                            }

                            item.title = titleController.text.trim();
                            item.description = descriptionController.text
                                .trim();
                            item.status = isCompleted ? "Completed" : "Pending";

                            await DatabaseHelper().updateMyList(item);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                            loadData();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // DETAILS DIALOG
  // ---------------------------------------------------------
  void showDetailsDialog(MyList item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: loadImageWidget(item.imagename),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    item.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _infoChip(
                        Icons.check_circle,
                        item.status,
                        item.status == "Completed"
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                      const SizedBox(width: 10),
                      _infoChip(
                        Icons.calendar_today,
                        item.date,
                        Colors.blueGrey[700],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E3B8E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Close"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String text, Color? color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SEARCH DIALOG
  // ---------------------------------------------------------
  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // -------------------------------------------
                // TITLE
                // -------------------------------------------
                const Text(
                  "Search List",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // -------------------------------------------
                // SEARCH BAR
                // -------------------------------------------
                TextField(
                  controller: searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _performSearch(searchController.text),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    hintText: "Search by title or description...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // -------------------------------------------
                // BUTTONS
                // -------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E3B8E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: const Text("Search"),
                      onPressed: () {
                        _performSearch(searchController.text);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performSearch(String keyword) async {
    mylist = await DatabaseHelper().searchMyList(keyword.trim());
    status = mylist.isEmpty ? "No task match your search." : "";
    setState(() {});
  }

  void showAboutAndDonate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("About & Donate"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "MyList V2\nA simple and beautiful task manager.\n\n"
                "If you find this app useful, consider supporting its development!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.favorite),
                label: const Text("Donate"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E3B8E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // tap outside to dismiss
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // -------------------------------------------------------
                // ICON
                // -------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.12),
                  ),
                  child: const Icon(Icons.logout, size: 42, color: Colors.red),
                ),

                const SizedBox(height: 20),

                // -------------------------------------------------------
                // TITLE
                // -------------------------------------------------------
                const Text(
                  "Logout?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                // -------------------------------------------------------
                // MESSAGE
                // -------------------------------------------------------
                Text(
                  "Are you sure you want to logout from MyList V2?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 26),

                // -------------------------------------------------------
                // BUTTONS
                // -------------------------------------------------------
                Row(
                  children: [
                    // CANCEL BUTTON
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8E3B8E),
                          side: const BorderSide(color: Color(0xFF8E3B8E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // LOGOUT BUTTON
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E3B8E),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Logout"),
                        onPressed: () {
                          Navigator.pop(context); // close dialog first
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
