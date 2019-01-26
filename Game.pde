import ptmx.*;

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

Ptmx map;

Game(float ratio) { super(ratio); }

boolean init(PApplet instance)  
{
    player = new Player("test", 1);
    control = ControlIO.getInstance(instance);
    controller = new Controller(control);
    map = new Ptmx(instance, "floor1.tmx");
    return (player != null && map != null);
}

int getPlayerTileX()
{
  return (int)(player.x / map.getTileSize().x);
}

int getPlayerTileY()
{
  return (int)(player.y / map.getTileSize().y);
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

    map.draw(camera_x, camera_y);
    player.draw(camera_x, camera_y);


    // textSize(8);
    // for(int nx = 0; nx < map.getMapSize().x; nx++)
    // for(int ny = 0; ny < map.getMapSize().y; ny++){
    // float px = map.mapToCam(nx, ny).x;
    // float py = map.mapToCam(nx, ny).y;
    // ellipse(px, py, 2, 2);
    // text(nx + "," + ny, px, py);
    // }


    if (controller1[DIR_LEFT] || controller2[DIR_LEFT])
      moveCamera((int)(-5.0 * ratio),0);

    if (controller1[DIR_RIGHT] || controller2[DIR_RIGHT])
      moveCamera((int)(5.0 * ratio),0);

    if (controller1[DIR_UP] || controller2[DIR_UP])
      moveCamera(0,(int)(-5.0 * ratio));

    if (controller1[DIR_DOWN] || controller2[DIR_DOWN])
      moveCamera(0, (int)(5.0 * ratio));

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


int getTileMapWidth()
{
  return (int)(map.getTileSize().x * map.getMapSize().x);
}

int getTileMapHeight()
{
  return (int)(map.getTileSize().y * map.getMapSize().y);
}


void moveCamera(int delta_x, int delta_y)
{

    player.move(delta_x, delta_y);

    if (player.x >= Constants.SCREEN_W / 2 && player.x < getTileMapWidth() - Constants.SCREEN_W / 2)
    {
        camera_x = camera_x + delta_x;
    }

    if (player.y >= Constants.SCREEN_H / 2 && player.y < getTileMapHeight() - Constants.SCREEN_H / 2)
    {
        camera_y = camera_y + delta_y;
    }
}


void keyReleased()
{
  //if (key == CODED)
  {
    if (keyCode == DOWN)
    {
      controller2[DIR_DOWN] = false;
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