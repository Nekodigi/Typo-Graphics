float spacing = 1;//sampling interval
float noiseS = 500;//noise scale
float noiseP = 0.1;//noise power
ArrayList<ArrayList<Path>> charactors;

void setup(){
  size(1280, 720);
  //fullScreen();
  textAlign(CENTER, CENTER);
  charactors = genPath("Segoe UI", height/5, "Example!", width/3.5, height/2);
  for(ArrayList<Path> charactor : charactors){
    for(Path path : charactor){
      path.sample(spacing ,true);
    }
  }
  
}

void draw(){
  background(0);
  for(ArrayList<Path> charactor : charactors){
    for(Path path : charactor){
      path.update();
    }
  }
  
  noStroke();
  for(ArrayList<Path> charactor : charactors){
    beginShape();
    for(Path path : charactor){
      path.useSampledPs();
    }
    endShape();
  }
}
