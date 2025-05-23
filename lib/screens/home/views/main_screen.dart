import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          children: [
            Container(
            color: Colors.red,   
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 50, 
                            height: 50, 
                            decoration:BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[700],
                            ),
                          ),
                          Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.yellow[800],
                          ),
                        ],
                        ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.outline,
                          )
                        ),
                        Text(
                          "John Doe.",
                           style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          )
                        ),
                      ],
                    )
                  ],
                  ),
                  IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.settings)),
                ],
              ),
           ),
         ],      
        ),
      ),
   );
 }
}