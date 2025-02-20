

import 'dart:typed_data';

class ItemModel{
  int id;
  String name;
  Uint8List data;

  ItemModel(this.id, this.name, this.data);
// Chuyển đối tượng thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'data': data,
    };
  }

  // Chuyển Map thành đối tượng ItemModel
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      map['id'],
      map['name'],
      map['data'],
    );
  }
}