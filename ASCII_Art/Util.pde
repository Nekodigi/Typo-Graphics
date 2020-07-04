int findNearestColor(PVector target){
  float bestD = Float.POSITIVE_INFINITY;
  int resultId = 0;
  for(int i=0; i<colors.size(); i++){
    PVector col = colors.get(i);
    float sqD = PVector.dist(target, col);
    if(bestD > sqD){
      bestD = sqD;
      resultId = i;
    }
  }
  return resultId;
}

float calcAvgBright(PFont font, char c){
  int h = 20;
  int w = int(font.width('A')*h);
  PGraphics pg = createGraphics(w, h);
  pg.beginDraw();
  pg.textAlign(LEFT, TOP);
  pg.textFont(font);
  pg.textSize(h);
  pg.noStroke();
  pg.background(0);
  pg.text(c, 0, 0);
  pg.loadPixels();
  float sum = 0;
  for(int i=0; i<w; i++){
    for(int j=0; j<h; j++){
      sum += brightness(pg.pixels[j*w+i]);
    }
  }
  return sum/(w*h);
}
