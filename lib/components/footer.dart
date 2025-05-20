import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: double.infinity,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final bool isSmallScreen = constraints.maxWidth < 600;
          return Row(
            mainAxisAlignment: isSmallScreen ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <InlineSpan>[
                      const TextSpan(text: '© 2025 ', style: TextStyle(fontFamily: 'Roboto')),
                      TextSpan(text: 'N-PAX Cebu Corporation', style: const TextStyle(color: Colors.blue), recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse('https://n-pax.com'))),
                      const TextSpan(text: '. All rights reserved.'),
                    ],
                  ),
                ),
              ),
              isSmallScreen ? const SizedBox() : const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Version NPAX20250513', style: TextStyle(color: Colors.black, fontSize: 14))),
            ],
          );
        },
      ),
    );
  }
}
