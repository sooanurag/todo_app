const String tableName = "notes";

//this fields used as fields in writing sql query,
//this help in updating it easly
class DatabaseFields {
  static const String id = "_id";
  static const String title = "title";
  static const String description = "description";
  static const String isImportant = "isImportant";
  static const String number = "number";
  static const String createdTime = "createdTime";
}

//data of a row, encapsulated in an object
class Notes {
  final int? id;
  final String title;
  final String description;
  final bool isImportant;
  final int number;
  final DateTime createdTime;

  Notes({
    this.id,
    required this.title,
    required this.description,
    required this.isImportant,
    required this.number,
    required this.createdTime,
  });

// as we took id nullable so that we dont have pass id everytime,
// therefore, when insert returns int, then we copy the object and updating the id here.
// if we dont use copy, then we have to pass a new object to update,
// and have to pass values which we are not updating with updated values.
  Notes copy({
    int? id,
    String? title,
    String? description,
    bool? isImportant,
    int? number,
    DateTime? createdTime,
  }) =>
      Notes(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        createdTime: createdTime ?? this.createdTime,
      );

  Map<String, dynamic> toJson() => {
        DatabaseFields.id: id,
        DatabaseFields.title: title,
        DatabaseFields.description: description,
        DatabaseFields.number: number,
        //in Sql db, bool values represented as 0 or 1.
        DatabaseFields.isImportant: isImportant ? 1 : 0,
        //there no such datatype in sql so need to covert it.
        //Returns an ISO-8601 full-precision extended format representation.
        DatabaseFields.createdTime: createdTime.toIso8601String(),
      };

  static Notes fromJson(Map<String, dynamic> json) => Notes(
        id: json[DatabaseFields.id] as int?,
        title: json[DatabaseFields.title] as String,
        description: json[DatabaseFields.description] as String,
        isImportant: json[DatabaseFields.isImportant] == 1 ? true : false,
        number: json[DatabaseFields.number] as int,
        createdTime: DateTime.parse(json[DatabaseFields.createdTime] as String),
      );
}
