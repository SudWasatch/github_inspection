import 'package:flutter/material.dart';
import 'package:github_inspection/components/dialogs.dart';
import 'package:github_inspection/providers/theme_state.dart';

enum Menu { account, logout }

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String str;
  const AppbarWidget({super.key, required this.str});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff57B4BA),
      centerTitle: true,
      title: Text(str),
      leading: ThemeStateApp(),
      actions: <Widget>[
        ?str != "Inspections" && str != "Home"
            // && str != "Account"
            ? IconButton(
                icon: Icon(Icons.home_sharp),
                onPressed: () {
                  // Handle more options button press
                  Navigator.pushNamed(context, "/hs");
                },
              )
            : null,
        PopupMenuButton<Menu>(
          icon: const Icon(Icons.menu),
          onSelected: (Menu item) {},
          itemBuilder: (BuildContext context) =>
              str != "Inspections" && str != "Account" && str != "Messages"
              ? <PopupMenuEntry<Menu>>[
                  PopupMenuItem<Menu>(
                    value: Menu.account,
                    child: ListTile(
                      leading: const Icon(Icons.business_sharp),
                      title: const Text('Inspections'),
                      onTap: () {
                        Navigator.pushNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          "/gs",
                        );
                      },
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<Menu>(
                    value: Menu.account,
                    child: ListTile(
                      leading: const Icon(Icons.message_sharp),
                      title: const Text('Messages'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("You Clicked Messages")),
                        );
                      },
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<Menu>(
                    value: Menu.account,
                    child: ListTile(
                      leading: const Icon(Icons.account_circle_sharp),
                      title: const Text('Account'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("You Clicked Account")),
                        );
                      },
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<Menu>(
                    value: Menu.logout,
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        size: 25,
                        color: Color(0xffFF073A),
                      ),
                      title: const Text('Logout'),
                      onTap: () async {
                        final exit = await showExitDialog(
                          context,
                          "Do you want to return to Login Page?",
                        );
                        if (exit) {
                          Navigator.pushNamed(
                            // ignore: use_build_context_synchronously
                            context,
                            "/ls",
                          );
                        }
                      },
                    ),
                  ),
                ]
              : <PopupMenuEntry<Menu>>[
                  PopupMenuItem<Menu>(
                    value: Menu.logout,
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        size: 25,
                        color: Color(0xffFF073A),
                      ),
                      title: const Text('Logout'),
                      onTap: () async {
                        final exit = await showExitDialog(
                          context,
                          "Do you want to return to Login Page?",
                        );
                        if (exit) {
                          Navigator.pushNamed(
                            // ignore: use_build_context_synchronously
                            context,
                            "/ls",
                          );
                        }
                      },
                    ),
                  ),
                ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
