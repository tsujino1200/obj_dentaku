class GUIManager {
  Button[] buttons;
  String[] labels = {
    "(", ")", "M+", "M-", "MRC", "C",
    "7", "8", "9", "+", "^", "sin",
    "4", "5", "6", "-", "√", "cos",
    "1", "2", "3", "*", "ABS", "log",
    "0", ".", "", "/", "π", "="
  };

  int cols = 6;
  int rows = 5;
  int btnWidth = 120;
  int btnHeight = 150;
  
  String last = "";

  GUIManager() {
    buttons = new Button[labels.length];
    for (int i = 0; i < labels.length; i++) {
      int col = i % cols;
      int row = i / cols;
      int x = col * btnWidth;
      int y = 120 + row * btnHeight;
      buttons[i] = new Button(labels[i], x, y, btnWidth, btnHeight);
    }
  }

  //描画
  void drawAll(Calculator cal) {
    background(255);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(30);
    text(cal.input, width / 2, 40);

    if (cal.hasError) {
      fill(255, 0, 0);
      textSize(30);
      text(cal.errorMessage, width / 2, 80);
    } else {
      fill(0);
      textSize(30);
      text("= " + cal.result, width / 2, 80);
    }

    for (int i = 0; i < buttons.length; i++) {
      buttons[i].drawBtn();
    }
  }

  //ボタン入力
  void handleClick(int mx, int my, Calculator cal) {
    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].isClicked(mx, my)) {
        String label = buttons[i].label;
        
        if (label.equals("=")) {
          cal.errorChecker.evaluate(cal);
          
        } else if (label.equals("C")) {
          cal.input = "";
          last = "";
          cal.result = 0;
          cal.hasError = false;
          cal.errorMessage = "";
          
        } else if(label.equals("M+") || label.equals("M-") || label.equals("MRC")) {
          cal.memoryCal(label);
        
        } else {
          //"*"部分の省略表記の回避
          if(last == ")" || last == "0" || last == "1" || last == "2" || last == "3" || last == "4" 
          || last == "5" || last == "6" || last == "7" || last == "8" || last == "9") {
            
            if (label.equals("sin") || label.equals("cos") || label.equals("log") || label.equals("√") || label.equals("ABS")) {
              cal.input += "*" + label + "(";
            } else if(label.equals("(") || label.equals("π")) {
              cal.input += "*" + label;
            }
            last = "(";
          } else {
            if (label.equals("sin") || label.equals("cos") || label.equals("log") || label.equals("√") || label.equals("ABS")) {
              cal.input += label + "(";
              last = "(";
            } else if(label.equals("π")) {
              if(last != "+" && last != "-" && last != "*" && last != "/" && last != "("  && last != "" ) {
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
