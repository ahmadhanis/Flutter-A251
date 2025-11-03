class MyList {
  int id;
  String title;
  String description;
  String status;
  String date;
  String imagename;

  MyList(
    this.id,
    this.title,
    this.description,
    this.status,
    this.date,
    this.imagename,
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'date': date,
      'imagename': imagename,
    };
  }

  factory MyList.fromMap(Map<String, dynamic> map) {
    return MyList(
      map['id'],
      map['title'],
      map['description'],
      map['status'],
      map['date'],
      map['imagename'],
    );
  }
}
