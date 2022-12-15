class DataModel{
  final int ? id;
  final String name; 
 

DataModel({this.id, required this.name});

  factory DataModel.fromMap(Map<String, dynamic> jsonValue){
    return DataModel(id:jsonValue['id'],name: jsonValue['name']);
  }

 
  Map<String, dynamic> toMap()=>{
    "id":id,
    "name":name,
  };
}