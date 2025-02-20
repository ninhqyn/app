import 'package:flash_card_app/widget/card_title.dart';
import 'package:flash_card_app/widget/my_app_bar.dart';
import 'package:flash_card_app/widget/my_toggle_switch.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';


class NewFlashCard extends StatefulWidget
{
  const NewFlashCard({super.key});

  @override
  State<NewFlashCard> createState() => _NewFlashCardState();
}

class _NewFlashCardState extends State<NewFlashCard> {
  List<Color> items=[
    const Color(0xFFFA85BE),
    const Color(0xFFFA8585),
    const Color(0xFFFABC85),
    const Color(0xFFC9FA85),
    const Color(0xFF85FA9A),
    const Color(0xFF8985FA),
    const Color(0xFFC385FA)
  ];
  var selectedIndex ;
  int labelIndex = 1;
  void navigationPage(String route){
    Navigator.pushNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("New Flash Card"),

          ),
          body:  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                       const MyAppBar(title: 'New FlashCard',
                        urlAction: 'assets/images/check.svg',routeName: '/preview',),
                      const SizedBox(height: 30,),
                      const CardTitle(
                        urlImage: 'assets/images/input.svg',
                        title: 'Text',
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFC9FA85),
                          border: Border.all(
                            color: Colors.black,
                            width: 2
                          ),
                          boxShadow: const[
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 2
                            )
                          ]
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: '...',
                            hintStyle: TextStyle(
                              fontSize: 40,  // Kích thước của text gợi ý
                              color: Colors.black,  // Màu sắc của hintText
                            ),
                            border: InputBorder.none,  // Bỏ viền
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),  // Căn chỉnh nội dung bên trong
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      CardTitle(
                        urlImage: 'assets/images/image.svg',
                        title: 'Image/Video',
                        iconButton: IconButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/image');
                            }
                            , icon: SvgPicture.asset(
                          'assets/images/add.svg', // Đường dẫn đến tệp SVG của bạn
                          fit: BoxFit.contain, // Cách hiển thị icon
                        ),),
                      ),
                      const SizedBox(height:30,),
                      CardTitle(
                        urlImage: 'assets/images/record.svg',
                        title: 'Image/Video',
                        iconButton: IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/file');
                          }
                          , icon: SvgPicture.asset(
                          'assets/images/add.svg', // Đường dẫn đến tệp SVG của bạn
                          fit: BoxFit.contain, // Cách hiển thị icon
                        ),),
                      ),
                      const SizedBox(height: 30,),
                      const CardTitle(
                        urlImage: 'assets/images/color.svg',
                        title: 'Color',
                      ),
                      const SizedBox(height: 10,),
            
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        //splashColor: ,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: items[index],
                              borderRadius: BorderRadius.circular(15), // Bo góc
                              border: Border.all(
                                color: index != selectedIndex ? Colors.transparent : Colors.black,
                                width: 2,
                              ),
                              boxShadow: index == selectedIndex
                                  ? const [
                                BoxShadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 2,
                                  color: Colors.black, // Thêm bóng khi được chọn
                                ),
                              ]
                                  : const [],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
            
            
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 100,
            child: Center(
              child:Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 2
                    )
                  ]
                ),
                  child: MyToggleSwitch(labelIndex))
            ),
            ),
          ),

    );
  }
}