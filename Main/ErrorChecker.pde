class ErrorChecker {
  String generateErrorMessage(Exception e) {
    return "Error: " + e.getMessage(); //コンソールのエラーメッセージを画面に出力
  }

  void evaluateError(Calculator cal) {
    cal.hasError = false;
    cal.errorMessage = "";

    try {
      cal.result = cal.evaluate(cal.input); //数式解釈部分にエラーがある時
    } catch (Exception e) {
      cal.result = Float.NaN;
      cal.hasError = true;
      cal.errorMessage = generateErrorMessage(e);
    }
  }
}
