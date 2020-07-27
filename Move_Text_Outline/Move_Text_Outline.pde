float noiseS = 500;//noise scale
float noiseP = 0.1;//noise power
ArrayList<ArrayList<Path>> charactors;

void setup(){
  size(500, 500);
  textAlign(CENTER, CENTER);
  charactors = genPath("Segoe UI", 100, "Example!", 50, height/2);
  
  
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
      path.useVertices();
    }
    endShape();
  }
}
