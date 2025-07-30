class GUIManager {
  Button[] buttons;
  Button modeToggleBtn;
  boolean isDarkMode = false;
  String[] labels = {
    "(", ")", "M+", "M-", "MRC", "C",
    "7", "8", "9", "+", "^", "sin",
    "4", "5", "6", "-", "√", "cos",
    "1", "2", "3", "*", "ABS", "log",
    "0", ".", "", "/", "π", "="
  };

  int cols = 6;
  int rows = 5;
  int btnWidth = 100;
  int btnHeight = 125;

  String last = "";

  GUIManager() {
    buttons = new Button[labels.length];
    for (int i = 0; i < labels.length; i++) {
      int col = i % cols;
      int row = i / cols;
      int x = col * btnWidth;
      int y = 120 + row * btnHeight;
      buttons[i] = new Button(labels[i], x, y, btnWidth, btnHeight); //切り替えボタン
    }
    modeToggleBtn = new Button("Mode", 0, 0, 100, 35);
  }

  //描画
  void drawAll(Calculator cal) {
    if(isDarkMode) {
      background(20);   // ダーク背景
      fill(255);        // 白文字
    } else {
      background(255);  // 白背景
      fill(0);          // 黒文字
    }

    textAlign(CENTER, CENTER);
    textSize(30);
    text(cal.input, width / 2, 40);

    if(cal.hasError) {
      fill(255, 0, 0);
      textSize(30);
      text(cal.errorMessage, width / 2, 80);
    } else {
      if(isDarkMode) {
        fill(255);
      } else {
        fill(0);
      }
      textSize(30);
      text("= " + cal.result, width / 2, 80);
    }

    for(int i = 0 ; i < buttons.length ; i++) {
      buttons[i].drawBtn(isDarkMode); //モード渡す
    }
    modeToggleBtn.drawBtn(isDarkMode);
  }

  //ボタン入力
  void handleClick(int mx, int my, Calculator cal) {
    if(modeToggleBtn.isClicked(mx, my)) {
      isDarkMode = !isDarkMode;
    }

    for(int i = 0 ; i < buttons.length ; i++) {
      if(buttons[i].isClicked(mx, my)) {
        String label = buttons[i].label;

        if(label.equals("=")) {
          cal.errorChecker.evaluateError(cal);
          
        } else if(label.equals("C")) {
          cal.input = "";
          last = "";
          cal.result = 0;
          cal.hasError = false;
          cal.errorMessage = "";
          
        } else if(label.equals("M+") || label.equals("M-") || label.equals("MRC")) {
          cal.memoryCal(label);
          
        } else {
          //"*"部分の省略表記の回避
          if(last.equals(")")) { // 閉じ括弧の後のルール
            if(label.equals("sin") || label.equals("cos") || label.equals("log") || label.equals("√") || label.equals("ABS")) {
              cal.input += "*" + label + "(";
              last = "(";
            } else if(label.equals("+") || label.equals("-") || label.equals("*") || label.equals("/") || label.equals("^") || label.equals(")")) {
              cal.input += label;
              last = label;
            } else {
              cal.input += "*" + label;
              last = label;
            }
            
          } else if(last.equals("0") || last.equals("1") || last.equals("2") || last.equals("3") || last.equals("4") 
          || last.equals("5") || last.equals("6") || last.equals("7") || last.equals("8") || last.equals("9") || last.equals("π")) { // 数の後のルール
            
            if(label.equals("sin") || label.equals("cos") || label.equals("log") || label.equals("√") || label.equals("ABS")) {
              cal.input += "*" + label + "(";
              last = "(";
            } else if(label.equals("(") || label.equals("π")) {
              cal.input += "*" + label;
              last = label;
            } else {
              cal.input += label;
              last = label;
            }
            
          } else { //その他のルール
            if(label.equals("sin") || label.equals("cos") || label.equals("log") || label.equals("√") || label.equals("ABS")) {
              cal.input += label + "(";
              last = "(";
            } else if(label.equals("π")) {
              if(!last.equals("+") && !last.equals("-") && !last.equals("*") && !last.equals("/") && !last.equals("^") && !last.equals("(") && !last.equals("") ) {
                cal.input += "*" + label;
                last = label;
              } else {
                cal.input += label;
                last = label;
              }
            } else {
              cal.input += label;
              if(label != "") {
                last = label;
              }
            }
          }
        }
      }
    }
  }
}
