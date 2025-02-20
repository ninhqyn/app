import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class MyPlayListPage extends StatelessWidget{
  const MyPlayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration:  BoxDecoration(
                      boxShadow: const [BoxShadow(
                        blurRadius: 1,
                        offset: Offset(1, 1),
                        color: Color(0xFF000000),
                      )
                      ],
                      shape: BoxShape.circle,
                      color:const Color(0xFFC9FA85),
                      border: Border.all(
                        color: Colors.black, // Màu border
                        width: 1,  // Độ dày border
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/back.svg', // Đường dẫn đến tệp SVG của bạn
                        fit: BoxFit.contain, // Cách hiển thị icon
                      ),
                    ),
                  ),
                ),
                Text('Preview',style: TextStyle(
                    fontSize: 24,
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(0.2) ,
                          blurRadius: 1.0,
                          offset: const Offset(1, 1)
                      )
                    ]
                )),
                InkWell(
                  onTap: (){
                    showModalBottomSheet(context: context, builder:(context){
                      return Container(
                          width: double.infinity,

                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30)
                              ),color: Color(0xFFC9FA85),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, -4),
                                    blurRadius: 4
                                )
                              ]
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 30,bottom: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Save',style: TextStyle(fontSize: 24),),
                                SizedBox(height: 10,),
                                Text('Add to Flowers',style: TextStyle(fontSize: 24),),
                                SizedBox(height: 10,),
                                Text('Add to Vehicles',style: TextStyle(fontSize: 24),),
                                SizedBox(height: 10,),
                                Text('Add to Fruits',style: TextStyle(fontSize: 24),),
                                SizedBox(height: 10,),
                                Text('Cancel',style: TextStyle(fontSize: 24),)
                              ],
                            ),
                          ));
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration:  BoxDecoration(
                      boxShadow: const [BoxShadow(
                        blurRadius: 1,
                        offset: Offset(1, 1),
                        color: Color(0xFF000000),
                      )
                      ],
                      shape: BoxShape.circle,
                      color:const Color(0xFFC9FA85),
                      border: Border.all(
                        color: Colors.black, // Màu border
                        width: 1,  // Độ dày border
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/preview_action.svg', // Đường dẫn đến tệp SVG của bạn
                        fit: BoxFit.contain, // Cách hiển thị icon
                      ),
                    ),
                  ),
                )],
            )
        ),// Chiều cao của AppBar

      ),
      body: Container(
        child:Center(
          child: Image.asset('assets/images/NoItem.png'),
        ),
      ),
      ),
    );
  }

}