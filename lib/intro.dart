import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:odvc/RandomCardNotifier.dart';
import 'package:odvc/home.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> anim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));
    anim = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInQuad));
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
    Future.delayed(Duration(milliseconds: 1000), () => {
        Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (context, animation, secondaryAnimation) {
                return ChangeNotifierProvider(
                    create: (context) => RandomCardNotifier(),
                    child: const HomePage());
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn));
                Animation<double> opacityAnim = animation.drive(tween);
                return FadeTransition(child: child, opacity: opacityAnim);
              },
            ))

    });
  }

  @override
  Widget build(BuildContext context) {
    return _ScreenSelection();
  }

  Widget _ScreenSelection() {
    // else {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: anim.value * 100),
        child: Text(
          "Oracle du voyage chamanique",
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
      ),
    ));
    //}
  }
}
