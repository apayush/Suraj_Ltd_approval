import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EA);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color error = Colors.redAccent;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onDrawerBackground = Color(0xFF011822);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color textFieldBackgroundColor = Color(0xFFF6F6F6);
  static const Color dividerColors = Color(0xFFDADADA);
  static const Color blue = Color(0xFF266499); // Good Color
  // static const Color blue = Color(0xFF00457A); // Good Color
  static const Color blue50 = Color(0xFFE1EAF0);
  static const Color blue100 = Color(0xFFB3C9DA);
  static const Color blue200 = Color(0xFF80A5C1);
  static const Color blue300 = Color(0xFF4D80A7);
  static const Color blue400 = Color(0xFF266499);
  static const Color blue500 = Color(0xFF00457A);
  static const Color blue600 = Color(0xFF003F72);
  static const Color blue700 = Color(0xFF003666);
  static const Color blue800 = Color(0xFF002E59);
  static const Color blue900 = Color(0xFF001F40);

  static const Color success = Colors.green;
  static const Color primaryColor = Color(0xFF007CB4);

  // Light Theme
  static const Color lightPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryColorDark = Color(0xFF000000);
  static const Color lightScaffoldBackgroundColor = Color(0xFFF3F4F7);
  static const Color lightDrawerBackgroundColor = Color(0xFFFBFBFD);
  static const Color lightAppBarBackground = Color(0xFFFFFFFF);
  static const Color lightIconThemeColor = Color(0xFF000000);
  static const Color lightTitleTextColor = Color(0xFF000000);
  static const Color lightButtonColor = Color(0xFF000000);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);

  // Dark Theme
  static const Color darkPrimary = Color(0xFF18181B);
  static const Color darkPrimaryColorDark = Color(0xFFFFFFFF);
  static const Color darkScaffoldBackgroundColor = Color(0xF709090B);
  static const Color darkDrawerBackgroundColor = Color(0xFF18181B);
  static const Color viewBackgroundColor = Color(0xFF101010);
  static const Color darkAppBarBackground = Color(0xFF000000);
  static const Color darkIconThemeColor = Color(0xFFFFFFFF);
  static const Color darkTitleTextColor = Color(0xFFFFFFFF);
  static const Color darkButtonColor = Color(0xFFFFFFFF);
  static const Color darkCardColor = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF18181B);

  static const Color mainGridLineColor = Colors.white10;
  static const Color contentColorCyan = Color(0xFF50E4FF);
  static const Color contentColorBlue = Color(0xFF2196F3);
}

class AppGradients {
  // Blues
  static const LinearGradient lightBlueToRoyalBlue = LinearGradient(
    colors: [Color(0xff5DB8FF), Color(0xff2A77FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aquaBlueToSkyBlue = LinearGradient(
    colors: [Color(0xff7EE8FA), Color(0xff4DA0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGreenToLavender = LinearGradient(
    colors: [Color(0xff5EFCE8), Color(0xff7367F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient royalBlueToDeepBlue = LinearGradient(
    colors: [Color(0xff5DB8FF), Color(0xff2A77FF), Color(0xff0F5DB8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient periwinkleToIndigo = LinearGradient(
    colors: [Color(0xff6E9CFF), Color(0xff3A6FF0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangePeachToCoralRed = LinearGradient(
    colors: [Color(0xffFFB36E), Color(0xffFF6E6E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient skyBlueToSteelBlue = LinearGradient(
    colors: [Color(0xff48C6EF), Color(0xff6F86D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lavenderToVividPurple = LinearGradient(
    colors: [Color(0xffA78BFA), Color(0xff7C4DFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanToBrightBlue = LinearGradient(
    colors: [Color(0xff66D3FF), Color(0xff2BB4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mintGreenToEmerald = LinearGradient(
    colors: [Color(0xff8EE2A8), Color(0xff4ABF8F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lilacToBlueberry = LinearGradient(
    colors: [Color(0xff9FA8FF), Color(0xff6E8BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient icyBlueToAzure = LinearGradient(
    colors: [Color(0xff6EE7FF), Color(0xff2BA4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Extra modern gradients
  static const LinearGradient deepTealToAqua = LinearGradient(
    colors: [Color(0xff13547a), Color(0xff80d0c7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blushPinkToPeach = LinearGradient(
    colors: [Color(0xffff9a9e), Color(0xfffad0c4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient deepSeaBlue = LinearGradient(
    colors: [Color(0xff2C5364), Color(0xff203A43), Color(0xff0F2027)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient limeGreenToForestGreen = LinearGradient(
    colors: [Color(0xffB4EC51), Color(0xff429321)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient royalBlueToViolet = LinearGradient(
    colors: [Color(0xff4568DC), Color(0xffB06AB3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetOrangeToPink = LinearGradient(
    colors: [Color(0xffff7e5f), Color(0xfffeb47b)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldToTealBlue = LinearGradient(
    colors: [Color(0xff11998e), Color(0xff38ef7d)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleToPink = LinearGradient(
    colors: [Color(0xffDA22FF), Color(0xff9733EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldToOrange = LinearGradient(
    colors: [Color(0xffF7971E), Color(0xffFFD200)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient deepBlueToPurple = LinearGradient(
    colors: [Color(0xff2E3192), Color(0xff1BFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient rosePinkToLavender = LinearGradient(
    colors: [Color(0xfffbc2eb), Color(0xffa6c1ee)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmFlame = LinearGradient(
    colors: [Color(0xffff9a9e), Color(0xfffad0c4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nightFade = LinearGradient(
    colors: [Color(0xffa18cd1), Color(0xfffbc2eb)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunnyMorning = LinearGradient(
    colors: [Color(0xfff6d365), Color(0xfffda085)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient winterNeva = LinearGradient(
    colors: [Color(0xffa1c4fd), Color(0xffc2e9fb)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient royalGarden = LinearGradient(
    colors: [Color(0xffE0EAFC), Color(0xffCFDEF3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aquaMarine = LinearGradient(
    colors: [Color(0xff1A2980), Color(0xff26D0CE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient juicyPeach = LinearGradient(
    colors: [Color(0xffFFDEE9), Color(0xffB5FFFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cherryBlossom = LinearGradient(
    colors: [Color(0xffFBD3E9), Color(0xffBB377D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient frostBlue = LinearGradient(
    colors: [Color(0xff83a4d4), Color(0xffb6fbff)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // List of all gradients for index access
  static final List<LinearGradient> _allGradients = [
    lightBlueToRoyalBlue,
    aquaBlueToSkyBlue,
    tealGreenToLavender,
    royalBlueToDeepBlue,
    periwinkleToIndigo,
    orangePeachToCoralRed,
    skyBlueToSteelBlue,
    lavenderToVividPurple,
    cyanToBrightBlue,
    mintGreenToEmerald,
    lilacToBlueberry,
    icyBlueToAzure,
    deepTealToAqua,
    blushPinkToPeach,
    deepSeaBlue,
    limeGreenToForestGreen,
    royalBlueToViolet,
    sunsetOrangeToPink,
    emeraldToTealBlue,
    purpleToPink,
    goldToOrange,
    deepBlueToPurple,
    rosePinkToLavender,
    warmFlame,
    nightFade,
    sunnyMorning,
    winterNeva,
    royalGarden,
    aquaMarine,
    juicyPeach,
    cherryBlossom,
    frostBlue,
  ];

  static LinearGradient getByIndex(int index) => _allGradients[index];

  static int get length => _allGradients.length;
}