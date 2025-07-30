class Button{
  String label;
  int x , y , w , h;
  Button(String Label , int X , int Y , int W , int H) {
    label = Label;
    x = X;
    y = Y;
    w = W;
    h = H;
  }
  
  void drawBtn() {
    color btnc;
    if(label == "C") {
      btnc = color(255,200,200);
    } else if(label == "=") {
      btnc = color(200,200,255);
    } else if(label == "M+" || label == "M-" || label == "MRC") {
      btnc = color(200,255,200);
    } else if(label == "") {
      btnc = color(100);
    } else {
      btnc = color(240);
    }
    
    fill(btnc);
    rect(x,y,w,h);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(70);
    text(label , x+w/2 , y+h/2);
  }
    
  boolean isClicked(int mx , int my) {
    boolean judge = false;
    if( (x <= mx && mx <= x+w) && (y <= my && my <= y+h) ) {
      judge = true;
    }
    return judge;
  }
}
