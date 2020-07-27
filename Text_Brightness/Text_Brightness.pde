import java.awt.Font;
PFont font;

void setup(){
size(500, 500);
  font = createFont("RubikMonoOne-Regular.ttf", 32);
  rect(0, 0, font.width('A')*100, 100);
  textFont(font);
  textAlign(LEFT, TOP);
  textSize(100);
  textLeading(100);
  text("aABC123\nDEF456", 0, 0);
  println(calcAvgBright(font, '1'));
  println(calcAvgBright(font, 'E'));
}
