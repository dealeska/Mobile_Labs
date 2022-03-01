import "package:flutter/material.dart";
import "package:mobile_labs/strings.dart";
import "package:mobile_labs/theme.dart";

class InfoPage extends StatelessWidget {
  const InfoPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return const InfoWidget ();
  }
}

class InfoWidget extends StatefulWidget {
  const InfoWidget({ Key? key }) : super(key: key);

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: Text (currentLocalisation.about, style: getTextStyle())
      ),
      body: Center (
        child: Column (
          children: [
            Image.asset(
              "./assets/deal.jpg",
              width: 400,
              height: 400,
              fit: BoxFit.fitHeight,
              scale: 0.5,
            ),
            Text (currentLocalisation.developer, style: getTextStyle()),
          ]
        ),
      ),
    );
  }
   
}