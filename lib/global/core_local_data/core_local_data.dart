part of core_package;

class CoreLocalData with UserLocalData {
  static CoreLocalData? _instance;
  factory CoreLocalData() => _instance ??= CoreLocalData._();
  CoreLocalData._();
  cleanUp() {
    super.userCleanUp();
  }
}
