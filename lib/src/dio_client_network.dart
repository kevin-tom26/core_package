part of core_package;

class DioClient with HandleMessageServices {
  final Dio _dio;
  // injecting dio instance
  final Function(DioException) handleTokenExpiry;
  //final BuildContext context;
  final Function(String message) onErrorResponseMessage;
  final Function(String message) onSuccessResponseMessage;
  DioClient(this._dio, this.handleTokenExpiry, this.onErrorResponseMessage,
      this.onSuccessResponseMessage);

  // Get:-----------------------------------------------------------------------
  Future<RestResponse> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    String? contentType,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool paginate = false,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleSuccessDisplay,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleErrorDisplay,
  }) async {
    RestResponse _response = RestResponse(
      apiSuccess: false,
      statusCode: 400,
    );

    try {
      _dio.options.contentType =
          contentType ?? 'application/json; charset=utf-8';
      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.data is String) {
        return _response;
      }
      if (response.statusCode == 200) {
        // if (context.mounted) {
        //   handleSuccess(
        //       responseOrignal: response,
        //       responseRestModal: _response,
        //       onHandleSuccessDisplay: onHandleSuccessDisplay,
        //       onHandleErrorDisplay: onHandleErrorDisplay,
        //       currentContext: context);
        // } else {
        handleSuccess(
            responseOrignal: response,
            responseRestModal: _response,
            onHandleSuccessDisplay: onHandleSuccessDisplay,
            onHandleErrorDisplay: onHandleErrorDisplay,
            onSuccessResponseMessage: onSuccessResponseMessage,
            onErrorResponseMessage: onErrorResponseMessage);
        // }
      }
      if (paginate) {
        _response.totalPages = response.data['response']['totalPages'];
      }
    } on DioException catch (e) {
      await handleTokenExpiry(e);
      // if (context.mounted) {
      //   handleError(
      //       dioError: e,
      //       responseRestModal: _response,
      //       onHandleErrorDisplay: onHandleErrorDisplay,
      //       currentContext: context);
      // } else {
      handleError(
          dioError: e,
          responseRestModal: _response,
          onHandleErrorDisplay: onHandleErrorDisplay,
          onErrorResponseMessage: onErrorResponseMessage);
      //}
    }
    return _response;
  }

  // Post:----------------------------------------------------------------------
  Future<RestResponse> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    String? contentType,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool paginate = false,
    header,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleSuccessDisplay,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleErrorDisplay,
  }) async {
    RestResponse _response = RestResponse(
      apiSuccess: false,
      statusCode: 400,
    );
    try {
      _dio.options.contentType =
          contentType ?? 'application/json; charset=utf-8';
      if (header != null) {
        _dio.options.headers.addAll(header);
      }
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 &&
          response.data is String &&
          (response.data as String).isEmpty) {
        _response = RestResponse(
          apiSuccess: true,
          statusCode: 200,
        );
        return _response;
      }
      if (response.data is String) {
        return _response;
      }
      if (response.statusCode == 200) {
        // if (context.mounted) {
        //   handleSuccess(
        //       responseOrignal: response,
        //       responseRestModal: _response,
        //       onHandleSuccessDisplay: onHandleSuccessDisplay,
        //       onHandleErrorDisplay: onHandleErrorDisplay,
        //       currentContext: context);
        // } else {
        handleSuccess(
            responseOrignal: response,
            responseRestModal: _response,
            onHandleSuccessDisplay: onHandleSuccessDisplay,
            onHandleErrorDisplay: onHandleErrorDisplay,
            onSuccessResponseMessage: onSuccessResponseMessage,
            onErrorResponseMessage: onErrorResponseMessage);
        // }
      }
      if (paginate) {
        _response.totalPages = response.data['response']['totalPages'];
      }
    } on DioException catch (e) {
      print(e.error);

      await handleTokenExpiry(e);
      // if (context.mounted) {
      //   handleError(
      //       dioError: e,
      //       responseRestModal: _response,
      //       onHandleErrorDisplay: onHandleErrorDisplay,
      //       currentContext: context);
      // } else {
      handleError(
          dioError: e,
          responseRestModal: _response,
          onHandleErrorDisplay: onHandleErrorDisplay,
          onErrorResponseMessage: onErrorResponseMessage);
      //}
    }
    return _response;
  }

  //Put:------------------------------------------------------------------------
  Future<RestResponse> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? contentType,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    header,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleSuccessDisplay,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleErrorDisplay,
  }) async {
    RestResponse _response = RestResponse(apiSuccess: false);
    try {
      _dio.options.contentType =
          contentType ?? 'application/json; charset=utf-8';
      if (header != null) {
        _dio.options.headers.addAll(header);
      }
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 &&
          response.data is String &&
          (response.data as String).isEmpty) {
        _response = RestResponse(
          apiSuccess: true,
          statusCode: 200,
        );
        return _response;
      }

      if (response.data is String) {
        return _response;
      }
      if (response.statusCode == 200) {
        // if (context.mounted) {
        //   handleSuccess(
        //       responseOrignal: response,
        //       responseRestModal: _response,
        //       onHandleSuccessDisplay: onHandleSuccessDisplay,
        //       onHandleErrorDisplay: onHandleErrorDisplay,
        //       currentContext: context);
        // } else {
        handleSuccess(
            responseOrignal: response,
            responseRestModal: _response,
            onHandleSuccessDisplay: onHandleSuccessDisplay,
            onHandleErrorDisplay: onHandleErrorDisplay,
            onSuccessResponseMessage: onSuccessResponseMessage,
            onErrorResponseMessage: onErrorResponseMessage);
        // }
      }
    } on DioException catch (e) {
      print(e.error);
      await handleTokenExpiry(e);
      // if (context.mounted) {
      //   handleError(
      //       dioError: e,
      //       responseRestModal: _response,
      //       onHandleErrorDisplay: onHandleErrorDisplay,
      //       currentContext: context);
      // } else {
      handleError(
          dioError: e,
          responseRestModal: _response,
          onHandleErrorDisplay: onHandleErrorDisplay,
          onErrorResponseMessage: onErrorResponseMessage);
      //}
    }
    return _response;
  }

  //Delete:------------------------------------------------------------------------
  Future<RestResponse> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleSuccessDisplay,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleErrorDisplay,
  }) async {
    RestResponse _response = RestResponse(
      apiSuccess: false,
      statusCode: 400,
    );
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      if (response.data is String) {
        return _response;
      }
      if (response.statusCode == 200) {
        // if (context.mounted) {
        //   handleSuccess(
        //       responseOrignal: response,
        //       responseRestModal: _response,
        //       onHandleSuccessDisplay: onHandleSuccessDisplay,
        //       onHandleErrorDisplay: onHandleErrorDisplay,
        //       currentContext: context);
        // } else {
        handleSuccess(
            responseOrignal: response,
            responseRestModal: _response,
            onHandleSuccessDisplay: onHandleSuccessDisplay,
            onHandleErrorDisplay: onHandleErrorDisplay,
            onSuccessResponseMessage: onSuccessResponseMessage,
            onErrorResponseMessage: onErrorResponseMessage);
        // }
      }
    } on DioException catch (e) {
      print(e.error);
      await handleTokenExpiry(e);
      // if (context.mounted) {
      //   handleError(
      //       dioError: e,
      //       responseRestModal: _response,
      //       onHandleErrorDisplay: onHandleErrorDisplay,
      //       currentContext: context);
      // } else {
      handleError(
          dioError: e,
          responseRestModal: _response,
          onHandleErrorDisplay: onHandleErrorDisplay,
          onErrorResponseMessage: onErrorResponseMessage);
      //}
    }
    return _response;
  }

  Future<RestResponse> download(
    String uri, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleSuccessDisplay,
    void Function(
      int? httpStatusCode,
      RestResponse? responseBody,
    )? onHandleErrorDisplay,
  }) async {
    RestResponse _response = RestResponse(
      apiSuccess: false,
      statusCode: 400,
    );
    try {
      final Response response = await _dio.download(
        uri,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.data is String) {
        return _response;
      }
      if (response.data != null && response.statusCode == 200) {
        // if (context.mounted) {
        //   handleSuccess(
        //       responseOrignal: response,
        //       responseRestModal: _response,
        //       onHandleSuccessDisplay: onHandleSuccessDisplay,
        //       onHandleErrorDisplay: onHandleErrorDisplay,
        //       currentContext: context);
        // } else {
        handleSuccess(
            responseOrignal: response,
            responseRestModal: _response,
            onHandleSuccessDisplay: onHandleSuccessDisplay,
            onHandleErrorDisplay: onHandleErrorDisplay,
            onSuccessResponseMessage: onSuccessResponseMessage,
            onErrorResponseMessage: onErrorResponseMessage);
        // }
      }
    } on DioException catch (e) {
      print(e.error);
      await handleTokenExpiry(e);

      // if (context.mounted) {
      //   handleError(
      //       dioError: e,
      //       responseRestModal: _response,
      //       onHandleErrorDisplay: onHandleErrorDisplay,
      //       currentContext: context);
      // } else {
      handleError(
          dioError: e,
          responseRestModal: _response,
          onHandleErrorDisplay: onHandleErrorDisplay,
          onErrorResponseMessage: onErrorResponseMessage);
      //}
    }
    return _response;
  }
}
