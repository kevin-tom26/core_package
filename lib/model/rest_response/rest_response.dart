part of core_package;

class RestResponse {
  var message;
  var apiSuccess;
  var data;
  var totalPages;
  var statusCode;

  RestResponse({
    this.message,
    this.apiSuccess,
    this.data,
    this.totalPages,
    this.statusCode,
  });
}
