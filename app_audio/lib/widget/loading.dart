import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';  // Cần import để sử dụng hiệu ứng blur

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.72),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * (1 / 5),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Độ mờ
                    child: Container(
                      color: Colors.black.withOpacity(0), // Giữ trong suốt cho phần mờ
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 6,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/head_phone.svg',
                  width: 40,
                  height: 42,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Exporting...',
                style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: 'Sura'),
              ),
            ),

            // Phần backdropfilter để làm mờ nền

          ],
        ),
      ),
    );
  }
}
