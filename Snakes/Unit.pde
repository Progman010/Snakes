class Unit {
  int UNIT_STEP_MIN = 1;
  int UNIT_STEP = 2;
  int UNIT_ANGLE = 3;
  int UNIT_RADIUS_MIN = 50;
  int UNIT_RADIUS_MAX = 120;
  int UNIT_PADDING = 10;
  float UNIT_SEG_LENGTH = 18;
  
  float[] x;
  float[] y;
  
  
  int segmentsQty;
  
  int f = 0;
  int rx,ry,ra,rv,rk;
  
  int alpha = 0;
  
  
  PVector head = new PVector(width/2, height/2);
  PVector center = new PVector(width/2, height/2);
  Unit(int segmentsQty){
     this.segmentsQty = segmentsQty;
     x = new float[segmentsQty];
     y = new float[segmentsQty];
  }
  
  Unit(Unit fullUnit, int splitIndex, boolean isPrev){
    this.segmentsQty = isPrev ? splitIndex+1 : fullUnit.segmentsQty - splitIndex+1;
    int addSpeed = round(map(segmentsQty, 32, 5, 0, 5));
    UNIT_STEP_MIN+=addSpeed;
    UNIT_STEP+=addSpeed;
    int from = isPrev ? 0 : splitIndex + 1;
    int to = isPrev ? segmentsQty : fullUnit.segmentsQty;
    println("splitIndex ", splitIndex, "fullUnit.segmentsQty", fullUnit.segmentsQty);
    println("from ", from, "to ", to);
    x = new float[segmentsQty];
    y = new float[segmentsQty];
    int index = 0;
    for(int i=from; i<to; i++) {
       x[index] = fullUnit.x[i];
       y[index] = fullUnit.y[i];
       index++;
    }
    ra = fullUnit.ra;
    alpha = fullUnit.alpha+120*round(random(-1, 1));
    rv = fullUnit.rv;
    head.x = isPrev ? fullUnit.head.x : fullUnit.x[from];
    head.y = isPrev ? fullUnit.head.y : fullUnit.y[from];
  }
  
  //Unit(Unit fullUnit, int splitIndex, boolean isPrev){
  //  if(isPrev) {
  //     segmentsQty = splitIndex+1;
  //     x = new float[segmentsQty];
  //     y = new float[segmentsQty];
  //     for(int i=0; i<segmentsQty; i++) {
  //       x[i] = fullUnit.x[i];
  //       y[i] = fullUnit.y[i];
  //     }
  //  }
  //  else {
  //     segmentsQty = fullUnit.segmentsQty - splitIndex+1;
  //     x = new float[segmentsQty];
  //     y = new float[segmentsQty];
  //     for(int i=0; i<splitIndex; i++) {
  //       x[i] = fullUnit.x[i+splitIndex];
  //       y[i] = fullUnit.y[i+splitIndex];
  //     }
  //  }
  //  int size = isPrev ? splitIndex : fullUnit.segmentsQty - splitIndex+1;
  //  int from = isPrev ? 0 : size;
  //  int to = isPrev ? size : fullUnit.segmentsQty;
  //  x = new float[size];
  //  y = new float[size];
  //  int index = 0;
  //  for(int i=from; i<to; i++) {
  //     x[index] = fullUnit.x[i];
  //     y[index] = fullUnit.y[i];
  //     index++;
  //  }
  //  center.x = x[0]-rotation(center.x, center.y, UNIT_RADIUS_MIN, alpha).x;
  //  center.y = y[0]-rotation(center.x, center.y, UNIT_RADIUS_MIN, alpha).y;
  //}
  
  void refresh(){
    int rt = round(random(20, 70));
    if(f>rt)
    {
        //rx=round(random(-1, 1)*random(UNIT_STEP_MIN, UNIT_STEP));
        //ry=round(random(-1, 1)*random(UNIT_STEP_MIN, UNIT_STEP));
        ra = round(random(-UNIT_ANGLE, UNIT_ANGLE));
        rv=round(random(UNIT_STEP_MIN, UNIT_STEP));
        rk=round(random(-1, 1));
        f=0;
    }
    f++;
    alpha+=ra;
    head.x+=rv*sin(radians(alpha));
    head.y+=rv*cos(radians(alpha));
    //head = rotation(center.x, center.y, UNIT_RADIUS_MIN, alpha);
    
    if(head.y < UNIT_PADDING||head.x < UNIT_PADDING||head.y > height - UNIT_PADDING||head.x > width - UNIT_PADDING) {
      alpha+=rk*UNIT_ANGLE*2;
    }
    if(head.x > width - UNIT_PADDING) head.x -= UNIT_STEP_MIN;
    if(head.y > height - UNIT_PADDING) head.y -= UNIT_STEP_MIN;
    if(head.x < UNIT_PADDING) head.x += UNIT_STEP_MIN;
    if(head.y < UNIT_PADDING) head.y += UNIT_STEP_MIN;
    
    strokeWeight(18);
    stroke(255, 255, 0);
    dragSegment(0, head.x, head.y);
    for(int i=0; i<x.length-1; i++) {
      strokeWeight(18);
      if(mousePressed && (mouseButton == LEFT) && separateIndex(mouseX, mouseY)== i){
        stroke(255, 0, 0);
      }
      else{
        switch(i%2){
          case 0:
            stroke(0, 255, 0);
            break;
          case 1:
            stroke(255, 255, 0);
            break;
        }
      }
      dragSegment(i+1, x[i], y[i]);
    }
    
    translate(head.x, head.y);
    float an = PI;
    rotate(-radians(alpha)+an);
    imageMode(CENTER);
    image(headImg, 0, -20, 30, 50);
    imageMode(CORNER);
    rotate(radians(alpha)-an);
    translate(-head.x, -head.y);
  }
  
  
  int separateIndex(float xS, float yS){
    for(int i=0; i<x.length-1; i++) {
      if(sqrt(pow((x[i] - xS), 2) + pow((y[i] - yS), 2)) <= UNIT_SEG_LENGTH/2){
        return i;
      }
    }
    return -1;
  }
  
  void dragSegment(int i, float xin, float yin) {
    float dx = xin - x[i];
    float dy = yin - y[i];
    float angle = atan2(dy, dx);
    x[i] = xin - cos(angle) * UNIT_SEG_LENGTH;
    y[i] = yin - sin(angle) * UNIT_SEG_LENGTH;
    segment(x[i], y[i], angle);
  }

  void segment(float x, float y, float a) {
    pushMatrix();
    translate(x, y);
    rotate(a);
    line(0, 0, UNIT_SEG_LENGTH, 0);
    popMatrix();
  }
  
  PVector rotation(float a, float b, float y, float alpha)
  {
     float x = y;
     float alpradian = ((alpha * PI) / 180);
     int rad=round(sqrt((x*x)+(y*y)));
     float betta = asin(x/ (sqrt((x*x)+(y*y))) );
     return new PVector(round((rad*sin(alpradian+betta))+a), round((rad*cos(alpradian+betta))+b));
  }
}