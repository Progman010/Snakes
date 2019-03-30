Game g;

int NEGATIVE = -1000;
int SCALE;

int LASER_LEVEL = 254;

int clickDelay = 0;

PImage headImg;

int STATE = 0;

void setup() {
  headImg = loadImage("head.png");
  //size(640, 480);
  fullScreen();
  background(0);
  
  SCALE = 1;
  g = new Game();
  g.init(32);
  g.init(32);
  g.init(32);
}

void draw() {
  background(0);
  strokeWeight(12);
  stroke(255);
  if(clickDelay<=0&&(mousePressed && (mouseButton == LEFT))) {
    g.separate(mouseX, mouseY);
    //println("click", clickDelay);
    clickDelay = 0;
  }
  
  if(clickDelay>0) clickDelay --;
  if(g.qty()==0){
    println("WIN!!!");
  }
  g.refresh();
}