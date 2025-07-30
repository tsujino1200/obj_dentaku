class Button {
  String label;
  int x, y, w, h;

  Button(String label, int x, int y, int w, int h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void drawBtn(boolean isDark) {
    color btnc;
    if(label.equals("C")) {
      if(isDark) {
        btnc = color(100, 50, 50);
      } else {
        btnc = color(255, 200, 200);
      }
      
    } else if(label.equals("=")) {
      if(isDark) {
        btnc = color(50, 50, 100);
      } else {
        btnc = color(200, 200, 255);
      }

    } else if(label.equals("M+") || label.equals("M-") || label.equals("MRC")) {
      if(isDark) {
        btnc = color(50, 100, 50);
      } else {
        btnc = color(200, 255, 200);
      }

    } else if(label.equals("")) {
      if(isDark) {
        btnc = color(50);
      } else {
        btnc = color(100);
      }

    } else {
      if(isDark) {
        btnc = color(80);
      } else {
        btnc = color(240);
      }
    }

    fill(btnc);
    rect(x, y, w, h);
    if(isDark) {
      fill(255);
    } else {
      fill(0);
    }
    textAlign(CENTER, CENTER);
    textSize(35);
    text(label, x + w/2, y + h/2);
  }

  boolean isClicked(int mx, int my) {
    return (x <= mx && mx <= x + w) && (y <= my && my <= y + h);
  }
}
