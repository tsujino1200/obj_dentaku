GUIManager gui;
Calculator cal;

void setup() {
  size(720, 864);
  cal = new Calculator();
  gui = new GUIManager();
}

void draw() {
  background(255);
  gui.drawAll(cal);
}

void mouseClicked() {
  gui.handleClick(mouseX, mouseY, cal);
}
