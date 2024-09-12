import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:sound/pages/entry_point.dart';
import 'package:sound/pages/template_gallery/ui/widgets/custom_page_route_build.dart';
import 'package:sound/utils/colors.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({
    super.key,
  });

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  final bool _isNavigationLoading = false;
  bool _isLoginOpened = false;

  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.white,
    // ));

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _animation = ColorTween(begin: Colors.white, end: Colors.black12)
        .animate(_controller);
    super.initState();
  }

  void _toggleLoginSwitch() {
    _isLoginOpened = !_isLoginOpened;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/robot.jpg'), context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(251, 174, 51, 1),
        body: Stack(
          children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _controller.value * 10),
                    child: Container(
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/robot.webp'))),
                    ),
                  );
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/cardly.png',
                      width: 250,
                      height: 250,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1,
                              color: Colors.black12,
                              offset: Offset(0, 1))
                        ],
                        color: customButtonColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.google,
                          color: lightGreyTextColor,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // _isNavigationLoading = true;
                        // setState(() {});

                        // await Navigator.of(context)
                        //     .push(customPageRouteBuild(const EntryPoint()));

                        // if (mounted) {
                        //   setState(() {
                        //     _isNavigationLoading = false;
                        //   });
                        // }
                        await _customModalBottomSheet(context, _isLoginOpened);
                      },
                      child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return SkeletonAnimation(
                              shimmerColor: _isNavigationLoading
                                  ? customButtonColor
                                  : Colors.transparent,
                              shimmerDuration: 3000,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 20),
                                width: MediaQuery.of(context).size.width * 0.7,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        style: BorderStyle.solid),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                          color: _animation.value!,
                                          offset: const Offset(0, 1))
                                    ],
                                    color: Colors.black,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                margin: const EdgeInsets.only(bottom: 60),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Get Started',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.locationArrow,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                )
              ],
            )
          ],
        ));
  }

  Future<dynamic> _customModalBottomSheet(
      BuildContext context, bool isLoginOpened) {
    return showModalBottomSheet(
      backgroundColor: customButtonColor,
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setModalState) {
        return Stack(
          children: [
            isLoginOpened
                ? RegistrationModalBottom(
                    voidCallback: () {
                      setModalState(() {
                        isLoginOpened = !isLoginOpened;
                      });
                    },
                  )
                : LoginModalBottom(
                    voidCallback: () {
                      setModalState(() {
                        isLoginOpened = !isLoginOpened;
                      });
                    },
                  ),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)))
          ],
        );
      }),
    );
  }
}

class RegistrationModalBottom extends StatelessWidget {
  const RegistrationModalBottom({
    required this.voidCallback,
    super.key,
  });
  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Registration',
            style: GoogleFonts.jost(
                textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
              child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.direct_inbox),
                    hintText: 'Email...',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    fillColor: Colors.black.withOpacity(0.05),
                    filled: true),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: const Icon(Iconsax.eye),
                    hintText: 'Password...',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    fillColor: Colors.black.withOpacity(0.05),
                    filled: true),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: lightGreyTextColor,
                          blurRadius: 0.3,
                          spreadRadius: 0.3,
                          offset: Offset(0, 1))
                    ],
                    color: Colors.black,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.white)),
                child: Text('Sign Up'.toUpperCase(),
                    style: GoogleFonts.jost(
                        textStyle: const TextStyle(
                            fontSize: 14, color: Colors.white))),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: GoogleFonts.jost(
                          textStyle: const TextStyle(
                              fontSize: 14, color: lightGreyTextColor))),
                  TextButton(
                      onPressed: () {
                        voidCallback();
                      },
                      child: Text('Sign In',
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold))))
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}

class LoginModalBottom extends StatelessWidget {
  const LoginModalBottom({super.key, required this.voidCallback});
  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Login',
            style: GoogleFonts.jost(
                textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
              child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.direct_inbox),
                    hintText: 'Email...',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    fillColor: Colors.black.withOpacity(0.05),
                    filled: true),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: const Icon(Iconsax.eye),
                    hintText: 'Password...',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    fillColor: Colors.black.withOpacity(0.05),
                    filled: true),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: const Text(
                    'Forgot you password?',
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: lightGreyTextColor,
                          blurRadius: 0.3,
                          spreadRadius: 0.3,
                          offset: Offset(0, 1))
                    ],
                    color: Colors.black,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.white)),
                child: Text('Sign In'.toUpperCase(),
                    style: GoogleFonts.jost(
                        textStyle: const TextStyle(
                            fontSize: 14, color: Colors.white))),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(customPageRouteBuild(const EntryPoint()));
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: lightGreyTextColor,
                            blurRadius: 0.3,
                            spreadRadius: 0.3,
                            offset: Offset(0, 1))
                      ],
                      color: const Color.fromRGBO(251, 174, 51, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                          style: BorderStyle.solid, color: Colors.white)),
                  child: Text('guest mode'.toUpperCase(),
                      style: GoogleFonts.jost(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontStyle: FontStyle.italic))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account yet?",
                      style: GoogleFonts.jost(
                          textStyle: const TextStyle(
                              fontSize: 14, color: lightGreyTextColor))),
                  TextButton(
                      onPressed: () {
                        voidCallback();
                      },
                      child: Text('Sign Up',
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold))))
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
