import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
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
                    title: Text('Create new account',
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                                fontSize: 16, color: customGreenColor))),
                    subtitle: Text('It will allow you save your progress.',
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text('Not allowed in Guest Mode')));
                      return;
                    }
                    Navigator.of(context)
                        .push(customPageRouteBuild(const SideMenuItemsLayer(
                      sideMenuTitle: 'Personal Details',
                      sideMenuSubTitle: 'Manage your personal details below.',
                      child: PersonalDetailsPage(),
                    )));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.person_outline_rounded),
                    title: Text('Personal Details',
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(fontSize: 16))),
                    subtitle: Text('Manage your personal details here.',
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text('Not allowed in Guest Mode')));
                      return;
                    }
                    Navigator.of(context)
                        .push(customPageRouteBuild(const SideMenuItemsLayer(
                      sideMenuTitle: 'Change Password',
                      sideMenuSubTitle:
                          'You can set a new password for you account below.',
                      child: ChangePasswordPage(),
                    )));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text('Change Password',
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(fontSize: 16))),
                    subtitle: Text('Manage your personal details here.',
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
                      title: Text('Delete your account',
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 16, color: Colors.red))),
                      subtitle: Text(
                          'Delete your account permanently. Action cannot be undone.',
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
                Text('Delete account?',
                    style: GoogleFonts.jost(
                        textStyle: const TextStyle(fontSize: 20))),
                Text(
                    'Are you sure you want to delete your account? This action can not be undone.',
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
                            'Delete',
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
                    child: Text('Cancel',
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
