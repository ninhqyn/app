import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class StreamVideo extends StatefulWidget{
  const StreamVideo({super.key});

  @override
  State<StreamVideo> createState() => _StreamVideoState();
}

class _StreamVideoState extends State<StreamVideo> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text('Stream by link',style: TextStyle(fontSize: 32,fontWeight: FontWeight.w700),),
                  ),
                  Expanded(flex:2,child: SvgPicture.asset('assets/images/stream_video.svg')),
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 22,),
                         Expanded(child: TextField(
                           controller: controller,
                           decoration: InputDecoration(
                          hintText: 'Paste link stream',
                          hintStyle: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.3)),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(40),
                             borderSide: const BorderSide(color: Colors.black, width: 1), // Màu viền khi không được chọn
                           ),
                           // Thiết lập màu viền khi trường nhập liệu đang được chọn (focused)
                           focusedBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(40),
                             borderSide: const BorderSide(color: Colors.blue, width: 2), // Màu viền khi trường nhập liệu đang được chọn
                           ),
                           contentPadding: const EdgeInsets.symmetric(horizontal: 20)
                        )
                          ,)
                        ),
                        const SizedBox(width: 10,),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: const CircleBorder(),
                            side: const BorderSide( // Đặt màu và độ dày của viền
                              color: Colors.black, // Màu của viền
                              width: 1, // Độ dày của viền
                            ),
                            minimumSize: const Size(50, 50),
                            padding: EdgeInsets.zero
                          ),
                            onPressed: (){
                             Navigator.pushNamed(context, '/play-video',arguments: {
                               'page':'steam',
                               'path':controller.text
                             });
                            },
                            child: SvgPicture.asset('assets/images/next.svg')
                        ),const SizedBox(width: 22,),
                      ],
                    ),
                  )
                ],
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