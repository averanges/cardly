import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/utils/colors.dart';
import 'package:sound/utils/validators.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              CustomFormFieldWidget(
                hintText: authViewModel.userModel!.email,
                title: 'Your email address',
                controller: _emailController,
                isPsw: false,
                validator: emailValidation,
                icon: const Icon(Iconsax.direct_inbox),
              ),
              CustomFormFieldWidget(
                hintText: authViewModel.userModel!.userName,
                title: 'Your Name',
                controller: _nameController,
                isPsw: false,
                validator: nameValidation,
                icon: const Icon(Iconsax.user),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (!_key.currentState!.validate()) {
                    return;
                  }
                  try {
                    _isLoading = true;
                    setState(() {});
                    await authViewModel.updateUserData(
                        email: _emailController.text,
                        name: _nameController.text);
                    if (mounted) {
                      if (_emailController.text.isNotEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'To complete update use link we sent on your current email address'),
                          backgroundColor: Colors.yellow,
                        ));
                      } else {
                        if (_nameController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Successfully updated!'),
                            backgroundColor: customGreenColor,
                          ));
                        }
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.message!),
                        backgroundColor: Colors.red,
                      ));
                    }

                    _isLoading = false;
                    setState(() {});
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: customButtonColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      // border: Border.all(
                      //     color: Colors.black12, style: BorderStyle.solid)
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            'Save'.toUpperCase(),
                            style: GoogleFonts.jost(
                                textStyle: const TextStyle(
                                    color: lightGreyTextColor,
                                    letterSpacing: 2)),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFormFieldWidget extends StatefulWidget {
  const CustomFormFieldWidget({
    required this.hintText,
    required this.title,
    required this.controller,
    required this.icon,
    required this.isPsw,
    required this.validator,
    super.key,
  });
  final String title;
  final String hintText;
  final TextEditingController controller;
  final bool isPsw;
  final Icon icon;
  final Function validator;

  @override
  State<CustomFormFieldWidget> createState() => _CustomFormFieldWidgetState();
}

class _CustomFormFieldWidgetState extends State<CustomFormFieldWidget> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.jost(textStyle: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) => widget.validator(value),
            obscureText: widget.isPsw && _isObscured,
            controller: widget.controller,
            decoration: InputDecoration(
                prefixIcon: widget.icon,
                suffixIcon: widget.isPsw
                    ? IconButton(
                        icon: const Icon(Iconsax.eye),
                        onPressed: () {
                          _isObscured = !_isObscured;
                          setState(() {});
                        },
                      )
                    : null,
                hintText: widget.hintText,
                fillColor: Colors.white,
                filled: true,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
          )
        ],
      ),
    );
  }
}
