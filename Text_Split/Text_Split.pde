float noiseS = 100;
float noiseP = 1;

Sentence sentence;

void setup(){
  size(500, 500);
  sentence = new Sentence("Nekodigi!?", width/2, height/2, 100);
}

void draw(){
  background(0);
  sentence.update();
  sentence.show();
}

class Sentence{
  PVector pos;
  float textS;
  String text;
  ArrayList<CharObj> chars = new ArrayList<CharObj>();
  
  Sentence(String text, float x, float y, float textS){//origin center, center by myself to make thing easier
    this.text = text;
    this.textS = textS;
    textSize(textS);
    pos = new PVector(x-textWidth(text)/2, y+textS/2);
    splitText();
  }
  
  void splitText(){
    chars = new ArrayList<CharObj>();
    float xoff = 0;
    textSize(textS);
    for(int i=0; i<text.length(); i++){
      char c = text.charAt(i);
      chars.add(new CharObj(pos.x + xoff, pos.y, c));
      xoff += textWidth(c);
    }
  }
  
  void update(){
    for(CharObj cha : chars){
      cha.update();
    }
  }
  
  void show(){
    //textSize(textS);
    //text(text, pos.x, pos.y);
    for(CharObj cha : chars){
      cha.show();
    }
  }
}

class CharObj{
  PVector pos;
  char cha;
  
  CharObj(float x, float y, char cha){
    this.pos = new PVector(x, y);
    this.cha = cha;
  }
  
  void update(){
    float angle = noise(pos.x/noiseS, pos.y/noiseS)*TWO_PI*8;
    pos.add(PVector.fromAngle(angle).mult(noiseP));
  }
  
  void show(){
    text(cha, pos.x, pos.y);
  }
}
