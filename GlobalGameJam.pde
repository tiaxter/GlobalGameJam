static int DESIGN_W = 1920;
static int DESIGN_H = 1080;
float ratio = 0.0;
PImage img;
Controller controller;
ControlIO control;

void setup()
{
    //fullScreen();
    control = ControlIO.getInstance(this);
    controller = new Controller(control);
    size(500,500);
    ratio = min((float)this.width / this.DESIGN_W, (float )this.height / this.DESIGN_H);
    print(ratio);
    img = loadImage("sfondo.jpg");
}

void draw()
{
    scale(ratio);
    image(img,0,0);
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == DOWN){
      //DOWN
    }else if (keyCode == RIGHT){
      //RIGHT
    }else if (keyCode == UP){
      //UP
    }else if (keyCode == LEFT){
      //LEFT
    }
  }
}
