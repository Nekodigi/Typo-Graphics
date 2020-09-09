import java.awt.Font;
import java.awt.font.FontRenderContext;
import java.awt.image.BufferedImage;
import java.awt.geom.PathIterator;

ArrayList<ArrayList<Path>> genPath(String name, int size, String text, float x, float y){
  ArrayList<ArrayList<Path>> charactors = new ArrayList<ArrayList<Path>>();
  float coords[] = new float[6];//buffer
  float xoff = 0;
  textFont(createFont(name, size));
  textSize(size);
  for(char c : text.toCharArray()){
    PathIterator iter = createOutline(name, size, String.valueOf(c), x, y);
    ArrayList<Path> paths = new ArrayList<Path>();//element of char
    Path path = new Path();
    while (!iter.isDone()) {
      int type = iter.currentSegment(coords);
      coords[0] += xoff;
      coords[2] += xoff;
      coords[4] += xoff;
      switch (type) {
        case PathIterator.SEG_MOVETO:
          path = new Path();//beginPath
          path.addVertex(coords[0], coords[1]);
          break;
        case PathIterator.SEG_LINETO:
          path.addVertex(coords[0], coords[1]);
          break;
        case PathIterator.SEG_CLOSE:
          paths.add(path);//end path
          path = new Path();//refresh buffer
          break;
        case PathIterator.SEG_QUADTO:
          path.addVertex(coords[0], coords[1], coords[2], coords[3]);
          break;
        case PathIterator.SEG_CUBICTO:
          path.addVertex(coords[0], coords[1], coords[2], coords[3], coords[4], coords[5]);
          break;
        default:
          throw new RuntimeException("should not reach here");
      }
      iter.next();
    }
    charactors.add(paths);
    xoff += textWidth(c);
  }
  return charactors;
}

PathIterator createOutline(String name, int size, String text, float x, float y) {
  FontRenderContext frc = 
    new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB)
      .createGraphics()
      .getFontRenderContext();
      
  Font font = new Font(name, Font.PLAIN, size);
  
  PathIterator iter = font.createGlyphVector(frc, text)
    .getOutline(x, y)
    .getPathIterator(null);

  return iter;
}
