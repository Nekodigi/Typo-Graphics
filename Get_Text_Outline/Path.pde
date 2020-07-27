class Path{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  
  void useVertices(){
    for(Vertex v : vertices){
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
