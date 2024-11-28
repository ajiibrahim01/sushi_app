import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sushi_app/screens/dashboard.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Sushiman',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/assets/images/sushi_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Japanese taste of Japanese Food',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Text(
                'Feel the taste of the most popular Japanese food from around the world',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: CupertinoButton(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(40),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(CupertinoIcons.arrow_right),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                      (route) => false,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
