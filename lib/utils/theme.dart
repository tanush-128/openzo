import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/constants/styles.dart';

// class GlobalStyle {
//   static const Color primaryColor = Color(0xFF0061A8); // Example primary color
//   static const Color accentColor = Color(0xFFFFC107); // Example accent color
//   static const Color backgroundColor =
//       Color(0xFFF6F6F6); // Light grey background
// }

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: GlobalStyle.backgroundColor,
    dividerColor: Colors.grey.shade300,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconSize: MaterialStateProperty.all(24),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return GlobalStyle.primaryColor.withOpacity(0.8);
            }
            return Colors.black87;
          },
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,

      selectedItemColor: GlobalStyle.primaryColor,
      unselectedItemColor: Colors.black54,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,

      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      // elevation: 5,
    ),
    dividerTheme: DividerThemeData(
      space: 0,
      thickness: 1,
      color: Colors.grey.shade400,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.shade200,
      iconTheme: const IconThemeData(color: Colors.black87),
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
      //  const TextStyle(
      //   color: Colors.black87,
      //   fontSize: 20,
      //   fontWeight: FontWeight.w600,
      // ),
      actionsIconTheme: const IconThemeData(color: Colors.black87),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: GlobalStyle.primaryColor.withOpacity(0.1),
      labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          // color: GlobalStyle.primaryColor,
          color: Colors.black87),
      secondaryLabelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: GlobalStyle.primaryColor,
      ),
      surfaceTintColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      // side: BorderSide(color: GlobalStyle.primaryColor, width: 1),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: GlobalStyle.primaryColor,
      primary: GlobalStyle.primaryColor,
      secondary: GlobalStyle.accentColor,
      background: GlobalStyle.backgroundColor,
      surface: Colors.white,
      brightness: Brightness.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalStyle.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: GlobalStyle.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      foregroundColor: Colors.white,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      elevation: 10,
      surfaceTintColor: Colors.white,
      showDragHandle: true,
      dragHandleSize: const Size(200, 8),
      dragHandleColor: Colors.grey.shade300,
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ).apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black87,
    ),
    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      // fillColor: Colors.grey.shade100,
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(8),
      //   borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      // ),
      border: InputBorder.none,
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(8),
      //   borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      // ),
      // focusedBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(8),
      //   borderSide: BorderSide(color: GlobalStyle.primaryColor, width: 2),
      // ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.grey.shade600,
      ),
      // const TextStyle(
      //   fontSize: 16,
      //   fontWeight: FontWeight.w500,
      // ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.grey.shade600,
      ),
      //  TextStyle(
      //   fontSize: 14,
      //   color: Colors.grey.shade600,
      // ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      fillColor: MaterialStateProperty.all(GlobalStyle.primaryColor),
      checkColor: MaterialStateProperty.all(Colors.white),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(GlobalStyle.primaryColor),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(GlobalStyle.primaryColor),
      trackColor:
          MaterialStateProperty.all(GlobalStyle.primaryColor.withOpacity(0.5)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: GlobalStyle.primaryColor,
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      actionTextColor: Colors.white,
      showCloseIcon: true,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
