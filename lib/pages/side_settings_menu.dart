import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/generated/l10n.dart';
import 'package:sound/pages/profile_page.dart';
import 'package:sound/pages/settings_page.dart';
import 'package:sound/pages/starting_page.dart';
import 'package:sound/pages/template_gallery/ui/widgets/custom_page_route_build.dart';
import 'package:sound/pages/template_gallery/ui/widgets/side_menu_items_layer.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.toggleSideMenu});
  final VoidCallback toggleSideMenu;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  List<Map<String, dynamic>> _menuList = [];

  @override
  void didChangeDependencies() {
    _menuList = [
      {
        'title': S.of(context).profile,
        'subTitle': S.of(context).manageYourProfileDetails,
        'icon': Icons.person,
        'color': Colors.white,
        'nextPage': SideMenuItemsLayer(
          sideMenuTitle: S.of(context).profile,
          sideMenuSubTitle: S.of(context).manageYourProfileDetails,
          child: const ProfilePage(),
        )
      },
      {
        'title': S.of(context).settings,
        'subTitle': S.of(context).manageYourAccountSettings,
        'icon': Icons.settings,
        'color': Colors.white,
        'nextPage': SideMenuItemsLayer(
          sideMenuTitle: S.of(context).settings,
          sideMenuSubTitle: S.of(context).manageYourAccountSettings,
          child: const SettingsPage(),
        )
      },
      {
        'title': S.of(context).logOut,
        'subTitle': S.of(context).logOutFromThisProfile,
        'icon': Icons.exit_to_app_outlined,
        'color': Colors.redAccent,
        'nextPage': const StartScreen()
      },
    ];
    super.didChangeDependencies();
  }

  bool _isLogOutLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    GlobalUserViewModel globalUserViewModel =
        Provider.of<GlobalUserViewModel>(context);
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    child: IconButton(
                        onPressed: () {
                          widget.toggleSideMenu();
                        },
                        icon: const Icon(Icons.close)),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          authViewModel.userModel != null &&
                                  authViewModel.userModel?.userName != null &&
                                  authViewModel.userModel!.userName.isNotEmpty
                              ? authViewModel.userModel!.userName
                              : authViewModel.userModel?.email != null
                                  ? authViewModel.userModel!.email
                                  : '',
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                        ),
                        subtitle: Text(
                          authViewModel.userModel != null
                              ? authViewModel.userModel!.email
                              : '',
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 14, color: Colors.white24)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).targetLanguage.toUpperCase(),
                              style: GoogleFonts.jost(
                                  textStyle: const TextStyle(
                                      fontSize: 14, color: Colors.white70)),
                            ),
                            const Divider(
                              thickness: 0.1,
                            ),
                            Row(
                              children: [
                                CountryFlag.fromCountryCode(
                                  globalUserViewModel.targetLanguage.countryCode
                                      .toLowerCase(),
                                  width: 30,
                                  height: 30,
                                  shape: const Circle(),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(globalUserViewModel.targetLanguage.name)
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).accountSettings.toUpperCase(),
                              style: GoogleFonts.jost(
                                  textStyle: const TextStyle(
                                      fontSize: 14, color: Colors.white70)),
                            ),
                            const Divider(
                              thickness: 0.1,
                            ),
                            ..._menuList.map(
                              (e) => GestureDetector(
                                onTap: () async {
                                  if (e['title'] == S.of(context).logOut) {
                                    _isLogOutLoading = true;
                                    print('click');
                                    setState(() {});
                                    await authViewModel.logout(context);
                                    _isLogOutLoading = false;
                                    setState(() {});
                                    return;
                                  }
                                  if (e['nextPage'] != null && mounted) {
                                    Navigator.of(context).push(
                                        customPageRouteBuild(
                                            (e['nextPage'] as Widget)));
                                  }
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: Icon(
                                    e['icon'],
                                    color: e['color'],
                                  ),
                                  title: _isLogOutLoading &&
                                          e['title'] == 'Log out'
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          e['title'],
                                          style: GoogleFonts.jost(
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: e['color'])),
                                        ),
                                  subtitle: Text(
                                    e['subTitle'],
                                    style: GoogleFonts.jost(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white24)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
