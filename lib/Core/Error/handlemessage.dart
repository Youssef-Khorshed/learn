String getErrorMessage(int statusCode) {
  switch (statusCode) {
    case 200:
      return "Success! Data fetched.";
    case 400:
      return "Bad Request: Please check your parameters.";
    case 401:
      return "Unauthorized: Check your API key.";
    case 403:
      return "Forbidden: You don't have access to this resource.";
    case 404:
      return "Not Found: The requested resource could not be found.";
    case 408:
      return "Request Timeout: The server took too long to respond.";
    case 422:
      return "Unprocessable Entity: The request was well-formed but unable to be followed due to semantic errors.";
    case 500:
      return "Server Error: Something went wrong on the server.";
    case 503:
      return "Service Unavailable: The service is temporarily down.";
    default:
      return "Unexpected error: $statusCode. Please try again later.";
  }
}
