part of core_package;

class GlobalFormContext {
  // static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // static GlobalKey<ScaffoldMessengerState> scaffoldKey =
  //     GlobalKey<ScaffoldMessengerState>();
  // static GlobalKey<ScaffoldState> bottomNavKey = GlobalKey<ScaffoldState>();
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Reset the formKey
  static void resetFormKey() {
    formKey = GlobalKey<FormState>(); // Create a new instance when needed
  }
}
