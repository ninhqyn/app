import 'dart:typed_data';

class Note{
 int id;
 String name;
 Uint8List image;

 Note(this.id, this.name, this.image);
 // Chuyển đối tượng thành Map để lưu vào SQLite
 Map<String, dynamic> toMap() {
  return {
   'name': name,
   'image': image,
  };
 }

 // Chuyển Map thành đối tượng Note
 factory Note.fromMap(Map<String, dynamic> map) {
  return Note(
   map['id'],
   map['name'],
   map['image'],
  );
 }
}