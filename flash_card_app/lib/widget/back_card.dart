import 'package:flash_card_app/widget/video_play.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
class BackFlashCard extends StatefulWidget{
  final double weight,height;
  final Widget image;
  BackFlashCard({super.key, required this.weight, required this.height, required this.image});

  @override
  State<BackFlashCard> createState() => _BackFlashCardState();
}

class _BackFlashCardState extends State<BackFlashCard> {
  final GlobalKey<VideoPlayState> _videoPlayKey = GlobalKey<VideoPlayState>();
  void _cleanupVideo() {
    if (widget.image is VideoPlay) {
      final videoState = _videoPlayKey.currentState;
      if (videoState != null) {
        videoState.cleanupVideo();
      }
    }
  }

  @override
  void dispose() {
    _cleanupVideo();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _cleanupVideo();
        return true;
      },
      child: Card(
          color: Colors.pink,
          elevation: 4,
          shadowColor: Colors.black,
          child:Container(
            width: widget.weight,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2), // Đặt border cho card
              borderRadius: BorderRadius.circular(10), // Bo góc cho card
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Màu bóng
                  blurRadius: 8, // Độ mờ của bóng
                  offset: const Offset(0, 4), // Vị trí bóng
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: widget.height/2+widget.height/10,
                    // Bo góc với bán kính 20
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.image,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text("day la a lads dssddsoi" ,style :TextStyle(
                          fontSize: 24
                      ),maxLines: 2,textAlign: TextAlign.center,),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/images/loa.svg',
                      fit: BoxFit.contain, // Cách hiển thị icon
                              ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}