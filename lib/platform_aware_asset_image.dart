import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PlatformAwareAssetImage extends StatelessWidget {
  const PlatformAwareAssetImage({
    Key? key,
    required this.assetPath,
    this.package,
  }) : super(key: key);

  final String assetPath;
  final String? package;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        'assets/${package == null ? '' : 'packages/$package/'}$assetPath',
      );
    }

    return Image.asset(
      assetPath,
      package: package,
    );
  }
}