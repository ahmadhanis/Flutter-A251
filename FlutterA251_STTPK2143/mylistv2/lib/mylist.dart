class MyList {
  String title;
  String description;
  String status;
  String date;
  String imagename;

  MyList(
    this.title,
    this.description,
    this.status,
    this.date,
    this.imagename,
  );
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'date': date,
      'imagename': imagename,
    };
  }

  factory MyList.fromMap(Map<String, dynamic> map) {
    return MyList(
      map['title'],
      map['description'],
      map['status'],
      map['date'],
      map['imagename'],
    );
  }
}
