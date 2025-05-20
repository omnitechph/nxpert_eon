import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SideNav extends StatelessWidget {
  final String currentRoute;

  const SideNav({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF222D32),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: <Color>[Color(0xFF1A2226), Color(0xFF1A2226)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => launchUrl(Uri.parse('http://192.168.1.120:81/eon_spc')),
                child: const Row(children: <Widget>[Icon(Icons.home, size: 48, color: Color(0xFFECECEC)), SizedBox(width: 18), Text('NXPERT EON', style: TextStyle(color: Color(0xFFECECEC), fontSize: 32, fontWeight: FontWeight.bold))]),
              ),
            ),
          ),
          const SectionHeader('Planning (PPM)'),
          HoverListTile(icon: Icons.calendar_month, title: 'Production Management', route: '/ppm/production-management', currentRoute: currentRoute),
          const Divider(),
          const SectionHeader('Entries'),
          HoverListTile(icon: Icons.upload, title: 'Plan Uploader', route: '/entries/plan-uploader', currentRoute: currentRoute),
          HoverListTile(icon: Icons.edit_document, title: 'DPR Entry (ADC)', route: '/entries/dpr-entry-adc', currentRoute: currentRoute),
          HoverListTile(icon: Icons.edit_document, title: 'DPR Entry (C4)', route: '/entries/dpr-entry-c4', currentRoute: currentRoute),
          HoverListTile(icon: Icons.edit_document, title: 'DPR Entry (KD)', route: '/entries/dpr-entry-kd', currentRoute: currentRoute),
          HoverListTile(icon: Icons.edit_document, title: 'Pallet Entry', route: '/entries/pallet-entry', currentRoute: currentRoute),
          const Divider(),
          const SectionHeader('Reports'),
          HoverListTile(icon: Icons.bar_chart, title: 'MPR (ADC)', route: '/reports/mpr-adc', currentRoute: currentRoute),
          HoverListTile(icon: Icons.bar_chart, title: 'MPR (C4)', route: '/reports/mpr-c4', currentRoute: currentRoute),
          HoverListTile(icon: Icons.bar_chart, title: 'MPR (KD)', route: '/reports/mpr-kd', currentRoute: currentRoute),
          HoverListTile(icon: Icons.bar_chart, title: 'KD Pallet Layout', route: '/reports/kd-pallet-layout', currentRoute: currentRoute),
          HoverListTile(icon: Icons.refresh, title: 'NG Rework', route: '/reports/ng-rework', currentRoute: currentRoute),
          const Divider(),
          const SectionHeader('Settings'),
          HoverListTile(icon: Icons.settings, title: 'Product Master', route: '/settings/product-master', currentRoute: currentRoute),
          HoverListTile(icon: Icons.settings, title: 'Kanban Master', route: '/settings/kanban-master', currentRoute: currentRoute),
          HoverListTile(icon: Icons.settings, title: 'Pallet Master', route: '/settings/pallet-master', currentRoute: currentRoute),
          HoverListTile(icon: Icons.settings, title: 'Locator Master', route: '/settings/locator-master', currentRoute: currentRoute),
          HoverListTile(icon: Icons.settings, title: 'User Master', route: '/settings/user-master', currentRoute: currentRoute),
          HoverListTile(icon: Icons.settings, title: 'Preference Master', route: '/settings/preference-master', currentRoute: currentRoute),
          HoverListTile(icon: Icons.settings, title: 'Shift Master', route: '/settings/shift-master', currentRoute: currentRoute),
          const Divider(),
          const SectionHeader('Logs'),
          HoverListTile(icon: Icons.feed_outlined, title: 'ADC Logs', route: '/logs/adc-logs', currentRoute: currentRoute),
          HoverListTile(icon: Icons.feed_outlined, title: 'Machining Logs', route: '/logs/machining-logs', currentRoute: currentRoute),
          HoverListTile(icon: Icons.feed_outlined, title: 'NG Logs', route: '/logs/ng-logs', currentRoute: currentRoute),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 16, 0, 8), child: Text(title, style: const TextStyle(color: Color(0xFFB8C7CE), fontSize: 16, fontWeight: FontWeight.bold)));
  }
}

class HoverListTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String route;
  final String currentRoute;

  const HoverListTile({super.key, required this.icon, required this.title, required this.route, required this.currentRoute});

  @override
  State<HoverListTile> createState() => _HoverListTileState();
}

class _HoverListTileState extends State<HoverListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.currentRoute == widget.route;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: BoxDecoration(color: isActive ? const Color(0xFF1E282C) : (_isHovered ? const Color(0xFF1E282C) : Colors.transparent)),
        child: ListTile(
          leading: Icon(widget.icon, size: 26, color: isActive ? Colors.white : (_isHovered ? Colors.white : const Color(0xFFB8C7CE))),
          title: Text(widget.title, style: TextStyle(color: isActive ? Colors.white : (_isHovered ? Colors.white : const Color(0xFFB8C7CE)))),
          onTap: () {
            if (!isActive) context.go(widget.route);
          },
        ),
      ),
    );
  }
}
