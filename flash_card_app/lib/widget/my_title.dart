
import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget{
  final String title;
  final String routeName;
  final ImageIcon icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: TextStyle(
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
                  Navigator.pushNamed(context, routeName);
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(alignment: Alignment.center,child: icon),
                    const Align(alignment: Alignment.center,child: ImageIcon(AssetImage('assets/images/add.png'),size: 9,))
                  ],
                )
            ),
          )
        ],
      ),
    );
  }

  const MyTitle(this.title, this.routeName, this.icon, {super.key});
}