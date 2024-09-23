part of core_package;

class LogoutService extends BaseService {
  LogoutService() : super();
  void logout(
      {required BuildContext currentContext,
      String routeName = '/login',
      Function()? onLogoutNavigate}) async {
    CoreLocalData().cleanUp();
    await dataSource.deleteAuthData();
    if (onLogoutNavigate == null) {
      if (currentContext.mounted) {
        Navigator.of(currentContext, rootNavigator: true)
            .pushNamedAndRemoveUntil(
              routeName,
              (route) => false,
            )
            .then((value) {});
      }
    } else {
      onLogoutNavigate();
    }
  }
}
