class Calculator {
  String input = "";
  float result = 0;
  float memory = 0;
  boolean MRCed = false;
  
  Function func = new Function();
  
  ErrorChecker errorChecker = new ErrorChecker();
  boolean hasError = false;
  String errorMessage = "";
  
  //文字列を数式に解釈
  float parseAndEvaluate(String expr) throws Exception {
    
    String pied = "";

    // π を数値に変換
    for (int i = 0; i < expr.length(); i++) {
      char c = expr.charAt(i);
      if (c == 'π') {
        pied += "3.141592653589793";
      } else {
        pied += c;
      }
    }

    //各種関数の計算
    String[] functions = { "sin", "cos", "log", "√" , "ABS"};
    for (int f = 0; f < functions.length; f++) {
      String funcName = functions[f];
      char[] chars = pied.toCharArray();

      // 複数同一関数がある場合すべて処理
      for (int i = 0; i < chars.length - funcName.length(); i++) {
        // 関数名と "(" が一致するか確認
        boolean match = true;
        
        for (int j = 0; j < funcName.length(); j++) {
          if (chars[i + j] != funcName.charAt(j)) {
            match = false;
            break;
          }
        }

        if (match && chars[i + funcName.length()] == '(') {
          int start = i;
          int open = i + funcName.length();
          int close = -1;

          for (int k = open + 1; k < chars.length; k++) {
            if (chars[k] == ')') {
              close = k;
              break;
            }
          }
          if (close == -1) {
            throw new Exception("括弧が不適切です");
          }

          // 括弧内文字列を数値評価
          String inner = "";
          for (int k = open + 1; k < close; k++) {
            inner += chars[k];
          }

          float val = parseAndEvaluate(inner); //括弧内の値を再起で演算
          float result = 0;
          //関数毎にFunctionクラスに渡す
          if (funcName.equals("sin")) {
            result = func.Sin(val);
          }
          if (funcName.equals("cos")) {
            result = func.Cos(val);
          }
          if (funcName.equals("log")) {
            if(val == 0) {
              throw new ArithmeticException("Logarithm of zero"); //log0にエラーメッセージ
            }
            result = func.Log(val);
          }
          if (funcName.equals("√")) {
            result = func.Root(val);
          }
          if (funcName.equals("ABS")) {
            result = func.ABS(val);
          }

          // 置換後の新しい式を組み立てる
          String newPied = "";
          for (int k = 0; k < start; k++) {
            newPied += chars[k];
          }
          newPied += result;
          for (int k = close + 1; k < chars.length; k++) {
            newPied += chars[k];
          }

          // 再評価のために置き換えた式を反復
          pied = newPied;
          chars = pied.toCharArray();
          i = -1; // 最初から検索し直し
        }
      }
    }

    //四則等演算に渡す
    return evalSimple(pied);
  }

  //四則等演算
  float evalSimple(String expr) throws Exception {
    String[] tokens = new String[100]; //式の全要素
    int[] depths = new int[100]; //全トークン毎の優先度
    tokenizeWithDepth(expr, tokens, depths); //数と演算子の分解

    float[] values = new float[100];  //数
    String[] ops = new String[100];  //演算子
    int[] opDepths = new int[100];  //優先度一覧

    int valTop = -1;
    int opTop = -1;

    for (int i = 0; i < tokens.length && tokens[i] != null; i++) {
      String token = tokens[i];
      if (token.equals("(")) {
        continue;
      } else if (token.equals(")")) {
        continue;
      } else if (isOperator(token)) {
        while (opTop >= 0 && precedence(ops[opTop], opDepths[opTop]) >= precedence(token, depths[i])) {
          valTop = processOperator(values, valTop, ops[opTop--]);
        }
        ops[++opTop] = token;
        opDepths[opTop] = depths[i]; // 深さも記録
      } else {
        values[++valTop] = Float.parseFloat(token);
      }
    }

    while (opTop >= 0) {
      valTop = processOperator(values, valTop, ops[opTop--]);
    }

    return values[valTop];
  }
  
  //数式の分割と優先度付与
  void tokenizeWithDepth(String expr, String[] tokens, int[] depths) {
    String num = "";
    int index = 0;
    int depth = 0;
    char[] exprChars = expr.toCharArray();
    for (int i = 0; i < exprChars.length; i++) {
      char c = exprChars[i];
      //括弧の間は優先度が上がる
      if (c == '(') {
        depth++;
        tokens[index] = "(";
        depths[index++] = depth;
      } else if (c == ')') {
        tokens[index] = ")";
        depths[index++] = depth;
        depth--;
        
      //複数桁の数字を1トークン内に入れる
      } else if ((c >= '0' && c <= '9') || c == '.') { 
        num += c;
        
      //+,-ではじまる値を数値として認識
      } else if ((c == '+' || c == '-') && (i == 0 || exprChars[i - 1] == '(' || isOperator(Character.toString(exprChars[i - 1])))) {
        num += c;
        
      } else {
        if (!num.equals("")) {
          tokens[index] = num;
          depths[index++] = depth;
          num = "";
        }
        tokens[index] = Character.toString(c);
        depths[index++] = depth;
      }
    }
    if (!num.equals("")) {
      tokens[index] = num;
      depths[index++] = depth;
    }
  }

  //文字から演算子への変換
  boolean isOperator(String op) {
    return op.equals("+") || op.equals("-") ||
    op.equals("*") || op.equals("/") || op.equals("^");
  }
  
  //計算優先度
  int precedence(String op, int depth) {
    int base = 0;
    if (op.equals("+") || op.equals("-")) {
      base = 1;
    } else if (op.equals("*") || op.equals("/")) {
      base = 2;
    } else if(op.equals("^")) {
      base = 3;
    }
    return base + depth * 3;
  }

  //演算子呼び出し
  int processOperator(float[] values, int valTop, String op) {
    float b = values[valTop--];
    float a = values[valTop--];
    float res = 0;
    if (op.equals("+")) {
      res = func.Add(a, b);
    } else if (op.equals("-")) {
      res = func.Sub(a, b);
    } else if (op.equals("*")) {
      res = func.Mult(a, b);
    } else if (op.equals("/")) {
      if (b == 0) {
        throw new ArithmeticException("Division by zero"); //ゼロ乗算にエラーメッセージ
      }
      res = func.Div(a, b);
    } else if (op.equals("^")) {
      res = func.Pow(a, b);
    }
    values[++valTop] = res;
    return valTop;
  }
  
  //メモリ機能
  void memoryCal(String m) {
    if(m == "M+") {
      memory += result;
    } else if(m == "M-") {
      memory -= result;
    } else if(m == "MRC") {
      if(!MRCed) {
        input = str(memory);
        MRCed = true;
      } else {
        memory = 0;
        MRCed = false;
      }
    }
  }
}
