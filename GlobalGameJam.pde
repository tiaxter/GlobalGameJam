int DESIGN_W = 1920;
int DESIGN_H = 1080;

float ratio = 0.0;
PImage img;
Controller controller;
ControlIO control;



// camera_x: offset dove lo sfondo inizia
// camera_y: offset dove lo sfondo inizia

int camera_x = 0;
int camera_y = 0;

void setup()
{
    //fullScreen();

    control = ControlIO.getInstance(this);
    controller = new Controller(control);
    if (controller.stick == null) {
      controller = null;
      // End the program NOW!
    }
    size(500,500);
    ratio = min((float)this.width / this.DESIGN_W, (float )this.height / this.DESIGN_H);
    img = loadImage("Level 1 Big Base.png");
}

void draw()
{
    try{
      if(controller.BackPressed()){
        System.exit(-1);
      }
    }catch(Exception e){
      print(e);
    }
    background(0);
    ratio = min((float)this.width / this.DESIGN_W, (float )this.height / this.DESIGN_H);
    if (ratio < 1.0)
    {
        scale(ratio);
        translate(((float)width - this.DESIGN_W * ratio) / 2.0, ((float)height - this.DESIGN_H * ratio / 2.0));
    }

    image(img,-camera_x, -camera_y);
    //Player.animation.display();
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
    //
  }
}
