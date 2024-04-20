import 'package:flutter/material.dart';

class welcomepage extends StatefulWidget {
  const welcomepage({super.key});

  @override
  State<welcomepage> createState() => _welcomepageState();
}

class _welcomepageState extends State<welcomepage> {
  List img = [
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 3,
        itemBuilder: (_,index){
        return Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(assetName))
          ),
        );
      }),
    );
    
    
  }
}