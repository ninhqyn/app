
import 'package:flutter/cupertino.dart';

class LeftClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Ở ây, chúng ta sẽ định nghĩa đường dẫn để cắt phần bên trái

    // Cắt một phần tư phía trên bên trái
    path.moveTo(size.width+30, 10); // Điểm bắt đầu (góc trên bên trái)
    path.lineTo(10, 5); // Vẽ đường thẳng sang phải
    path.lineTo(10 , size.height); // Vẽ đường thẳng xuống dưới
    path.lineTo(size.width, size.height+20); // Vẽ đường thẳng sang trái
    path.close(); // Đóng đường dẫn

    // Bạn có thể tùy chỉnh đường dẫn để tạo các hình dạng khác nhau
    // Sử dụng các hàm như lineTo, quadraticBezierTo, cubicTo,...

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class MyClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Ở ây, chúng ta sẽ định nghĩa đường dẫn để cắt phần bên trái

    // Cắt một phần tư phía trên bên trái
    path.moveTo(size.width+30, 5); // Điểm bắt đầu (góc trên bên trái)
    path.lineTo(10, 5); // Vẽ đường thẳng sang phải
    path.lineTo(10 , size.height); // Vẽ đường thẳng xuống dưới
    path.lineTo(size.width, size.height+30); // Vẽ đường thẳng sang trái
    path.close(); // Đóng đường dẫn

    // Bạn có thể tùy chỉnh đường dẫn để tạo các hình dạng khác nhau
    // Sử dụng các hàm như lineTo, quadraticBezierTo, cubicTo,...

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}