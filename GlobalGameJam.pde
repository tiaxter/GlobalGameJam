import java.awt.event.KeyEvent;
int DESIGN_W = 1920;
int DESIGN_H = 1080;

float ratio = 0.0;
PImage img;
Controller controller;
ControlIO control;
Player player;



// camera_x: offset dove lo sfondo inizia
// camera_y: offset dove lo sfondo inizia

int camera_x = 0;
int camera_y = 0;

void setup()
{
    //fullScreen();
    //player = new Player("PT_Shifty", 37);
    control = ControlIO.getInstance(this);
    controller = new Controller(control);
    size(500,500);
    ratio = min((float)this.width / this.DESIGN_W, (float )this.height / this.DESIGN_H);
    img = loadImage("Level 1 Big Base.png");
}

void draw()
{
    try{
        setDirection(String.valueOf(controller.LeftAnalogX()), true);
        setDirection(String.valueOf(controller.LeftAnalogY()), false);
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
    //player.animation.display();
}

void setDirection(String dir, boolean x){
  float xoy;
  try{
    xoy = Float.valueOf(dir);
  }catch(Exception e){
    xoy = 0;
  }
  if(dir.equals("DOWN") || xoy > 0.5 && !x){
    //DOWN
    //player.setDirection(1);
    println("DOWN");
  }else if(dir.equals("UP") || xoy < -0.5 && !x){
    //UP
    //player.setDirection(0);
    println("UP");
  }else if(dir.equals("LEFT") || xoy < -0.5  && x){
    //LEFT
    //player.setDirection(2);
    println("LEFT");
  }else if(dir.equals("RIGHT") || xoy > 0.5  && x){
    //LEFT
    //player.setDirection(3);
    println("RIGHT");
  }
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == DOWN){
      setDirection("DOWN", true);
    }else if (keyCode == RIGHT){
      setDirection("RIGHT", true);
    }else if (keyCode == UP){
      setDirection("UP", true);
    }else if (keyCode == LEFT){
      setDirection("LEFT", true);
    }
  }
}
