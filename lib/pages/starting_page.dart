import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/generated/l10n.dart';
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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  bool _isLoginOpened = false;
  bool _isForgotPasswordOpened = false;

  late AnimationController _opactityController;
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(251, 174, 51, 0.8),
    ));

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _opactityController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
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
    const image1 = AssetImage('assets/images/robot.webp');
    const image2 = AssetImage('assets/images/cardly.png');
    Future.wait([
      precacheImage(image1, context),
      precacheImage(image2, context),
    ]).then((_) {
      setState(() {
        _opactityController.forward();
      });
    }).catchError((error) {
      debugPrint('Error loading images: $error');
    });
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
        key: _scaffoldStateKey,
        backgroundColor: const Color.fromRGBO(251, 174, 51, 1),
        body: AnimatedBuilder(
            animation: _opactityController,
            builder: (context, child) {
              return Opacity(
                opacity: _opactityController.value,
                child: Stack(
                  children: [
                    RepaintBoundary(
                      child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _controller.value * 10),
                              child: Container(
                                alignment: Alignment.topLeft,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/robot.webp'))),
                              ),
                            );
                          }),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Image.asset(
                                'assets/images/cardly.png',
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                              onTap: () {
                                _scaffoldStateKey.currentState!.showBottomSheet(
                                  (BuildContext context) {
                                    return preCachedBottomSheet(_isLoginOpened);
                                  },
                                  backgroundColor: customButtonColor,
                                );
                              },
                              child: RepaintBoundary(
                                child: AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, child) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 20),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        margin:
                                            const EdgeInsets.only(bottom: 60),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              S.of(context).getStarted,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Jost'),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Icon(
                                              FontAwesomeIcons.locationArrow,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  StatefulBuilder preCachedBottomSheet(bool isLoginOpened) {
    return StatefulBuilder(builder: (context, setModalState) {
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
    });
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
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).forgotPassword,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).noNeedToWorryTellUsYourEmailAndWe,
              style: const TextStyle(color: lightGreyTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: _key,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: 'Email...',
                      icon: Iconsax.direct_inbox,
                      isPswField: false,
                      validator: emailValidation,
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
                            : Text(S.of(context).resetPassword.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).backToLogin,
                            style: const TextStyle(
                                fontSize: 14, color: lightGreyTextColor)),
                        TextButton(
                            onPressed: () {
                              widget.voidCallback();
                            },
                            child: Text(S.of(context).signIn,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Jost')))
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
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).registration,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: _key,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: 'Email...',
                      icon: Iconsax.direct_inbox,
                      isPswField: false,
                      validator: emailValidation,
                    ),
                    const Divider(
                      color: lightGreyTextColor,
                      thickness: 0.3,
                    ),
                    CustomTextFormField(
                      isPswField: true,
                      icon: Iconsax.lock,
                      hintText: S.of(context).passwordHintWithDots,
                      controller: _passwordController,
                      validator: passwordValidation,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      isPswField: true,
                      icon: Iconsax.lock_1,
                      hintText: S.of(context).repeatPasswordHintWithDots,
                      controller: _confirmPswController,
                      validator: (value) => confirmPasswordValidation(
                          _passwordController.text, value!),
                    ),
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _authError.isEmpty
                            ? const SizedBox(
                                height: 20,
                              )
                            : Text(
                                _authError,
                                style: const TextStyle(color: Colors.red),
                              )),
                    GestureDetector(
                      onTap: () async {
                        _authError = '';
                        if (authViewModel.isLoggedIn) {
                          _authError = S.of(context).userAlreadyLoggedIn;
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
                            _authError =
                                S.of(context).anUnexpectedErrorOccurred;
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
                            : Text(S.of(context).signUp.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).alreadyHaveAnAccount,
                            style: const TextStyle(
                                fontSize: 14, color: lightGreyTextColor)),
                        TextButton(
                            onPressed: () {
                              widget.voidCallback();
                            },
                            child: Text(S.of(context).signIn,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)))
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

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.validator,
      required this.hintText,
      required this.icon,
      required this.isPswField});

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String hintText;
  final IconData icon;
  final bool isPswField;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isPasswordHidden,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isPswField
              ? IconButton(
                  icon: const Icon(Iconsax.eye),
                  onPressed: () {
                    _isPasswordHidden = !_isPasswordHidden;
                    setState(() {});
                  },
                )
              : null,
          hintText: widget.hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          fillColor: Colors.black.withOpacity(0.05),
          filled: true),
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
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;
  String _authError = '';

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).login,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: 'Jost'),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
              key: _key,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: 'Email...',
                    icon: Iconsax.direct_inbox,
                    isPswField: false,
                    validator: emailValidation,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: 'Password...',
                    icon: Iconsax.lock,
                    isPswField: true,
                    validator: passwordValidation,
                  ),
                  _authError.isEmpty
                      ? const SizedBox(
                          height: 10,
                        )
                      : Text(
                          _authError,
                          style: const TextStyle(color: Colors.red),
                        ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text(
                        S.of(context).forgotPassword,
                      ),
                      onPressed: () {
                        widget.openResetPsw();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<AuthViewModel>(
                    builder: (context, value, child) => GestureDetector(
                      onTap: () async {
                        _authError = '';
                        if (value.isLoggedIn) {
                          _authError = S.of(context).userAlreadyLoggedIn;
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
                            await value.login(
                                context: context,
                                email: _emailController.text,
                                psw: _passwordController.text);
                          } on FirebaseAuthException catch (e) {
                            _authError = e.message!;
                          } catch (e) {
                            _authError =
                                S.of(context).anUnexpectedErrorOccurred;
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
                            : Text(S.of(context).signIn.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<AuthViewModel>(
                    builder: (context, value, child) => GestureDetector(
                      onTap: () async {
                        if (value.isLoggedIn) {
                          _authError = S.of(context).userAlreadyLoggedIn;

                          setState(() {});
                          return;
                        }
                        await value.loginAsGuest(context);
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
                        child: Text(S.of(context).guestMode.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).dontHaveAnAccountYet,
                          style: const TextStyle(
                              fontSize: 14,
                              color: lightGreyTextColor,
                              fontFamily: 'Jost')),
                      TextButton(
                          onPressed: () {
                            widget.voidCallback();
                          },
                          child: Text(S.of(context).signUp,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)))
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
