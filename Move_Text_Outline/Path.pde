class Path{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  
  void update(){
    for(Vertex v : vertices){
      float angle = noise(v.data[0]/noiseS, v.data[1]/noiseS)*TWO_PI*8;
      v.data[0] += cos(angle)*noiseP;
      v.data[1] += sin(angle)*noiseP;
      if(v.data.length>=4){
        angle = noise(v.data[2]/noiseS, v.data[3]/noiseS)*TWO_PI*8;
        v.data[2] += cos(angle)*noiseP;
        v.data[3] += sin(angle)*noiseP;
      }
      if(v.data.length>=6){
        angle = noise(v.data[4]/noiseS, v.data[4]/noiseS)*TWO_PI*8;
        v.data[4] += cos(angle)*noiseP;
        v.data[5] += sin(angle)*noiseP;
      }
    }
  }
  
  void useVertices(){
    for(Vertex v : vertices){
      //ellipse(v.data[0], v.data[1], 10, 10);
      switch(v.data.length){
        case 2:
          vertex(v.data[0], v.data[1]);
          break;
        case 4:
          quadraticVertex(v.data[0], v.data[1], v.data[2], v.data[3]);
          break;
        case 6:
          bezierVertex(v.data[0], v.data[1], v.data[2], v.data[3], v.data[4], v.data[5]);
          break;
      }
    }
  }
  
  void addVertex(float ... x){
    vertices.add(new Vertex(x));
  }
}
