float ratio = 0.0;
PImage img;
Controller controller;
ControlIO control;
Player player;

// camera_x: offset dove lo sfondo inizia
// camera_y: offset dove lo sfondo inizia

int camera_x = 0;
int camera_y = 0;

static final int  DIR_UP = 0;
static final int  DIR_DOWN = 1;
static final int  DIR_LEFT = 2;
static final int  DIR_RIGHT = 3;

boolean controller1[] = {false, false, false, false};
boolean controller2[] = {false, false, false, false};

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


    if (controller1[DIR_LEFT] || controller2[DIR_LEFT])
      moveCamera(-5,0);

    if (controller1[DIR_RIGHT] || controller2[DIR_RIGHT])
      moveCamera(5,0);

    if (controller1[DIR_UP] || controller2[DIR_UP])
      moveCamera(0,-5);

    if (controller1[DIR_DOWN] || controller2[DIR_DOWN])
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
  println(xoy);
  println(x);

  if(x){
    println(xoy);
  }

  if(!x)
  {
    if(xoy > 0.5){
      controller1[DIR_DOWN] = true;
    }
    else
    {
      controller1[DIR_DOWN] = false;
    }

    if(xoy < -0.5)
    {
      controller1[DIR_UP] = true;
    }
    else
    {
      controller1[DIR_UP] = false;
    }
  }
  else
  {
    if(xoy < -0.5)
    {
      controller1[DIR_LEFT] = true;
    }
    else
    {
      controller1[DIR_LEFT] = false;
    }

    if(xoy > 0.5)
    {
      controller1[DIR_RIGHT] = true;
    }
    else
    {
      controller1[DIR_RIGHT] = false;
    }
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

    // print(camera_x);
    // print("\n");
    // print(delta_x);
    // print("\n");
    // print(camera_y);
    // print("\n");
    // print(delta_y);
    // print("\n");

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


    // print("=====\n");
    // print(camera_y);
    // print("\n");
    // print(camera_x);
    // print("\n");
}


void keyReleased()
{
  //if (key == CODED)
  {
    if (keyCode == DOWN)
    {
      controller2[DIR_DOWN] = false;
      print("DOWN released");
    }

    //else
     if (keyCode == RIGHT)
      controller2[DIR_RIGHT] = false;

    //else
     if (keyCode == UP)
      controller2[DIR_UP] = false;


    if (keyCode == LEFT)
      controller2[DIR_LEFT] = false;
    //
  }
}

void keyPressed(){

 if (key == CODED)
  {
    if (keyCode == DOWN)
    {
      controller2[DIR_DOWN] = true;
      print("DOWN pressed");
    }
    //else
     if (keyCode == RIGHT)
      controller2[DIR_RIGHT] = true;

    //else
     if (keyCode == UP)
      controller2[DIR_UP] = true;


    if (keyCode == LEFT)
      controller2[DIR_LEFT] = true;
  }
}
