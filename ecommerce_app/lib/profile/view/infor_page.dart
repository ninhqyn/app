import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget{
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: SingleChildScrollView( // Thêm SingleChildScrollView
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const Text(
               'My profile',
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 34,
               ),
             ),
             const SizedBox(height: 24),
             Row(
               children: [
                 const CircleAvatar(
                   radius: 30,
                   backgroundImage: AssetImage('assets/images/banner1.png'),
                 ),
                 const SizedBox(width: 12),
                 const Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       'Matilda Brown',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 18,
                       ),
                     ),
                     SizedBox(height: 4),
                     Text(
                       'matildabrown@mail.com',
                       style: TextStyle(
                         fontSize: 14,
                         color: Colors.grey,
                       ),
                     ),
                   ],
                 )
               ],
             ),
             const SizedBox(height: 32),
             _ItemProfile(
               title: 'My orders',
               subtitle: 'Already have 12 orders',
               onTap: () {},
             ),
             _ItemProfile(
               title: 'Shipping addresses',
               subtitle: '3 addresses',
               onTap: () {},
             ),
             _ItemProfile(
               title: 'Payment methods',
               subtitle: 'Visa **34',
               onTap: () {},
             ),
             _ItemProfile(
               title: 'Promocodes',
               subtitle: 'You have special promocodes',
               onTap: () {},
             ),
             _ItemProfile(
               title: 'My reviews',
               subtitle: 'Reviews for 4 items',
               onTap: () {},
             ),
             _ItemProfile(
               title: 'Settings',
               subtitle: 'Notifications, password',
               onTap: () {},
             ),
           ],
         ),
       ),
     ),
   );
  }
}
class _ItemProfile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ItemProfile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: const Color(0xFF9B9B9B).withOpacity(0.05),
          width: double.infinity,
        ),
      ],
    );
  }
}
