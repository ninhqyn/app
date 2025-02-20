class FileModel {
  final int id;
  final String name;
  final String path;
  final int size;
  final String type;

  FileModel({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.type,
  });

  // Convert từ Map sang Object với xử lý null safety
  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      path: map['path'] as String? ?? '',
      size: map['size'] as int? ?? 0,
      type: map['type'] as String? ?? 'audio', // Giá trị mặc định là 'audio'
    );
  }

  // Convert từ Object sang Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'size': size,
      'type': type,
    };
  }

  // Copy with method để tạo bản sao với các giá trị mới
  FileModel copyWith({
    int? id,
    String? name,
    String? path,
    int? size,
    String? type,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      type: type ?? this.type,
    );
  }

  // Override toString để dễ debug
  @override
  String toString() {
    return 'FileModel(id: $id, name: $name, path: $path, size: $size, type: $type)';
  }

  // Override equals để so sánh các đối tượng
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileModel &&
        other.id == id &&
        other.name == name &&
        other.path == path &&
        other.size == size &&
        other.type == type;
  }

  // Override hashCode
  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    path.hashCode ^
    size.hashCode ^
    type.hashCode;
  }
}
