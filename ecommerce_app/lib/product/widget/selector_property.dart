
import 'package:ecommerce_app/product/widget/modal_select_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class SelectorProperty extends StatelessWidget{
  const SelectorProperty({super.key});
  void showSizeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(
              bottom: kBottomNavigationBarHeight + 10, // Để modal nằm trên navigator
              left: 10,
              right: 10,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: const ModalSelectSize(),
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return const ModalSelectSize();
                    });
              },
              child: const _SelectorButton(title:'Size')
          ),
          const SizedBox(width: 10,),
          InkWell(
              onTap:(){
                print('on tab color');
              },
              child: const _SelectorButton(title:'Black')),
          const SizedBox(width: 10,),
          const _FavoriteButton()
        ],
      ),
    );
  }

}

class _FavoriteButton  extends StatelessWidget{
  const _FavoriteButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 1),
                color: Colors.black.withOpacity(0.1)
            )
          ]

      ),
      child: Center(
          child: SvgPicture.asset('assets/images/favorites.svg')
      ),
    );
  }

}

class _SelectorButton  extends StatelessWidget{
  final String title;

  const _SelectorButton({required this.title});

  @override
  Widget build(BuildContext context) {
   return Container(
     height: 40,
     width: 1/3 * MediaQuery.of(context).size.width,
     padding: const EdgeInsets.symmetric(horizontal: 10),
     decoration: BoxDecoration(
         border: Border.all(
             color: Colors.grey
         ),
         borderRadius: BorderRadius.circular(8)
     ),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text(title),
         SvgPicture.asset('assets/images/drop_down.svg')
       ],
     ),
   );
  }

}