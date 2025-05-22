import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderBanner extends StatefulWidget {
  final String subtitle;

  const HeaderBanner({super.key, required this.subtitle});

  @override
  State<HeaderBanner> createState() => _HeaderBannerState();
}

class _HeaderBannerState extends State<HeaderBanner> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints){
      final bool isSmallScreen = constraints.maxWidth<600;
      if(isSmallScreen){
        return Container(
          height: 133,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: LinearGradient(colors: <Color>[Color(0xFF1A3C5E), Color(0xFF0A1E33)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 16,
              children: <Widget>[
                Image.asset('assets/images/plan.png', height: 90),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[const Text('NXPERT EON', style: TextStyle(color: Color(0xFFECECEC), fontSize: 28, fontWeight: FontWeight.bold)), Text(widget.subtitle, style: const TextStyle(color: Color(0xFFECECEC), fontSize: 14))],
                ),
              ],
            ),
          ),
        );
      }
      else{
        return Container(
          height: 133,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: LinearGradient(colors: <Color>[Color(0xFF1A3C5E), Color(0xFF0A1E33)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  spacing: 16,
                  children: <Widget>[
                    Image.asset('assets/images/plan.png', height: 90),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[const Text('NXPERT EON', style: TextStyle(color: Color(0xFFECECEC), fontSize: 28, fontWeight: FontWeight.bold)), Text(widget.subtitle, style: const TextStyle(color: Color(0xFFECECEC), fontSize: 14))],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  cursor: SystemMouseCursors.click,
                  child: AnimatedScale(
                    scale: _isHovered ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(onTap: () => launchUrl(Uri.parse('https://n-pax.com')), child: Image.asset('assets/images/npax_logo_white.png', height: 70)),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
