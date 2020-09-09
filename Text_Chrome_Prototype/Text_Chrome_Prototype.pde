//buggy when generate outline
float spacing = 20;//sampling interval, findNearestEdge doesn't work when straight corner. so becareful when set spacing low value
int pixelS = 1;//pixel size
PImage img;
ArrayList<ArrayList<Path>> charactors;

void setup(){
  size(1280, 720);
  //fullScreen();
  img = loadImage("sky pd.png");
  img.loadPixels();
  textAlign(CENTER, CENTER);
  charactors = genPath("Segoe UI", height/5, "Example", width/3.5, height/2);
  for(ArrayList<Path> charactor : charactors){
    for(Path path : charactor){
      path.sample(spacing ,true, true);
    }
  }
  
}

PVector findGlobalNearestEdge(PVector p){
  float bestD = Float.POSITIVE_INFINITY;
  PVector bestR = new PVector();
  for(ArrayList<Path> charactor : charactors){
    for(Path path : charactor){
      PVector result = path.findNearestEdge(p);
      if(result.z < bestD){
        bestD = result.z;
        bestR = result;
      }
    }
  }
  return bestR;
  //return charactors.get(0).get(0).findNearestEdge(p);
}

void draw(){
  background(0);
  noStroke();
  for(int i=0; i<width; i+=pixelS){
    for(int j=0; j<height; j+=pixelS){
      PVector result = findGlobalNearestEdge(new PVector(i, j));
      float dir = atan2(result.y, result.x);
      fill(map(dir, -PI, PI, 0, 360), result.z*100, 100);
      rect(i, j, pixelS, pixelS);
      float theta = dir;
      float phi = result.z/5-HALF_PI;
      int ix = (int)map(constrain((theta+PI), 0, TWO_PI), 0, TWO_PI, 0, img.width-1);
      int jx = (int)map(constrain((phi+HALF_PI), 0, PI), 0, PI, 0, img.height-1);
      fill(img.pixels[ix+jx*img.width]);
      rect(i, j, pixelS, pixelS);
    }println(i);
  }//println(charactors.get(0).get(0).sampledPs.size());
  stroke(255);
  noFill();
  //for(ArrayList<Path> charactor : charactors){
  //  beginShape();
  //  for(Path path : charactor){
  //    path.useSampledPs();
  //  }
  //  endShape();
  //}
}
