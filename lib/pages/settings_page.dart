import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/generated/l10n.dart';
import 'package:sound/pages/change_password_page.dart';
import 'package:sound/pages/personal_details_page.dart';
import 'package:sound/pages/template_gallery/ui/widgets/custom_page_route_build.dart';
import 'package:sound/pages/template_gallery/ui/widgets/side_menu_items_layer.dart';
import 'package:sound/utils/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return Expanded(
      child: Column(
        children: [
          authViewModel.isGuestMode
              ? Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                      color: customButtonColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListTile(
                    leading: const Icon(
                      Iconsax.user_add,
                      color: customGreenColor,
                    ),
                    title: Text(S.of(context).createNewAccount,
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                                fontSize: 16, color: customGreenColor))),
                    subtitle: Text(S.of(context).itWillAllowYouSaveYourProgress,
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                                fontSize: 12, color: lightGreyTextColor))),
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            decoration: BoxDecoration(
                color: authViewModel.isGuestMode
                    ? lightGreyTextColor.withOpacity(0.5)
                    : customButtonColor,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (authViewModel.isGuestMode) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text(S.of(context).notAllowedInGuestMode)));
                      return;
                    }
                    Navigator.of(context)
                        .push(customPageRouteBuild(SideMenuItemsLayer(
                      sideMenuTitle: S.of(context).personalDetails,
                      sideMenuSubTitle:
                          S.of(context).manageYourPersonalDetailsBelow,
                      child: const PersonalDetailsPage(),
                    )));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.person_outline_rounded),
                    title: Text(S.maybeOf(context)!.personalDetails,
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(fontSize: 16))),
                    subtitle: Text(S.of(context).manageYourPersonalDetailsBelow,
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                                fontSize: 12, color: lightGreyTextColor))),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    if (authViewModel.isGuestMode) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text(S.of(context).notAllowedInGuestMode)));
                      return;
                    }
                    Navigator.of(context)
                        .push(customPageRouteBuild(SideMenuItemsLayer(
                      sideMenuTitle: S.of(context).changePassword,
                      sideMenuSubTitle:
                          S.of(context).youCanSetANewPasswordForYouAccountBelow,
                      child: const ChangePasswordPage(),
                    )));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text(S.of(context).changePassword,
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(fontSize: 16))),
                    subtitle: Text(S.of(context).changeYouPrivatePassword,
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                                fontSize: 12, color: lightGreyTextColor))),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          !authViewModel.isGuestMode
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => DeleteModalWindow(
                              authViewModel: authViewModel,
                            ));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: customButtonColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ListTile(
                      leading: const Icon(
                        Iconsax.trash,
                        color: Colors.red,
                      ),
                      title: Text(S.of(context).deleteYourAccount,
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 16, color: Colors.red))),
                      subtitle: Text(
                          S
                              .of(context)
                              .deleteYourAccountPermanentlyActionCannotBeUndone,
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 12, color: lightGreyTextColor))),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class DeleteModalWindow extends StatefulWidget {
  const DeleteModalWindow({super.key, required this.authViewModel});

  final AuthViewModel authViewModel;
  @override
  State<DeleteModalWindow> createState() => _DeleteModalWindowState();
}

class _DeleteModalWindowState extends State<DeleteModalWindow> {
  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 245, 145, 179),
                    child: Icon(
                      Iconsax.trash,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Text(S.of(context).deleteAccount,
                    style: GoogleFonts.jost(
                        textStyle: const TextStyle(fontSize: 20))),
                Text(S.of(context).areYouSureYouWantToDeleteYourAccountThis,
                    style: GoogleFonts.jost(
                        textStyle: const TextStyle(color: lightGreyTextColor))),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    _isDeleting = true;
                    await widget.authViewModel.deleteAccount(context);
                    _isDeleting = false;
                    setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid, color: Colors.black45),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.white),
                    child: _isDeleting
                        ? const CircularProgressIndicator()
                        : Text(
                            S.of(context).delete,
                            style: GoogleFonts.jost(
                                textStyle:
                                    const TextStyle(color: Colors.redAccent)),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: customButtonColor),
                    child: Text(S.of(context).cancel,
                        style: GoogleFonts.jost(
                            textStyle:
                                const TextStyle(color: lightGreyTextColor))),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ))
        ],
      ),
    );
  }
}
