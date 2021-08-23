import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// every animation in flutter contains 3 things: ticker, controller and value
// ticker is means every tick of clock something happens in animation like color changes, size changes, etc
// controller is the manger of the controller. It tells the animation when to start, stop, move forward, etc
// value is what we want to change as color, size, etc
// SingleTickerProviderStateMixin is used to animate one item => ticker for animation controller
// TickerProviderStateMixin is used to animate many items
// lets now define something new called mixin
// we know that any class can extend only one other class
// but what if you want to extend more than one class
// here we will need the mixin, it's just like a class ex:
// mixin canFly {
//  void fly() {
//    print("fly");
//  }
// }
// to extend mixins we use with keyword
// class animal with canFly, canSwim, canMove {}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      // if we will use Animation animation.value we cannot use upperBound property
      // upperBound: 100, // value goes from 0 to 100
      vsync: this, // ticker from SingleTickerProviderStateMixin
    );

    // animation used to control changes in value
    // to use it use animation.value instead of controller.value
    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    //make animation value takes a color and vary from red to blue
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.black)
        .animate(controller);

    // .forward() means make value increase from 0 t0 100
    // if you want to decrease from 100 to 0 -> controller.reverse();
    controller.forward();

    controller.addListener(() {
      // set state as there is changes we want to happen on the screen
      setState(() {});
      print(controller.value);
    });

    // make animation go from 0 to 100 and then from 100 to 0 --> loop
    // controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // you must dispose the controller as if you close the app or layout it still running
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  // Hero widget is used to give a soft and beautiful animation
                  // to an item when moving from layout to another layout
                  // but this item should be exists in the both layouts
                  // we can make hero widget know that this item is shared in two layers
                  // by using the same tag
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  speed: Duration(milliseconds: 300),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(Colors.redAccent, 'Log In', () {
              // Go to login screen.
              Navigator.pushNamed(context, "/login");
            }),
            RoundedButton(Colors.red, 'Register', () {
              // Go to registration screen.
              Navigator.pushNamed(context, "/registration");
            }),
          ],
        ),
      ),
    );
  }
}
