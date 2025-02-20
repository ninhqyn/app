import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
class UploadFile extends StatelessWidget{
  const UploadFile({super.key});

  Future<bool> _request_per(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      Permission.storage.request();
      if (await permission.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Column(
          children: [
            const Flexible(flex:1,child: Center(child: Text('Upload File',style: TextStyle(fontSize: 32,fontWeight: FontWeight.w700),))),
            Flexible(
              flex: 9,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: 0.5,
                        child: SvgPicture.asset('assets/images/home_background.svg'),
                      )),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 0.6,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double columnHeight = constraints.maxHeight;
                        double containerWidth = columnHeight / 5;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () async {
                                if( true == await _request_per(Permission.storage)) {
                                  Navigator.pushNamed(context,'/choose-video',arguments: {
                                    'page':'device'
                                  });
                                }else{
                                  print('not granted');
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 40),
                                decoration:BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50)
                                    ),
                                    border: Border.all(
                                        width: 1
                                    ),
                                    color: Colors.white
                                ),
                                height: containerWidth,
                                width: double.infinity,  // Chỉnh sửa thành double.infinity để chiếm toàn bộ chiều rộng
                                child: Row(
                                  children: [
                                    const Expanded(flex:3,child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: Text('Device'),
                                    )),
                                    Expanded(flex: 1,child: SvgPicture.asset('assets/images/next.svg'))
                                  ],

                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if( true == await _request_per(Permission.storage)) {
                                  Navigator.pushNamed(context,'/choose-video',arguments: {
                                    'page':'file'
                                  });
                                }else{
                                  print('not granted');
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 30),
                                decoration:   BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50)
                                    ),
                                    border: Border.all(
                                        width: 1
                                    ),
                                    color: Colors.white
                                ),
                                height: containerWidth,
                                width: double.infinity,  // Chỉnh sửa thành double.infinity để chiếm toàn bộ chiều rộng
                                child: Row(
                                  children: [
                                    const Expanded(flex: 3,child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: Text('Files'),
                                    )),
                                    Expanded(flex: 1,child: SvgPicture.asset('assets/images/next.svg'))
                                  ],

                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, '/wifi-transfer');
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 30),
                                decoration:   BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50)
                                    ),
                                    border: Border.all(
                                        width: 1
                                    ),
                                    color: Colors.white
                                ),
                                height: containerWidth,
                                width: double.infinity,  // Chỉnh sửa thành double.infinity để chiếm toàn bộ chiều rộng
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Text('Wifi Transfer'),
                                      ),
                                    ),
                                    Expanded(flex: 1,child: SvgPicture.asset('assets/images/next.svg'))
                                  ],

                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )],
              ),
            ),
            const Spacer(
              flex: 1,
            )
          ],
        )
    );
  }

}