float calcAvgBright(PFont font, char c){
  int h = 100;
  int w = int(font.width('A')*h);
  PGraphics pg = createGraphics(w, h);
  pg.beginDraw();
  pg.textAlign(LEFT, TOP);
  pg.textFont(font);
  pg.textSize(h);
  pg.noStroke();
  pg.fill(255);
  pg.background(0);
  pg.text(c, 0, 0);
  pg.loadPixels();
  float sum = 0;
  for(int i=0; i<w; i++){
    for(int j=0; j<h; j++){
      sum += brightness(pg.pixels[j*w+i]);
    }
  }println(w, h);
  image(pg, 0, 0);
  return sum/(w*h);
}
