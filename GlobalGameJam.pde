
float ratio = 0.0;
PImage img;
Controller controller;
ControlIO control;
Player player;

// camera_x: offset dove lo sfondo inizia
// camera_y: offset dove lo sfondo inizia

int camera_x = 0;
int camera_y = 0;

boolean left_pressed;
boolean right_pressed;
boolean up_pressed;
boolean down_pressed;

void setup()
{
    //fullScreen();
  player = new Player("test", 1);
    control = ControlIO.getInstance(this);
    controller = new Controller(control);
    size(500,500);
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    img = loadImage("Level 1 Big Base.png");
}

void draw()
{
    try{
        setDirection(String.valueOf(controller.LeftAnalogX()), true);
        setDirection(String.valueOf(controller.LeftAnalogY()), false);
      }catch(Exception e){
      //print(e);
    }
    background(0);
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    if (ratio < 1.0)
    {
        scale(ratio);
        translate(((float)width - Constants.SCREEN_W * ratio) / 2.0, ((float)height - Constants.SCREEN_H * ratio / 2.0));
    }

    image(img,-camera_x, -camera_y);
    player.draw(camera_x, camera_y);


    if (left_pressed)
      moveCamera(-5,0);

    if (right_pressed)
      moveCamera(5,0);

    if (up_pressed)
      moveCamera(0,-5);

    if (down_pressed)    
      moveCamera(0,5);
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


void moveCamera(int delta_x, int delta_y)
{

    // boolean move_only_player = true;
    // if (player.x + delta_x < this.SCREEN_W / 2 || player.x + delta_x > this.LEVEL_W - this.SCREEN_W / 2)
    // {
    //     player.move(delta_x, 0);
    // }

    // if (player.y + delta_y < this.SCREEN_H / 2 || player.y + delta_y > this.LEVEL_H - this.SCREEN_H / 2)
    // {
    //     player.move(0, delta_y);
    // }

    print(camera_x);
    print("\n");
    print(delta_x);
    print("\n");
    print(camera_y);
    print("\n");
    print(delta_y);
    print("\n");

    if (camera_x + delta_x >= 0 && camera_x + delta_x < Constants.LEVEL_W )
    {
        camera_x = camera_x + delta_x;
        player.move(delta_x, 0);
    }
    else
        player.move(delta_x, delta_y);

    if (camera_y + delta_y >=  0 && camera_y + delta_y < Constants.LEVEL_H)
    {
        camera_y = camera_y + delta_y;
        player.move(0, delta_y);
    }
    else
        player.move(delta_x, delta_y);
  
    
    print("=====\n");
    print(camera_y);
    print("\n");   
    print(camera_x);
    print("\n");
}


void keyReleased()
{
  //if (key == CODED)
   {
    if (keyCode == DOWN)
      down_pressed = false;

    //else
     if (keyCode == RIGHT)
      right_pressed = false;
     
    //else
     if (keyCode == UP)
      up_pressed = false;

    if (keyCode == LEFT)
      left_pressed = false;
    //
  }
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == DOWN)
      down_pressed = true;

    //else
     if (keyCode == RIGHT)
      right_pressed = true;
     
    //else
     if (keyCode == UP)
      up_pressed = true;

    if (keyCode == LEFT)
      left_pressed = true;
    //
  }
}
