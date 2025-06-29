import 'package:flutter/cupertino.dart';

class AppImageAssets extends StatelessWidget {
  final String assets;
  final double height;
  final double width;
  final BoxFit? fit;

  const AppImageAssets(this.assets,
      {super.key, required this.height, required this.width, this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assets,
      package: 'shared_component',
      height: height,
      width: width,
      fit: fit, // or any fit you need
    );
  }
}
