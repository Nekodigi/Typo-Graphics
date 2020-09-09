class Path{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<PVector> sampledPs = new ArrayList<PVector>();//sampled evenly spaced points(polygon)
  
  PVector findNearestEdge(PVector p){//get nearest edge direction(x,y) and distance(z)
    float bestD = Float.POSITIVE_INFINITY;
    float bestDS = Float.POSITIVE_INFINITY;//support when determin distance
    PVector bestE = null;
    for(int i=0; i<vertices.size(); i++){
      PVector A = sampledPs.get(i);
      PVector B = sampledPs.get((i+1)%sampledPs.size());
      PVector dist = lineDist(p, A, B);
      if(dist.x <= bestD){
        if(abs(dist.x-bestD) == 0)if(dist.y <= bestDS){continue;}
        bestD = dist.x;
        bestDS = dist.y;
        bestE = PVector.sub(B, A);
      }
    }
    bestE.z = bestD;
    return bestE;
  }
  
  void useSampledPs(){
    for(PVector p : sampledPs){
      vertex(p.x, p.y);
    }
  }
  
  void sample(float spacing, boolean containsAnchor, boolean withoutLineSampling){
    //calculate evenly spaced points https://www.youtube.com/watch?v=d9k97JemYbM
    float resolution = 1;//higher valkue to get better points
    sampledPs = new ArrayList<PVector>();
    PVector previousP = vertices.get(0).anchor();
    sampledPs.add(previousP);//add start point
    for(int i = 1; i<vertices.size(); i++){
      Vertex vertex = vertices.get(i);
      switch(vertex.data.length){
        case 2://when line
          if(withoutLineSampling)previousP = linearSampling(previousP, vertex.anchor(), Float.POSITIVE_INFINITY);
          else previousP = linearSampling(previousP, vertex.anchor(), spacing);
          break;
        case 4://when 1 control point bezier(quadratic)
          Bezier bezier = new Bezier(previousP, vertex);
          float controlNetLength = PVector.dist(previousP, vertex.ctrl1()) + PVector.dist(vertex.ctrl1(), vertex.anchor());
          float estimatedLength = PVector.dist(previousP, vertex.anchor()) + controlNetLength/2;
          int divisions = int(estimatedLength*resolution*10);
          for(float t = 0; t < 1; t+= 1./divisions){
            PVector pointOnCurve = bezier.P(t);
            previousP = linearSampling(previousP, pointOnCurve, spacing);
          }
          break;
        case 6://when 2 control point bezier
          bezier = new Bezier(previousP, vertex);
          controlNetLength = PVector.dist(previousP, vertex.ctrl1()) + PVector.dist(vertex.ctrl1(), vertex.ctrl2()) + PVector.dist(vertex.ctrl2(), vertex.anchor());
          estimatedLength = PVector.dist(previousP, vertex.anchor()) + controlNetLength/2;
          divisions = int(estimatedLength*resolution*10);
          for(float t = 0; t < 1; t+= 1./divisions){
            PVector pointOnCurve = bezier.P(t);
            previousP = linearSampling(previousP, pointOnCurve, spacing);
          }
          break;        
      }
      if(containsAnchor){
        previousP = vertex.anchor();//use when want exact edge, but some points are collided
        sampledPs.add(previousP);
      }
    }
  }
  
  PVector linearSampling(PVector A, PVector B, float spacing){//sampled point on AB but, not contains A and B
    float dstSinceLastEvenPoint = PVector.dist(A, B);//add distance between two vertex
    while(dstSinceLastEvenPoint >= spacing){
      float overshootDst = dstSinceLastEvenPoint - spacing;
      PVector newEvenlySpacedPoint = PVector.add(B, PVector.sub(A, B).setMag(overshootDst));//liner interpolate
      sampledPs.add(newEvenlySpacedPoint);
      dstSinceLastEvenPoint = overshootDst;
      A = newEvenlySpacedPoint.copy();
    }
    return A;//return last sampled point
  }
  
  void addVertex(float ... x){
    vertices.add(new Vertex(x));
  }
}
