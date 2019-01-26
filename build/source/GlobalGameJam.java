import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.gamecontrolplus.gui.*; 
import org.gamecontrolplus.*; 
import net.java.games.input.*; 

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

public void setup()
{
    //fullScreen();
    player = new Player("test", 1);
    control = ControlIO.getInstance(this);
    controller = new Controller(control);
    
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    img = loadImage("Level 1 Big Base.png");

}

public void draw()
{
    try{
        setDirection(String.valueOf(controller.LeftAnalogX()), true);
        setDirection(String.valueOf(controller.LeftAnalogY()), false);
      }catch(Exception e){
      //print(e);
    }
    background(0);
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    if (ratio < 1.0f)
    {
        scale(ratio);
        translate(((float)width - Constants.SCREEN_W * ratio) / 2.0f, ((float)height - Constants.SCREEN_H * ratio / 2.0f));
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

public void setDirection(String dir, boolean x){
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

public void moveCamera(int delta_x, int delta_y)
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


public void keyReleased()
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

public void keyPressed(){

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
  
static final int SCREEN_W = 1920;
static final int SCREEN_H = 1080;


static final int LEVEL_W = 1920*2;
static final int LEVEL_H = 1080*2;

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

  public void move(int delta_x, int delta_y)
  {
    if (this.x + delta_x > 0 && this.x + delta_x <  Constants.LEVEL_W)
      this.x += delta_x;
    if (this.y + delta_y > 0 && this.y + delta_y <  Constants.LEVEL_H)
      this.y += delta_y;
  }

  public void draw(int camera_x, int camera_y)
  {
    if (img != null)
      image(img, this.x - camera_x, this.y - camera_y);
  }
}
  public void settings() {  size(500,500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GlobalGameJam" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
