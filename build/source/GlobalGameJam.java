import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.gamecontrolplus.gui.*; 
import org.gamecontrolplus.*; 
import net.java.games.input.*; 
import ptmx.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GlobalGameJam extends PApplet {

float ratio = 0.0f;

Scene scenes[] = { null, null};

int currentScene;

public void setup()
{
    
    //size(1024,540);
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);

    scenes[Constants.MENU_SCENE] = new Menu(ratio);
    scenes[Constants.GAME_SCENE] = new Game(ratio);
    
    if (!(scenes[Constants.MENU_SCENE].init(this) && scenes[Constants.GAME_SCENE].init(this)))
    {
      print("Error initializing scenes!");
      System.exit(-1);
    }
    currentScene = Constants.GAME_SCENE;

}

public void draw()
{
    background(0xFF0000);
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    if (ratio < 1.0f)
    {
        scale(ratio);
        //translate(((float)width - Constants.SCREEN_W * ratio) / 2.0, ((float)height - Constants.SCREEN_H * ratio / 2.0));
    }

    scenes[currentScene].draw();
}


public void keyReleased()
{
  scenes[currentScene].keyReleased();
}

public void keyPressed()
{
  scenes[currentScene].keyPressed();
}



// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int nframes;
  String prefissofile;
  int frame = 0;
  int imageCount = 1;
  int xpos, ypos;
  
  Animation(String prefisso, int nframes) {
    this.nframes = nframes;
    this.prefissofile = prefissofile;
    this.images = new PImage[nframes];
  }

  public void updateDirection(String direction){
    for (int i = 0; i < nframes; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = prefissofile + "_" + direction + "_" + i + ".png";
      //String filename = prefissofile + "_" + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  public void display() {
    frame = (frame+1) % nframes;
    image(images[frame], 0, 0);
  }

}

class Constants{
  
static final int SCREEN_W = 2048;
static final int SCREEN_H = 1080;


static final int LEVEL_W = 2048*2;
static final int LEVEL_H = 1080*2;


static final int MENU_SCENE = 0;
static final int GAME_SCENE = 1;

};




 class Controller{
  ControlDevice stick;
  ControlIO control;

  Controller(ControlIO control){
    this.control = control;
    stick = control.getMatchedDeviceSilent("xb360");
  }

  public boolean Apressed(){
    return stick.getButton("Green").pressed();
  }

  public boolean Xpressed(){
    return stick.getButton("Blue").pressed();
  }

   public boolean Ypressed(){
    return stick.getButton("Yellow").pressed();
  }

   public boolean Bpressed(){
    return stick.getButton("Red").pressed();
  }

   public boolean LBpressed(){
    return stick.getButton("LB").pressed();
  }

   public boolean RBpressed(){
    return stick.getButton("RB").pressed();
  }

   public boolean BackPressed(){
    return stick.getButton("Back").pressed();
  }

   public boolean StartPressed(){
    return stick.getButton("Back").pressed();
  }

   public float LeftAnalogX(){
    return stick.getSlider("LeftAnalogX").getValue();
  }

   public float LeftAnalogY(){
    return stick.getSlider("LeftAnalogY").getValue();
  }

   public float RightAnalogX(){
    return stick.getSlider("RightAnalogX").getValue();
  }

   public float RightAnalogY(){
    return stick.getSlider("RightAnalogY").getValue();
  }

}


class Game extends Scene
{

Controller controller;
ControlIO control;
Player player;
int walkableLayerIndex;

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

public boolean init(PApplet instance)
{
    player = new Player("test", 1);
    control = ControlIO.getInstance(instance);
    controller = new Controller(control);
    map = new Ptmx(instance, "floor1.tmx");
    walkableLayerIndex = walkableLayer();
    return (player != null && map != null);
}

public int walkableLayer(){
  int layerindex = 0;
  int maplayer[];
  do{
    layerindex++;
    maplayer = map.getData(layerindex);
  }while(maplayer != null && !maplayer.equals("Walkable"));
  for(int x=0; x<10; x++){
    for(int y=0; y<10;y++){
      print(map.getTileIndex(layerindex-1, x, y));
    }
    println("\n");
  }
  return layerindex-1;
}

public boolean isWalkable(int x, int y){
  println(walkableLayerIndex);
  println(x);
  println(y);
  println(map.getTileIndex(walkableLayerIndex, x, y));
  if(map.getTileIndex(walkableLayerIndex, y, x) >= 0){
    print("CI PUOI CAMMINARE");
    return true;
  }
  return false;
}

public int getPlayerTileX()
{
  return (int)(player.x / map.getTileSize().x);
}

public int getPlayerTileY()
{
  return (int)(player.y / map.getTileSize().y);
}

public void draw()
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
      moveCamera((int)(-5.0f * ratio),0);

