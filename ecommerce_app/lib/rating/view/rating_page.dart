import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class RatingPage extends StatelessWidget{
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating and reviews'),
      ),
      body: const RatingView(),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
          onPressed: (){}, child:
    Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/create.svg'),
          SizedBox(
              width: MediaQuery.of(context).size.width/4,
              height: 36,
              child: const Center(child: Text('Write a review',style:
                TextStyle(
                  color: Colors.white
                ),)
              )
          )
        ],
      )),
    );
  }

}

class RatingView extends StatelessWidget {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rating&Reviews',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 34
          ),),
          const SizedBox(height: 30,),
          _CardRating(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('8 Reviews',style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),),
                Row(

                  children: [
                    Icon(Icons.check_box_outline_blank),
                    SizedBox(width: 10,),
                    Text('With photo')
                  ],
                ),

              ],
            ),
          ),
          const CardReview()
        ],
      ),
    );
  }

}

class CardReview extends StatelessWidget {
  const CardReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 25,
                  color: Colors.black.withOpacity(0.1)
                )
              ]
            ),
           
            child: Padding(
                padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name of account',style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(5, (index){
                          if(index == 5){
                            return const Icon(Icons.star_border,);
                          }
                          return const Icon(Icons.star,color: Colors.yellow,);
                        }),
                      ),
                      const Text('Jun 5,2020',style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11
                      ),)
                    ],
                  ),
                  const Text('The dress is great! Very classy '
                      'and comfortable. It fit perfectly! I\'m 5\'7" an'
                      'd 130 pounds. I am a 34B chest. This dress wo'
                      'uld be too long for those w'
                      'ho are shorter but could be hemmed. I wouldn\'t recommend it fo'
                      'r those big chested as I am smaller chested and it fit me perfect'
                      'ly. The underarms were not too wide and '
                      'the dress was made well.',style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                  ),),
                  SizedBox(
                    height: MediaQuery.of(context).size.width/3,
                    child: ListView.separated(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(8), // Bo góc ảnh
                          child: Image.asset(
                          'assets/images/banner1.png',width: MediaQuery.of(context).size.width/3, // Tải ảnh từ assets
                          fit: BoxFit.cover, // Đảm bảo ảnh vừa với khung
                          ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(width: 10,); },)
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Helpful',style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11
                      ),),
                      const SizedBox(width: 5,),
                      SvgPicture.asset('assets/images/like.svg',width: 24,height: 22,)
                    ],
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            top: -16,
            child: CircleAvatar(
              radius: 16, // Bán kính của avatar
              backgroundImage: AssetImage('assets/images/banner1.png'), // Sử dụng hình ảnh trong assets
              // Hoặc backgroundColor để chọn màu nền cho avatar nếu không có hình ảnh
            ),
          ),

        ],
      ),
    );
  }

}

class _CardRating  extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            children: [
              Text('4.3',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 34
              ),),
              Text('23 ratings',style: TextStyle(
                color: Colors.grey,
                fontSize: 11
              ),)
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end
          ,
          children: List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: List.generate(5 - index, (starIndex) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  );
                }),
              ),
            );
          }), // Đảo ngược thứ tự để hiển thị 5 sao -> 1 sao
        ),
        const SizedBox(width: 10,),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRatingBar(12, 23, '5'), // 12/23 đánh giá 5 sao
              _buildRatingBar(5, 23, '4'),  // 5/23 đánh giá 4 sao
              _buildRatingBar(4, 23, '3'),  // 4/23 đánh giá 3 sao
              _buildRatingBar(2, 23, '2'),  // 2/23 đánh giá 2 sao
              _buildRatingBar(0, 23, '1'),  // 0/23 đánh giá 1 sao
            ],
          ),
        )

      ],
    );
  }
  Widget _buildRatingBar(int count, int total, String stars) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: count / total,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 24,
          height: 35,
          child: Text('$count'),
        ),
      ],
    );
  }
}