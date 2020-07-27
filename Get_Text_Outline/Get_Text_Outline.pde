void setup(){
  size(500, 500);
  ArrayList<ArrayList<Path>> charactors = getOutlines("Segoe UI", 50, "Example!", 10, 40);
  
  noStroke();
  for(ArrayList<Path> charactor : charactors){
    beginShape();println(charactor.size());
    for(Path path : charactor){
      path.useVertices();
    }
    endShape();
  }
}

void draw(){
  
}
