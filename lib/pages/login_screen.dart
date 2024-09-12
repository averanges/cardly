import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sound/pages/entry_point.dart';
import 'package:sound/pages/signup_screen.dart';
import 'package:sound/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Iconsax.arrow_left),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Add some space at the top
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome back',
                        style: GoogleFonts.amiri(
                          textStyle: const TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: GoogleFonts.amiri(
                          textStyle: const TextStyle(
                            fontSize: 60,
                            color: primaryPurpleColor,
                            height: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Discover Limitless Choices and Unmatched Convenience',
                  style: GoogleFonts.jost(
                    textStyle: const TextStyle(
                      color: Color.fromRGBO(177, 176, 161, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.direct_right,
                            color: Colors.black,
                          ),
                          labelText: 'E-Mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.password_check,
                            color: Colors.black,
                          ),
                          suffixIcon: Icon(Iconsax.eye_slash),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.blueAccent,
                                value: true,
                                onChanged: (value) {},
                              ),
                              Text(
                                'Remember me',
                                style: GoogleFonts.jost(
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forget password?',
                              style: GoogleFonts.jost(
                                textStyle: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: OutlinedButton(
                          style: const ButtonStyle(
                            side: WidgetStatePropertyAll(
                              BorderSide(color: Colors.black12),
                            ),
                            backgroundColor:
                                WidgetStatePropertyAll(primaryPurpleColor),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EntryPoint(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 4,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          style: const ButtonStyle(
                            side: WidgetStatePropertyAll(
                              BorderSide(color: Colors.black12),
                            ),
                          ),
                          child: Text(
                            'Create Account',
                            style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 16, letterSpacing: 4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50), // Add space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