    if (controller1[DIR_RIGHT] || controller2[DIR_RIGHT])
      moveCamera((int)(5.0f * ratio),0);

    if (controller1[DIR_UP] || controller2[DIR_UP])
      moveCamera(0,(int)(-5.0f * ratio));

    if (controller1[DIR_DOWN] || controller2[DIR_DOWN])
      moveCamera(0, (int)(5.0f * ratio));

}

public void setDirection(String dir, boolean x){
  float xoy;
  try{
    xoy = Float.valueOf(dir);
  }catch(Exception e){
    xoy = 0;
  }

  if(!x)
  {
    if(xoy > 0.5f){
      controller1[DIR_DOWN] = true;
    }
    else
    {
      controller1[DIR_DOWN] = false;
    }

    if(xoy < -0.5f)
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
    if(xoy < -0.5f)
    {
      controller1[DIR_LEFT] = true;
    }
    else
    {
      controller1[DIR_LEFT] = false;
    }

    if(xoy > 0.5f)
    {
      controller1[DIR_RIGHT] = true;
    }
    else
    {
      controller1[DIR_RIGHT] = false;
    }
}
}


public int getTileMapWidth()
{
  return (int)(map.getTileSize().x * map.getMapSize().x);
}

public int getTileMapHeight()
{
  return (int)(map.getTileSize().y * map.getMapSize().y);
}


public void moveCamera(int delta_x, int delta_y)
{
    float xy[] = player.simulateMove(delta_x, delta_y, getTileMapWidth(), getTileMapHeight());
    if(isWalkable((int)(xy[0]/map.getTileSize().x), (int)(xy[1]/map.getTileSize().y))){
      player.move(delta_x, delta_y, getTileMapWidth(), getTileMapHeight());

      if (player.x >= Constants.SCREEN_W / 2 && player.x < getTileMapWidth() - Constants.SCREEN_W / 2)
      {
          camera_x = camera_x + delta_x;
      }

      if (player.y >= Constants.SCREEN_H / 2 && player.y < getTileMapHeight() - Constants.SCREEN_H / 2)
      {
          camera_y = camera_y + delta_y;
      }
    }

}


public void keyReleased()
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

public void keyPressed(){

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
class Menu extends Scene
{
  Menu(float ratio) {super(ratio);}
  public boolean init(PApplet instance) { return true;}
  public void draw(){}
  public void keyPressed(){}
  public void keyReleased(){}


}
class Player{
  Animation animation;
  float x;
  float y;

  PImage img;

  Player(String prefisso_file, int nframes){
    //animation = new Animation(prefisso_file, nframes);
    img = loadImage("icon.png");
    x = 0;
    y = 0;
  }

  public void setDirection(int dir) {
    switch(dir){
      case 0:
        animation.updateDirection("up");
        break;
      case 1:
        animation.updateDirection("down");
        break;
      case 2:
        animation.updateDirection("left");
        break;
      case 3:
        animation.updateDirection("right");
        break;
    }
  }

  public void move(int delta_x, int delta_y, int levelW, int levelH)
  {
    if (this.x + delta_x >= 0 && this.x + delta_x < levelW - 128)
      this.x += delta_x;

    if (this.y + delta_y >= 0 && this.y + delta_y <  levelH - 128)
      this.y += delta_y;
  }

public float[] simulateMove(int delta_x, int delta_y, int levelW, int levelH){
  float x = this.x;
  float y = this.y;

  if (x + delta_x >= 0 && x + delta_x < levelW - 128)
    x += delta_x;

  if (y + delta_y >= 0 && y + delta_y <  levelH - 128)
    y += delta_y;

    return new float[] {x, y};

}

  public void draw(int camera_x, int camera_y)
  {
    if (img != null)
    {
      image(img, (this.x - camera_x), (this.y - camera_y));
    }
  }
}
class Scene
{
  float ratio = 0.0f;
  Scene(float r) {ratio = r;}
  public boolean init(PApplet instance) { return true;}
  public void draw() {}
  public void keyPressed(){}
  public void keyReleased(){}
};
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GlobalGameJam" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
