import 'package:flash_card_app/features/media/media_manager.dart';
import 'package:flash_card_app/interface/media_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flash_card_app/model/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class MyFlashCard extends StatefulWidget{
  final double weight,height;
  final Flashcard card;
  final Function(MediaController controller)? onControllerReady;
  const MyFlashCard({super.key, required this.weight, required this.height, required this.card, this.onControllerReady});

  @override
  State<MyFlashCard> createState() => _MyFlashCardState();
}

class _MyFlashCardState extends State<MyFlashCard> implements MediaController{

  int indexSelected = 0;
  VideoPlayerController? controller;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlayAudio = false;
  final MediaManager _mediaManager = MediaManager();
  Color hexStringToColor(String colorString) {
    String hexColor = colorString.replaceAll("Color(", "").replaceAll(")", "");
    return Color(int.parse(hexColor));
  }
  Widget _backCard(){
    return Card(
      color: widget.card.answerColor.isEmpty ? Colors.pink : hexStringToColor(widget.card.answerColor),
      elevation: 4,
        shadowColor: Colors.black,
      child: Container(
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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: widget.height/2+widget.height/10,
                  // Bo góc với bán kính 20
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: !_isVideo(widget.card.answerImage!) ?Image.file(
                      File(widget.card.answerImage!),fit: BoxFit.fill,
                    ):_videoPlay(),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(widget.card.answer ,style :const TextStyle(
                      fontSize: 24
                  ),maxLines: 2,textAlign: TextAlign.center,),
                ),
              ),
              widget.card.audioFile == null ? Container():
                  _audioPlay()
            ],
          ),
        ),
      ),
    );
  }

  Widget _fontCard(){
    return Card(
      color: widget.card.questionColor.isEmpty ? Colors.pink : hexStringToColor(widget.card.questionColor),
      elevation: 4,
      shadowColor: Colors.black,
      child: Container(
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
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: widget.height/2+widget.height/10,
                  // Bo góc với bán kính 20
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                        File(widget.card.questionImage!),fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(widget.card.question ,style :const TextStyle(
                      fontSize: 24
                  ),maxLines: 2,textAlign: TextAlign.center,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 void handleTab(){
   setState(() {
     if(indexSelected == 0){
       indexSelected = 1;
     }else{
       indexSelected = 0;
       if(_audioPlayer.playing){
         _audioPlayer.pause();
         isPlayAudio = false;
       }
       if(controller!=null && controller!.value.isPlaying){
         controller!.pause();
       }
     }
   });
 }
  bool _isVideo(String path) {
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];
    final extension = path.split('.').last.toLowerCase();
    return videoExtensions.contains(extension);
  }

  @override
  void initState() {
    super.initState();
    if(_isVideo(widget.card.answerImage!)){
      _initializeVideoPlayer();
    }
    if(widget.card.audioFile!=null){
      _initializeAudioPlayer();
    }
    _mediaManager.registerController(this);
    if (widget.onControllerReady != null) {
      widget.onControllerReady!(this);
    }
  }
  Future<void >_initializeAudioPlayer () async{
    try {
      await _audioPlayer.setFilePath(widget.card.audioFile!);
      isPlayAudio = false;
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
  Future<void> _initializeVideoPlayer() async {
    controller = VideoPlayerController.file(File(widget.card.answerImage!));
    await controller!.initialize();
    controller!.setLooping(true);
    controller!.setVolume(1.0);
    setState(() {});
  }
  @override
  void dispose() {
    _mediaManager.unregisterController(this);
    if(controller!=null){
      controller!.dispose();
    }

    _audioPlayer.dispose();
    super.dispose();
  }
  Widget _videoPlay() {
    if (controller != null && controller!.value.isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
            AspectRatio(
              aspectRatio: controller!.value.aspectRatio,
              child: VideoPlayer(controller!),
            ),
          // Controls luôn hiển thị
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildControls()
          ),
        ],
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: _togglePlayback,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _togglePlayback() {
    setState(() {
      if (controller!.value.isPlaying) {
        controller!.pause();
      } else {
        _mediaManager.setActiveController(this);
        if(_audioPlayer.playing){
          _audioPlayer.pause();
          isPlayAudio = false;
        }
        controller!.play();
      }
    });
  }
  Widget _audioPlay(){
    return InkWell(onTap: (){
      _handleAudio();
    }, child: isPlayAudio ? SvgPicture.asset('assets/images/loa.svg'):
    SvgPicture.asset('assets/images/next.svg'));
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        handleTab();
      },
      child: IndexedStack(
        index: indexSelected,
        children: [
          _fontCard(),
          _backCard()
        ],
      ),
    );
  }

  void _handleAudio() {
    if(isPlayAudio){
      setState(() {
        isPlayAudio = false;
        _audioPlayer.pause();
      });
    }else{
      _mediaManager.setActiveController(this);
      setState(() {
        isPlayAudio = true;
        if(controller!=null && controller!.value.isPlaying){
          controller!.pause();
        }
        _audioPlayer.play();
      });
    }
  }


  @override
  void pauseAllMedia() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      setState(() {
        isPlayAudio = false;
      });
    }

    if (controller != null && controller!.value.isPlaying) {
      controller!.pause();
      setState(() {

      });
    }
  }
}