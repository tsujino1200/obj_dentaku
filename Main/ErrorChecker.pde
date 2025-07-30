class ErrorChecker {
  String generateErrorMessage(Exception e) {
    return "Error: " + e.getMessage();
  }

  void evaluate(Calculator cal) {
    cal.hasError = false;
    cal.errorMessage = "";

    try {
      cal.result = cal.parseAndEvaluate(cal.input);
    } catch (Exception e) {
      cal.result = Float.NaN;
      cal.hasError = true;
      cal.errorMessage = generateErrorMessage(e);
    }
  }
}
