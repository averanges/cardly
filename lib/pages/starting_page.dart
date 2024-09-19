import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/pages/entry_point.dart';
import 'package:sound/pages/template_gallery/ui/widgets/custom_page_route_build.dart';
import 'package:sound/utils/colors.dart';
import 'package:sound/utils/validators.dart';

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
  bool _isForgotPasswordOpened = false;

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
      isScrollControlled: true,
      backgroundColor: customButtonColor,
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setModalState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: [
              _isForgotPasswordOpened
                  ? RefreshPassword(
                      voidCallback: () => setModalState(() {
                            _isForgotPasswordOpened = false;
                          }))
                  : isLoginOpened
                      ? RegistrationModalBottom(
                          voidCallback: () {
                            setModalState(() {
                              isLoginOpened = !isLoginOpened;
                            });
                          },
                        )
                      : LoginModalBottom(
                          openResetPsw: () => setModalState(() {
                            _isForgotPasswordOpened = true;
                          }),
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
          ),
        );
      }),
    );
  }
}

class RefreshPassword extends StatefulWidget {
  const RefreshPassword({super.key, required this.voidCallback});
  final VoidCallback voidCallback;

  @override
  State<RefreshPassword> createState() => _RefreshPasswordState();
}

class _RefreshPasswordState extends State<RefreshPassword> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return Container(
      padding: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          print('click');
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Forgot Password?',
              style: GoogleFonts.jost(
                  textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'No need to worry. Tell us your e-mail and we will send you link to reset you password!',
              style: GoogleFonts.jost(color: lightGreyTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      validator: emailValidation,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.direct_inbox),
                          hintText: 'Email...',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          fillColor: Colors.black.withOpacity(0.05),
                          filled: true),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        _isLoading = true;
                        setState(() {});
                        await authViewModel
                            .resetPassword(_emailController.text);
                        _isLoading = true;
                        setState(() {});
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
                            color: Colors.black,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                style: BorderStyle.solid, color: Colors.white)),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('Reset Password'.toUpperCase(),
                                style: GoogleFonts.jost(
                                    textStyle: const TextStyle(
                                        fontSize: 14, color: Colors.white))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Back to Login?',
                            style: GoogleFonts.jost(
                                textStyle: const TextStyle(
                                    fontSize: 14, color: lightGreyTextColor))),
                        TextButton(
                            onPressed: () {
                              widget.voidCallback();
                            },
                            child: Text('Sign In',
                                style: GoogleFonts.jost(
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))))
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class RegistrationModalBottom extends StatefulWidget {
  const RegistrationModalBottom({
    required this.voidCallback,
    super.key,
  });
  final VoidCallback voidCallback;

  @override
  State<RegistrationModalBottom> createState() =>
      _RegistrationModalBottomState();
}

