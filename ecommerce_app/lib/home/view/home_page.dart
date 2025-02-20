
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/card_item.dart';
class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> items =[
      Image.asset('assets/images/image5.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity),
      // Image.asset('assets/images/image4.png',
      //     fit: BoxFit.fill,
      //     width: double.infinity,
      //     height: double.infinity),
      Container(
        color: Colors.white,
      ),
      Image.asset('assets/images/image3.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity),
      Image.asset('assets/images/image4.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity
      ),
    ]; 
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               CarouselSlider(
                   items: List.generate(5, (index){
                     return _Banner();
                   }),
                   options: CarouselOptions(
                       height: 2/3*MediaQuery.of(context).size.height,
                       aspectRatio: 16/9,
                       viewportFraction: 1.0,
                       autoPlay: true,
                       scrollDirection: Axis.horizontal
                   )
               ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('New',style: TextStyle(
                        color:Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    InkWell(onTap:(){} ,
                        child: const Text('View all',style: TextStyle(fontSize: 11),))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('You\'ve never seen it before!'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 260,
                  child: ListView.builder(
                      itemCount: 10,
                      scrollDirection:  Axis.horizontal,
                      physics: const BouncingScrollPhysics(),  // Thêm hiệu ứng cuộn mượt
                      //shrinkWrap:true,
                      itemBuilder: (context,index){
                        return  const CardItem(
                          textTag: Text('new',style: TextStyle(color: Colors.white,fontSize: 11)),
                          colorTag: Colors.red,);
                      }
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sale',style: TextStyle(
                        color:Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.bold
                    ),
                    ),
                    InkWell(onTap:(){} ,
                        child: const Text('View all',style: TextStyle(fontSize: 11),))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Super summer sale!'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 260,
                  child: ListView.builder(
                      itemCount: 10,
                      scrollDirection:  Axis.horizontal,
                      physics: const BouncingScrollPhysics(),  // Thêm hiệu ứng cuộn mượt
                      //shrinkWrap:true,
                      itemBuilder: (context,index){
                        return  const CardItem(
                          textTag: Text('sale',style: TextStyle(color: Colors.white,fontSize: 11)),
                          colorTag: Colors.black,);
                      }
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              GridView.custom(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: [
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(1, 1),
                    const QuiltedGridTile(2, 1),
                    const QuiltedGridTile(1, 1),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) {
                    int remainder = index % 4;
                    Widget customText;

                    // Sử dụng switch để xử lý các trường hợp dựa trên phần dư
                    switch (remainder) {
                      case 0:
                        customText =  const Positioned(
                          bottom: 20,
                          right: 10,
                          child: Text('New collection',style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0, // Độ mờ của bóng
                                color: Colors.black, // Màu bóng
                                offset: Offset(4.0, 4.0), // Vị trí bóng mờ
                              ),
                            ],
                          ),),
                        );
                        break;
                      case 1:
                        customText =  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text('Summer sale',style: TextStyle(
                              color: Colors.red,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0, // Độ mờ của bóng
                                color: Colors.black.withOpacity(0.8), // Màu bóng
                                offset: const Offset(2.0, 2.0), // Vị trí bóng mờ
                              ),
                            ],
                          ),),
                        );
                        break;
                      case 2:
                        customText = const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30
                          ),
                          child: Text('Men\'s hoodies',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0, // Độ mờ của bóng
                                  color: Colors.black, // Màu bóng
                                  offset: Offset(4.0, 4.0), // Vị trí bóng mờ
                                ),
                              ],
                          ),
                            textAlign: TextAlign.center,
                          ),
                        );
                        break;
                      case 3:
                        customText = const Positioned(
                          bottom: 20,
                          left: 10,
                          child: Text('Black',style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0, // Độ mờ của bóng
                                color: Colors.black, // Màu bóng
                                offset: Offset(4.0, 4.0), // Vị trí bóng mờ
                              ),
                            ],
                          ),),
                        );
                        break;
                      default:
                        customText = const Text('Default Case');
                    }
                    return Container(
                      color: Colors.red,
                      child: Stack(
                        alignment: Alignment.center,
                       children: [
                           items[index],
                           customText
                       ],
                      ),
                    );
                  },
              childCount: items.length
            ),
          )
            ],
          ),
        )
    );
  }

}



class _Banner extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.bottomCenter,
      children:  [
        Image.asset(
          'assets/images/banner1.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 2/3*MediaQuery.of(context).size.height,),
        const Positioned(
            left: 10,bottom: 60,
            child: Text('FASHION\nsale',style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold),
            )
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10,bottom: 20,top: 10),
            child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(160, 36)
                ),
                child: const Text('CHECK',style: TextStyle(color: Colors.white,fontSize: 14),)),
          ),
        )
      ],
    );
  }

}