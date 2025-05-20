import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/footer.dart';
import '../../../../components/header_banner.dart';
import '../../../../components/side_nav.dart';
import '../../../../components/custom_app_bar.dart';

class DprEntryKdPage extends StatelessWidget {
  const DprEntryKdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'NXPERT EON'),
      drawer: SideNav(currentRoute: GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString()),
      body: const Column(
        spacing: 8,
        children: <Widget>[
          HeaderBanner(subtitle: 'DAILY PRODUCTION REPORT (KD)'),
          Expanded(child: Center(child: Text('Daily Production Report (KD)'))),
          Footer(),
        ],
      ),
    );
  }
}
