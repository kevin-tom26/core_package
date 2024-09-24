part of core_package;

mixin HandleMessageServices {
  void handleError({
    required DioException dioError,
    required RestResponse responseRestModal,
    // BuildContext? currentContext,
    required void Function(String message) onErrorResponseMessage,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleErrorDisplay,
  }) async {
    if (dioError.response != null &&
        dioError.response!.data != null &&
        dioError.response!.data.toString().isNotEmpty) {
      if (dioError.response!.data is Map &&
          dioError.response!.data?['status'] != null) {
        responseRestModal.statusCode = dioError.response!.statusCode;
        responseRestModal.message = dioError.response!.statusMessage ?? '';
      } else if (dioError.response!.data is String &&
          dioError.response!.statusCode != null &&
          dioError.response!.statusMessage != null) {
        responseRestModal.statusCode = dioError.response!.statusCode;
        responseRestModal.message = dioError.response!.statusMessage ?? '';
      }
    } else {
      responseRestModal.statusCode = 800;
    }
    if (responseRestModal.message == null ||
        responseRestModal.message.toString().isEmpty) {
      responseRestModal.message = DioExceptionUtil.handleError(dioError);
    }
    if (!(handleErrorDisplay(
      onhandleError: onHandleErrorDisplay,
      httpStatusCode: responseRestModal.statusCode,
      responseBody: responseRestModal,
    ))) {
      onErrorResponseMessage(responseRestModal.message ?? "");
      // if (currentContext != null) {
      //   CommonMethods.showErrorMessage(
      //     currentContext,
      //     responseRestModal.message ?? "",
      //   );
      // } else {
      //   log('Current context is null. The error is ${responseRestModal.message ?? ""}');
      // }
    }
  }

  void handleSuccess({
    required Response<dynamic> responseOrignal,
    required RestResponse responseRestModal,
    // BuildContext? currentContext,
    required void Function(String message) onSuccessResponseMessage,
    required void Function(String message) onErrorResponseMessage,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleSuccessDisplay,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleErrorDisplay,
  }) {
    responseRestModal.data = responseOrignal.data;
    if (_statusCodeCheck(
      responseOrignal: responseOrignal,
      responseRestModal: responseRestModal,
    )) {
      responseRestModal.apiSuccess = true;

      if (responseRestModal.data != null &&
          responseRestModal.data.toString().isNotEmpty &&
          (responseRestModal.data is! String)) {
        responseRestModal.message =
            responseRestModal.data['status']['message'] ?? '';
        responseRestModal.statusCode = responseRestModal.data['status']['code'];
      }
      if (!(handleSuccessDisplay(
        onhandleSuccess: onHandleSuccessDisplay,
        httpStatusCode: responseRestModal.statusCode,
        responseBody: responseRestModal,
      ))) {
        onSuccessResponseMessage(responseRestModal.message ?? "");
        // if (currentContext != null) {
        //   CommonMethods.showSuccessMessage(
        //     currentContext,
        //     responseRestModal.message ?? "",
        //   );
        //   log('SuccessFully Logged in');
        // } else {
        //   log('Current context is null. The success message is ${responseRestModal.message ?? ""}');
        // }
      }
    } else {
      if (responseRestModal.data != null &&
          responseRestModal.data['status'] != null) {
        responseRestModal.statusCode = responseRestModal.data['status']['code'];
        responseRestModal.message =
            responseRestModal.data['status']['message'] ?? '';
      }
      if (!(handleErrorDisplay(
          onhandleError: onHandleErrorDisplay,
          httpStatusCode: responseRestModal.statusCode,
          responseBody: responseRestModal))) {
        onErrorResponseMessage(responseRestModal.message ?? "");
        // if (currentContext != null) {
        //   CommonMethods.showErrorMessage(
        //     currentContext,
        //     responseRestModal.message ?? "",
        //   );
        // } else {
        //   log('Current context is null. The error is ${responseRestModal.message ?? ""}');
        // }
      }
    }
  }

  bool handleSuccessDisplay({
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onhandleSuccess,
    int? httpStatusCode,
    RestResponse? responseBody,
  }) {
    if (onhandleSuccess != null) {
      onhandleSuccess(httpStatusCode, responseBody);
    }

    return onhandleSuccess != null;
  }

  bool handleErrorDisplay({
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onhandleError,
    int? httpStatusCode,
    RestResponse? responseBody,
  }) {
    if (onhandleError != null) {
      onhandleError(httpStatusCode, responseBody);
    }

    return onhandleError != null;
  }

  bool _statusCodeCheck({
    required Response<dynamic> responseOrignal,
    required RestResponse responseRestModal,
  }) {
    try {
      return responseOrignal.statusCode == 200 &&
          (responseRestModal.data['status']['code'] == 200 ||
              responseRestModal.data['status']['code'] == 819);
    } catch (_) {
      return false;
    }
  }
}
