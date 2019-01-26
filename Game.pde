class Game extends Scene
{

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

PImage img;


Game(float ratio) { super(ratio); }

boolean init(PApplet instance)
{
    player = new Player("test", 1);
    control = ControlIO.getInstance(instance);
    controller = new Controller(control);
    img = loadImage("Level 1 Big Base.png");
    return (player != null && img != null);
}

void draw()
{

   try{
        setDirection(String.valueOf(controller.LeftAnalogX()), true);
        setDirection(String.valueOf(controller.LeftAnalogY()), false);
      }catch(Exception e){
      //print(e);

    }

    imageMode(CORNER);
    image(this.img,-camera_x, -camera_y);
    player.draw(camera_x, camera_y);


    if (controller1[DIR_LEFT] || controller2[DIR_LEFT])
      moveCamera(-5,0);

    if (controller1[DIR_RIGHT] || controller2[DIR_RIGHT])
      moveCamera(5,0);

    if (controller1[DIR_UP] || controller2[DIR_UP])
      moveCamera(0,-5);

    if (controller1[DIR_DOWN] || controller2[DIR_DOWN])
      moveCamera(0,5);

}


void setDirection(String dir, boolean x){
  float xoy;
  try{
    xoy = Float.valueOf(dir);
  }catch(Exception e){
    xoy = 0;
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

    print(camera_x);
    print("\n");
    print(player.x);
    print("\n");
    print(camera_y);
    print("\n");
    print(player.y);
    print("\n");

    player.move(delta_x, delta_y);

    if (player.x >= Constants.SCREEN_W / 2 && player.x < Constants.LEVEL_W - Constants.SCREEN_W / 2)
    {
        camera_x = camera_x + delta_x;
    }

    if (player.y >= Constants.SCREEN_H / 2 && player.y < Constants.LEVEL_H - Constants.SCREEN_H / 2)
    {
        camera_y = camera_y + delta_y;
    }


    print("=====\n");
    print(camera_x);
    print("\n");
    print(player.x);
    print("\n");
    print(camera_y);
    print("\n");
    print(player.y);
    print("\n");
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
}