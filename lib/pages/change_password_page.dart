import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/pages/personal_details_page.dart';
import 'package:sound/utils/colors.dart';
import 'package:sound/utils/validators.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPswController = TextEditingController();
  final TextEditingController _newPswController = TextEditingController();
  final TextEditingController _confirmPswController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
                hintText: '',
                title: 'Current Password',
                controller: _currentPswController,
                isPsw: true,
                validator: passwordValidation,
                icon: const Icon(Iconsax.lock_1),
              ),
              CustomFormFieldWidget(
                hintText: '',
                title: 'New Password',
                controller: _newPswController,
                isPsw: true,
                validator: passwordValidation,
                icon: const Icon(Iconsax.lock),
              ),
              CustomFormFieldWidget(
                hintText: '',
                title: 'Repeat Password',
                controller: _confirmPswController,
                isPsw: true,
                validator: (value) =>
                    confirmPasswordValidation(value, _newPswController.text),
                icon: const Icon(Iconsax.lock),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (_key.currentState!.validate()) {
                    if (mounted) {
                      try {
                        _isLoading = true;
                        setState(() {});
                        await authViewModel.changePassword(
                            _currentPswController.text, _newPswController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: customGreenColor,
                                content:
                                    Text('Password updated successfully')));
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.warning_2,
                                      color: Colors.white,
                                    ),
                                    Text(e.message ??
                                        "Failed to update password. Try again!"),
                                  ],
                                ),
                              ],
                            )));
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Row(
                                  children: [
                                    Icon(Iconsax.warning_2),
                                    Text(
                                        "Failed to update password. Try again!"),
                                  ],
                                )));
                      }
                      _isLoading = false;
                      setState(() {});
                    }
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
