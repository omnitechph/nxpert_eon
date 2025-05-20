import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

import '../pages/login/controllers/auth_controller.dart';
import '../pages/login/models/auth_model.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Box<dynamic> authBox = Hive.box('auth');
    final AuthModel auth = ref.watch(authControllerProvider);
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF005B96),
      toolbarHeight: 50,
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: false,
      leading: Builder(builder: (BuildContext context) => IconButton(icon: const Icon(Icons.menu), tooltip: '', onPressed: () => Scaffold.of(context).openDrawer())),
      actions: <Widget>[
        PopupMenuButton<String>(
          tooltip: '',
          padding: EdgeInsets.zero,
          offset: const Offset(0, 40),
          itemBuilder:
              (_) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(enabled: false, value: 'test', child: Row(children: <Widget>[Image.asset('assets/images/isuzu_logo_new.png', fit: BoxFit.contain, width: 24), const SizedBox(width: 8), Text(auth.user ?? authBox.get("user"))])),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(value: 'logout', child: Row(children: <Widget>[Icon(Icons.logout, color: Colors.red), SizedBox(width: 8), Text('Logout')])),
              ],
          onSelected: (String value) {
            if (value == 'logout') _logout(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Row(
                children: <Widget>[
                  Image.asset('assets/images/isuzu_logo_new.png', height: 24),
                  const SizedBox(width: 8),
                  Text('${auth.userId ?? authBox.get('userId')}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _logout(BuildContext context) async {
    await Hive.box('auth').clear();
    if (context.mounted) context.go('/login');
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
