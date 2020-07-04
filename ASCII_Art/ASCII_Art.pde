// based on these site https://youtu.be/0L2n8Tg2FwI
// https://en.wikipedia.org/wiki/Floyd%E2%80%93Steinberg_dithering

float ceh = 20;//cell height
float cew;
PImage img, adjImg, errImg, resImg, wdrImg;//original, error, result, without dithering result
ArrayList<PVector> colors = new ArrayList<PVector>();
String charUse = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_. ";
float brightAdj = 1;
PFont font;//prease chose fixed width font
int[] charId, charId2;
PrintWriter output;

void setup() {
  size(2000, 1000);
  //fullScreen();
  background(0);
  
  img = loadImage("FevCat.png");
  //img = loadImage("USA_Antelope-Canyon Under(PD).jpg");
  font = createFont("RubikMonoOne-Regular.ttf", 32);
  cew = ceh*font.width('A');
  img.resize(int(width/2/ceh/font.width('A')), int(height/ceh));
  img.filter(GRAY);
  img.filter(INVERT);
  charId = new int[imgIndex(img.width-2, img.height-1)];
  charId2 = new int[imgIndex(img.width-2, img.height-1)];
  image(img, 0, 0);
  
  fill(255);
  textAlign(LEFT, TOP);
  textFont(font);
  textSize(ceh);
  noStroke();
  //add text avg brightness data
  for(char c : charUse.toCharArray()){
    colors.add(b2RGB(calcAvgBright(font, c)));
  }
}

int imgIndex(int x, int y) {
  return x + y * img.width;
}
int canvIndex(int x, int y) {
  return x + y * width;
}

void draw() {
  background(0);
  //image sets
  brightAdj = map(mouseX, 0, width, 0, 2);
  adjImg = img.copy();
  for(int i=0; i<adjImg.pixels.length; i++){//adjast brightness
    adjImg.pixels[i] = toColor(toRGB(img.pixels[i]).mult(brightAdj));
  }
  errImg = adjImg.copy();//to copy image size
  resImg = adjImg.copy();
  wdrImg = adjImg.copy();
  for (int y = 0; y < img.height-1; y++) {
    for (int x = 1; x < img.width-1; x++) {
      PVector oldC = toRGB(errImg.pixels[imgIndex(x, y)]);
      int newCId = findNearestColor(oldC);
      charId[imgIndex(x, y)] = newCId;
      PVector newC = colors.get(newCId);
      resImg.pixels[imgIndex(x, y)] = toColor(newC);//set final result

      PVector errC = PVector.sub(oldC, newC);

      int ii = imgIndex(x+1, y);
      PVector c = toRGB(errImg.pixels[ii]);
      c.add(PVector.mult(errC, 7./16));
      errImg.pixels[ii] = toColor(c);

      ii = imgIndex(x-1, y+1);
      c = toRGB(errImg.pixels[ii]);
      c.add(PVector.mult(errC, 3./16));
      errImg.pixels[ii] = toColor(c);

      ii = imgIndex(x, y+1);
      c = toRGB(errImg.pixels[ii]);
      c.add(PVector.mult(errC, 5./16));
      errImg.pixels[ii] = toColor(c);


      ii = imgIndex(x+1, y+1);
      c = toRGB(errImg.pixels[ii]);
      c.add(PVector.mult(errC, 1./16));
      errImg.pixels[ii] = toColor(c);
      
      //example of without dithering
      PVector oldC2 = toRGB(adjImg.pixels[imgIndex(x, y)]);
      int newC2Id = findNearestColor(oldC2);
      charId2[imgIndex(x, y)] = newC2Id;
      PVector newC2 = colors.get(newC2Id);
      wdrImg.pixels[imgIndex(x, y)] = toColor(newC2);
    }
  }
  
  for (int y = 0; y < img.height-1; y++) {
    for (int x = 1; x < img.width-1; x++) {
      char c = charUse.charAt(charId[imgIndex(x, y)]);
      text(c+"", width/2+x*cew, y*ceh);
    }
  }
  
  image(img   , 0      , 0       , width/4, height/2);//original
  image(errImg, width/4, 0       , width/4, height/2);//error
  image(resImg, 0      , height/2, width/4, height/2);//result
  image(wdrImg, width/4, height/2, width/4, height/2);//without dithering
}

void keyPressed(){
  output = createWriter("output.txt"); 
  output.flush();
  for (int y = 0; y < img.height-1; y++) {
    String str = "";
    for (int x = 1; x < img.width-1; x++) {
      char c = charUse.charAt(charId[imgIndex(x, y)]);
      str += c;
    }
    output.println(str);
  }
  output.close();
}
