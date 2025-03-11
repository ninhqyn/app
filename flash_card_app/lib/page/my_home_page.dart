
import 'package:flash_card_app/config/routes_name.dart';
import 'package:flash_card_app/features/home/bloc/home_bloc.dart';
import 'package:flash_card_app/features/play_list/bloc/play_list_bloc.dart';
import 'package:flash_card_app/widget/card.dart';
import 'package:flash_card_app/widget/playlist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widget/my_title.dart';
import 'dart:io';
class MyHomePage extends StatelessWidget {

  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(

              body: MyHomePageView()
          ),
    );
  }
}
class MyHomePageView extends StatefulWidget{
  const MyHomePageView({super.key});

  @override
  State<MyHomePageView> createState() => _MyHomePageViewState();
}

class _MyHomePageViewState extends State<MyHomePageView> {
  final ScrollController _scrollController = ScrollController();
  double _progressValue = 0.0;
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchData());
    _scrollController.addListener(_updateProgress);
  }
  void _updateProgress() {
    if (_scrollController.hasClients) {
      // Calculate progress value based on current scroll position and maximum scroll extent
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      if (maxScrollExtent > 0) {
        setState(() {
          _progressValue = _scrollController.position.pixels / maxScrollExtent;
          // Ensure value is between 0 and 1
          _progressValue = _progressValue.clamp(0.0, 1.0);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
   return SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              gradient:  LinearGradient(
                  colors:[Color(0xFFC9FA85),Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyTitle('My Playlist', RoutesName.myPlayListPage, ImageIcon(AssetImage('assets/images/folder.png')),),
              _myPlayList(context),
              const SizedBox(
                height: 20,
              ),

            MyProgress(value: _progressValue),

              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Flashcards',style: TextStyle(
                        fontSize: 24,
                        shadows: [
                          Shadow(
                              color: Colors.black.withOpacity(0.2) ,
                              blurRadius: 1.0,
                              offset: const Offset(1, 1)
                          )
                        ]
                    )),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context,RoutesName.myFormFlashCard,arguments: {'isAdd':true});
                          },
                          child: const Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ImageIcon(AssetImage('assets/images/add.png'),size: 14,)
                            ],
                          )
                      ),
                    ),

                  ],
                ),
              ),
              _myFlashcards(context)
            ],
          ),
        ),
      );

  }
  Widget _myPlayList(BuildContext context){
    return SizedBox(
        height: 235,
        child: BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state)
    {
      if (state is HomeLoaded && state.myLists.isNotEmpty) {
        final myList = state.myLists;
        return ListView.builder(
            controller: _scrollController,
            itemCount: myList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: PlayListCard(myLists: myList[index],),
              );
            });
      }
      return Center(
        child: Image.asset('assets/images/NoItem.png'),
      );
    }
    )
    );
  }
  Widget _myFlashcards(BuildContext context){
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if(state is HomeLoaded && state.myCards.isNotEmpty){
          final myCards = state.myCards;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 240,
              ),
              itemCount: myCards.length,
              itemBuilder: (context, index) {
                return MyFlashCard(
                    weight: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height/2.5, card: myCards[index]);
              },
            ),
          );
        }
        return Center(
          child: Image.asset('assets/images/NoItem.png'),
        );

      },
    );
  }



}
class MyProgress extends StatelessWidget{
  final double value;

  const MyProgress({super.key,required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: LinearProgressIndicator(
          value: value,  // Progress value (from 0.0 to 1.0)
          minHeight: 5,      // Height of the progress bar
          backgroundColor: Colors.grey,  // Background color
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC9FA85)),
          borderRadius: value != 1.0 ? const BorderRadius.only(
              topRight: Radius.circular(2.5),
              bottomRight: Radius.circular(2.5)
          ):const BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),)),
    );
  }
  
}