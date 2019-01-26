float ratio = 0.0;
PImage img;
Controller controller;
ControlIO control;
Player player;

// camera_x: offset dove lo sfondo inizia
// camera_y: offset dove lo sfondo inizia

int camera_x = 0;
int camera_y = 0;

static final int  UP = 0;
static final int  DOWN = 1;
static final int  LEFT = 2;
static final int  RIGHT = 3;

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


    if (controller1[LEFT] || controller2[LEFT])
      moveCamera(-5,0);

    if (controller1[RIGHT] || controller2[RIGHT])
      moveCamera(5,0);

    if (controller1[UP] || controller2[UP])
      moveCamera(0,-5);

    if (controller1[DOWN] || controller2[DOWN])
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
  
  if(xoy > 0.5 && !x)
  {
    controller1[DOWN] = true;
  }
  else
  {
    controller1[DOWN] = false;
  }

  if(xoy < -0.5 && !x)
  {
    controller1[UP] = true;
  }
  else
  {
    controller1[UP] = false;
  }

  if(xoy < -0.5  && x)
  {
    controller1[LEFT] = true;
  }else
  {
    controller1[LEFT] = false;
  }

  if(xoy > 0.5  && x)
  {
    controller1[RIGHT] = true;
  }
  else
  {
    controller1[RIGHT] = false;
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
  if (key == CODED)
  {
    if (keyCode == DOWN)
      controller2[DOWN] = false;

    //else
     if (keyCode == RIGHT)
      controller2[RIGHT] = false;

    //else
     if (keyCode == UP)
      controller2[UP] = false;


    if (keyCode == LEFT)
      controller2[LEFT] = false;
    //
  }
}

void keyPressed(){

 if (key == CODED)
  {
    if (keyCode == DOWN)
      controller2[DOWN] = true;

    //else
     if (keyCode == RIGHT)
      controller2[RIGHT] = true;

    //else
     if (keyCode == UP)
      controller2[UP] = true;


    if (keyCode == LEFT)
      controller2[LEFT] = true; 
  }  
}
