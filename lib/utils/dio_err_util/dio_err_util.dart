part of core_package;

class DioExceptionUtil {
  // general methods:------------------------------------------------------------
  static String handleError(DioException error) {
    String errorDescription = "";
    // if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.cancel:
        errorDescription = ""; //"Your request was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = ""; //"Your request has been timed out";
        break;
      case DioExceptionType.unknown:
        errorDescription =
            ""; //"System is unable to process your request now, please try again after checking internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = ""; //"Your request has been timed out";
        break;

      case DioExceptionType.sendTimeout:
        errorDescription = ""; //"Your request has been timed out";
        break;
      case DioExceptionType.badResponse:
        if (error.response!.statusCode == 401) {
          errorDescription = "Invalid ID or Password";
          break;
        }
        if (error.response!.statusCode == 404) {
          errorDescription = "404: API not found";
          break;
        }
        if ((error.response?.statusCode ?? 500) >= 500) {
          errorDescription =
              ""; //"It's not you, it's us. We are having some trouble at our side. Please try again later after sometime.";
          break;
        }
        if (error.response?.data?.isEmpty ?? true) {
          errorDescription =
              ""; //"System was unable to process request [${error.response!.statusCode}]";
        } else {
          LinkedHashMap<String, dynamic> errRes = error.response!.data;

          if (errRes["error"] == "invalid_grant") {
            errorDescription = "Invalid ID or Password";
          } else {
            errorDescription =
                ""; //"System was unable to process request [${error.response!.statusCode}]";
          }
        }
        break;
      case DioExceptionType.badCertificate:
        errorDescription =
            "Certificate provided here is invalid please contact with owner";
        break;
      case DioExceptionType.connectionError:
        errorDescription =
            "There is connection error occur please try again later";
        break;
    }
    // } else {
    //   errorDescription =
    //       "System is unable to process your request now, please try again after checking internet connection";
    // }
    return errorDescription;
  }
}
