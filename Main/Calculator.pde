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
  float evaluate(String expr) throws Exception {
    
    String pied = "";
    char[] exprChars = expr.toCharArray();
    
    // π を数値に変換
    for(int i = 0 ; i < expr.length() ; i++) {
      if(exprChars[i] == 'π') {
        pied += "3.141592653589793";
      } else {
        pied += exprChars[i];
      }
    }

    //各種関数の計算
    String[] functions = { "sin", "cos", "log", "√", "ABS"};
    for(int f = 0 ; f < functions.length ; f++) {
      String funcName = functions[f];
      char[] piedChars = pied.toCharArray();

      // 複数同一関数がある場合すべて処理
      for(int i = 0 ; i < piedChars.length - funcName.length() ; i++) {
        
        // 関数名と "(" が一致するか確認
        boolean match = true;
        char[] funcChars = funcName.toCharArray();
        for(int j = 0 ; j < funcName.length() ; j++) {
          if(piedChars[i + j] != funcChars[j]) {
            match = false;
            break;
          }
        }

        if(match && piedChars[i + funcName.length()] == '(') {
          int start = i;
          int open = i + funcName.length();
          int close = -1;

          //関数の括弧の成立の確認
          for(int k = open + 1 ; k < piedChars.length ; k++) {
            if(piedChars[k] == ')') {
              close = k;
              break;
            }
          }
          if(close == -1) {
            throw new Exception("括弧が不適切です");
          }

          // 括弧内文字列を数値評価
          String inner = "";
          for(int k = open + 1 ; k < close ; k++) {
            inner += piedChars[k];
          }

          float val = evaluate(inner); //括弧内の値を再起で演算
          float result = 0;
          
          //関数毎にFunctionクラスに渡す
          if(funcName.equals("sin")) {
            result = func.Sin(val);
          }
          if(funcName.equals("cos")) {
            result = func.Cos(val);
          }
          if(funcName.equals("log")) {
            if(val == 0) {
              throw new ArithmeticException("Logarithm of zero"); //log0にエラーメッセージ
            }
            result = func.Log(val);
          }
          if(funcName.equals("√")) {
            result = func.Root(val);
          }
          if(funcName.equals("ABS")) {
            result = func.ABS(val);
          }

          // 置換後の新しい式を組み立てる
          String newPied = "";
          for(int k = 0 ; k < start ; k++) {
            newPied += piedChars[k];
          }
          newPied += result;
          for(int k = close + 1 ; k < piedChars.length ; k++) {
            newPied += piedChars[k];
          }

          // 再評価のために置き換えた式を反復
          pied = newPied;
          piedChars = pied.toCharArray();
          i = -1; // 最初から検索し直し
        }
      }
    }

    //四則等演算に渡す
    return calc4(pied);
  }

  //四則等演算
  float calc4(String expr) throws Exception {
    String[] tokens = new String[100]; //式の全要素
    int[] precs = new int[100]; //全トークン毎の優先度
    tokenize(expr, tokens, precs); //トークナイズ、数と演算子の分解と優先度付与

    float[] values = new float[100];  //数
    String[] ops = new String[100];  //演算子
    int[] opPrec = new int[100];  //優先度一覧

    int valTop = -1; //数トークン列の長さ
    int opTop = -1; //演算子トークン列の長さ

    
    for(int i = 0 ; i < tokens.length && tokens[i] != null ; i++) {
      String token = tokens[i];
      
      //括弧はループ無視
      if(token.equals("(")) {
        continue;
      } else if(token.equals(")")) {
        continue;
        
      //演算子の時
      } else if(isOperator(token)) {
        while(opTop >= 0 && precedence(ops[opTop], opPrec[opTop]) >= precedence(token, precs[i])) { //より優先度の高い演算子を受け取る
          valTop = functionOperator(values, valTop, ops[opTop--]); //その演算子と前後の数を削除、演算結果の数を入れる
        }
        ops[++opTop] = token; //演算子を記録
        opPrec[opTop] = precs[i]; // その優先度も記録
        
      } else {
        values[++valTop] = Float.parseFloat(token); //数を記録
      }
    }

    while(opTop >= 0) {
      valTop = functionOperator(values, valTop, ops[opTop--]);
    }

    return values[valTop];
  }
  
  //数式の分割と優先度付与
  void tokenize(String expr, String[] tokens, int[] precs) {
    String num = "";
    int index = 0;
    int prec = 0;
    char[] exprChars = expr.toCharArray();
    for(int i = 0 ; i < exprChars.length ; i++) {
      
      //括弧の間は優先度が上がる
      char c = exprChars[i];
      if(c == '(') {
        prec++;
        tokens[index] = "(";
        precs[index++] = prec;
      } else if(c == ')') {
        tokens[index] = ")";
        precs[index++] = prec;
        prec--;
        
      //複数桁の数字を1トークン内に入れる
      } else if(('0' <= c && c <= '9') || c == '.') { 
        num += c;
        
      //+,-ではじまる値を数値として認識
      } else if((c == '+' || c == '-') && (i == 0 || exprChars[i - 1] == '(' || isOperator(Character.toString(exprChars[i - 1])))) {
        num += c;
        
      //数値以外が登場した部分で区切る
      } else {
        if(!num.equals("")) {
          tokens[index] = num;
          precs[index++] = prec;
          num = "";
        }
        tokens[index] = Character.toString(c);
        precs[index++] = prec;
      }
    }
    
    //末尾でも区切る
    if(!num.equals("")) {
      tokens[index] = num;
      precs[index++] = prec;
    }
  }

  //文字から演算子への変換
  boolean isOperator(String op) {
    if(op.equals("+") || op.equals("-") || op.equals("*") || op.equals("/") || op.equals("^")) {
      return true;
    } else {
      return false;
    }
  }
  
  //計算優先度
  int precedence(String op, int prec) {
    int base = 0;
    if(op.equals("+") || op.equals("-")) {
      base = 1;
    } else if(op.equals("*") || op.equals("/")) {
      base = 2;
    } else if(op.equals("^")) {
      base = 3;
    }
    
    return base + prec * 3;
  }

  //演算子呼び出しとトークン短縮
  int functionOperator(float[] values, int valTop, String op) {
    float b = values[valTop--]; //演算に関わる数の取り出し
    float a = values[valTop--]; //演算に関わる数の取り出し
    float res = 0;
    
    if(op.equals("+")) {
      res = func.Add(a, b);
    } else if(op.equals("-")) {
      res = func.Sub(a, b);
    } else if(op.equals("*")) {
      res = func.Mult(a, b);
    } else if(op.equals("/")) {
      if(b == 0) {
        throw new ArithmeticException("Division by zero"); //ゼロ乗算にエラーメッセージ
      }
      res = func.Div(a, b);
    } else if(op.equals("^")) {
      res = func.Pow(a, b);
    }
    
    values[++valTop] = res; //演算結果を入れなおす
    return valTop; //数のトークン列は短くなる
  }
  
  //メモリ機能
  void memoryCal(String m) {
    if(m.equals("M+")) {
      memory += result;
    } else if(m.equals("M-")) {
      memory -= result;
    } else if(m.equals("MRC")) {
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
