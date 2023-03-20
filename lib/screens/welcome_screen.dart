import 'package:flutter/material.dart';
import 'package:how_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController aniController;
  late Animation animation;
  late Animation colorAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    aniController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    aniController.forward();
    animation =
        CurvedAnimation(parent: aniController, curve: Curves.decelerate);
    colorAnimation = ColorTween(
      end: Color(0xFF36CFFD),
      begin: Color(0xFF0D4FE5),
    ).animate(aniController);
    aniController.addListener(() {
      setState(() {});

    });
  }

  @override
  void dispose() {
    aniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset('images/logo.png'),
                  ),
                  height: animation.value * 100,
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 4,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            EnrollButton(
              descText: 'Log in',
              pageRoute: LoginScreen.id,
              buttonColor: Colors.lightBlue,
            ),
            EnrollButton(
              descText: 'Register',
              pageRoute: RegistrationScreen.id,
              buttonColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class EnrollButton extends StatelessWidget {
  final String descText;
  final String pageRoute;
  final Color buttonColor;

  const EnrollButton({
    Key? key,
    required this.descText,
    required this.pageRoute,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context, pageRoute);
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            descText,
          ),
        ),
      ),
    );
  }
}