class _RegistrationModalBottomState extends State<RegistrationModalBottom> {
  bool _isPasswordHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPswController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;
  String _authError = '';
  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return Container(
      padding: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          print('click');
        },
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
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      validator: emailValidation,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.direct_inbox),
                          hintText: 'Email...',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          fillColor: Colors.black.withOpacity(0.05),
                          filled: true),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: _isPasswordHidden,
                      controller: _passwordController,
                      validator: passwordValidation,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.lock),
                          suffixIcon: IconButton(
                            icon: const Icon(Iconsax.eye),
                            onPressed: () {
                              _isPasswordHidden = !_isPasswordHidden;
                              setState(() {});
                            },
                          ),
                          hintText: 'Password...',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          fillColor: Colors.black.withOpacity(0.05),
                          filled: true),
                    ),
                    TextFormField(
                      obscureText: _isPasswordHidden,
                      controller: _confirmPswController,
                      validator: passwordValidation,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.lock),
                          suffixIcon: IconButton(
                            icon: const Icon(Iconsax.eye),
                            onPressed: () {
                              _isPasswordHidden = !_isPasswordHidden;
                              setState(() {});
                            },
                          ),
                          hintText: 'Repeat password...',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          fillColor: Colors.black.withOpacity(0.05),
                          filled: true),
                    ),
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _authError.isEmpty
                            ? const SizedBox(
                                height: 20,
                              )
                            : Text(
                                _authError,
                                style: GoogleFonts.jost(color: Colors.red),
                              )),
                    GestureDetector(
                      onTap: () async {
                        _authError = '';
                        if (authViewModel.isLoggedIn) {
                          _authError = "User already logged in";
                          setState(() {});
                          Navigator.of(context)
                              .push(customPageRouteBuild(const EntryPoint()));
                          return;
                        }
                        if (mounted) {
                          FocusScope.of(context).unfocus();
                        }
                        if (_key.currentState!.validate()) {
                          try {
                            _isLoading = true;
                            setState(() {});
                            await authViewModel.registration(
                                context: context,
                                email: _emailController.text,
                                psw: _passwordController.text);
                          } on FirebaseAuthException catch (e) {
                            _authError = e.message!;
                          } catch (e) {
                            _authError = 'An unexpected error occurred.';
                          }
                        }
                        _isLoading = false;
                        setState(() {});
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
                            color: Colors.black,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                style: BorderStyle.solid, color: Colors.white)),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('Sign Up'.toUpperCase(),
                                style: GoogleFonts.jost(
                                    textStyle: const TextStyle(
                                        fontSize: 14, color: Colors.white))),
                      ),
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
                              widget.voidCallback();
                            },
                            child: Text('Sign In',
                                style: GoogleFonts.jost(
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))))
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class LoginModalBottom extends StatefulWidget {
  const LoginModalBottom(
      {super.key, required this.voidCallback, required this.openResetPsw});
  final VoidCallback voidCallback;
  final VoidCallback openResetPsw;

  @override
  State<LoginModalBottom> createState() => _LoginModalBottomState();
}

class _LoginModalBottomState extends State<LoginModalBottom> {
  bool _isPasswordHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;
  String _authError = '';
  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
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
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: emailValidation,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.direct_inbox),
                        hintText: 'Email...',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        fillColor: Colors.black.withOpacity(0.05),
                        filled: true),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: passwordValidation,
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.lock),
                        suffixIcon: IconButton(
                            icon: const Icon(
                              Iconsax.eye,
                            ),
                            onPressed: () {
                              _isPasswordHidden = !_isPasswordHidden;
                              setState(() {});
                            }),
                        hintText: 'Password...',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        fillColor: Colors.black.withOpacity(0.05),
                        filled: true),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _authError.isEmpty
                        ? const SizedBox(
                            height: 10,
                          )
                        : Text(
                            _authError,
                            style: GoogleFonts.jost(color: Colors.red),
                          ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text(
                        'Forgot you password?',
                      ),
                      onPressed: () {
                        widget.openResetPsw();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _authError = '';
                      if (authViewModel.isLoggedIn) {
                        _authError = "User already logged in";
                        setState(() {});
                        Navigator.of(context)
                            .push(customPageRouteBuild(const EntryPoint()));
                        return;
                      }
                      if (mounted) {
                        FocusScope.of(context).unfocus();
                      }
                      if (_key.currentState!.validate()) {
                        try {
                          _isLoading = true;
                          setState(() {});
                          await authViewModel.login(
                              context: context,
                              email: _emailController.text,
                              psw: _passwordController.text);
                        } on FirebaseAuthException catch (e) {
                          _authError = e.message!;
                        } catch (e) {
                          _authError = 'An unexpected error occurred.';
                        }
                      }
                      _isLoading = false;
                      setState(() {});
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
                          color: Colors.black,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                              style: BorderStyle.solid, color: Colors.white)),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('Sign In'.toUpperCase(),
                              style: GoogleFonts.jost(
                                  textStyle: const TextStyle(
                                      fontSize: 14, color: Colors.white))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (authViewModel.isLoggedIn) {
                        _authError = "User already logged in";

                        setState(() {});
                        return;
                      }
                      await authViewModel.loginAsGuest(context);
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
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
                            widget.voidCallback();
                          },
                          child: Text('Sign Up',
                              style: GoogleFonts.jost(
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))))
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
