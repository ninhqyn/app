import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class WifiTransferScreen extends StatefulWidget {
  const WifiTransferScreen({super.key});

  @override
  _WifiTransferScreenState createState() => _WifiTransferScreenState();
}

class _WifiTransferScreenState extends State<WifiTransferScreen> {
  late HttpServer _server;
  String _url = "Not started yet";

  @override
  void initState() {
    super.initState();
   _initializeServer();
  }
  Future<void> _initializeServer() async {
    try {
      // Lấy địa chỉ IP của WiFi
      final info = NetworkInfo();
      final wifiIP = await info.getWifiIP();
      print('Server running at IP: $wifiIP');

      // Khởi tạo HttpServer và bind vào port 8080
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

      // Cập nhật URL để thông báo cho người dùng
      _url = 'http://$wifiIP:8080/';
      //_url = 'http://10.0.2.2:8080';
      print('Server started at $_url');

      // Cập nhật lại UI để hiển thị URL
      setState(() {});

      // Lắng nghe các yêu cầu HTTP
      _server.listen((HttpRequest request) async {
        try {
          // Kiểm tra phương thức của yêu cầu
          if (request.method == 'GET') {
            // Trả về một trang HTML đơn giản khi có yêu cầu GET
            request.response.headers.contentType = ContentType.html;
            request.response.write('''
            <!DOCTYPE html>
            <html>
              <head>
                <title>WiFi Transfer</title>
              </head>
              <body>
                <h1>WiFi Transfer is working!</h1>
                <p>Server is running at $_url</p>
              </body>
            </html>
          ''');
            await request.response.close(); // Đóng kết nối
          } else {
            // Trường hợp khác không phải GET
            request.response.statusCode = HttpStatus.methodNotAllowed;
            request.response.write('Method not allowed');
            await request.response.close();
          }
        } catch (e) {
          // Nếu có lỗi, gửi mã lỗi cho yêu cầu
          print('Error handling request: $e');
          request.response.statusCode = HttpStatus.internalServerError;
          await request.response.close();
        }
      });

    } catch (e) {
      print('Error starting server: $e');
    }
  }



  @override
  void dispose() {
    _server.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Wi-Fi File Transfer",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: SvgPicture.asset('assets/images/wifi_trans.svg')),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,  // Màu mặc định cho văn bản
                      fontSize: 16,  // Kích thước chữ
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: "Please access ",  // Đoạn văn bản đầu tiên
                        style: TextStyle(
                          fontWeight: FontWeight.normal,  // Chữ bình thường
                        ),
                      ),
                      TextSpan(
                        text: _url,  // Đoạn văn bản chứa URL
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold, // Chữ đậm (bold)
                          color: Colors.black,  // Màu đen
                        ),
                      ),
                      const TextSpan(
                        text: " to transfer data between your computer and phone",  // Đoạn văn bản sau URL
                        style: TextStyle(
                          fontWeight: FontWeight.normal,  // Chữ bình thường
                        ),
                      ),
                    ],
                  ),
                ),
              )

              // ElevatedButton(
              //   onPressed: () {
              //     // Tải tệp từ server qua Wi-Fi
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => DownloadFileScreen(url: _url),
              //       ),
              //     );
              //   },
              //   child: const Text("Download File"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadFileScreen extends StatelessWidget {
  final String url;

  DownloadFileScreen({required this.url});

  Future<void> _downloadFile() async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse('$url/file'));
    final response = await request.close();

    // Lấy dữ liệu tệp từ response
    if (response.statusCode == 200) {
      final fileBytes = await consolidateHttpClientResponseBytes(response);
      // Lưu tệp vào bộ nhớ
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/downloaded_file.mp4';
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);
      print("File saved to $filePath");
    } else {
      print("Failed to download file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download File"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _downloadFile,
          child: const Text("Download File"),
        ),
      ),
    );
  }
}
