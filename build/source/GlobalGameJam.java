import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.event.KeyEvent; 
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


int DESIGN_W = 1920;
int DESIGN_H = 1080;

float ratio = 0.0f;
PImage img;
Controller controller;
ControlIO control;
Player player;



// camera_x: offset dove lo sfondo inizia
// camera_y: offset dove lo sfondo inizia

int camera_x = 0;
int camera_y = 0;

public void setup()
{
    //fullScreen();
    //player = new Player("PT_Shifty", 37);
    control = ControlIO.getInstance(this);
    controller = new Controller(control);
    
    ratio = min((float)this.width / this.DESIGN_W, (float )this.height / this.DESIGN_H);
    img = loadImage("Level 1 Big Base.png");
}

public void draw()
{
    try{
        setDirection(String.valueOf(controller.LeftAnalogX()), true);
        setDirection(String.valueOf(controller.LeftAnalogY()), false);
      }catch(Exception e){
      print(e);
    }
    background(0);
    ratio = min((float)this.width / this.DESIGN_W, (float )this.height / this.DESIGN_H);
    if (ratio < 1.0f)
    {
        scale(ratio);
        translate(((float)width - this.DESIGN_W * ratio) / 2.0f, ((float)height - this.DESIGN_H * ratio / 2.0f));
    }

    image(img,-camera_x, -camera_y);
    //player.animation.display();
}

public void setDirection(String dir, boolean x){
  float xoy;
  try{
    xoy = Float.valueOf(dir);
  }catch(Exception e){
    xoy = 0;
  }
  if(dir.equals("DOWN") || xoy > 0.5f && !x){
    //DOWN
    //player.setDirection(1);
    println("DOWN");
  }else if(dir.equals("UP") || xoy < -0.5f && !x){
    //UP
    //player.setDirection(0);
    println("UP");
  }else if(dir.equals("LEFT") || xoy < -0.5f  && x){
    //LEFT
    //player.setDirection(2);
    println("LEFT");
  }else if(dir.equals("RIGHT") || xoy > 0.5f  && x){
    //LEFT
    //player.setDirection(3);
    println("RIGHT");
  }
}

public void keyPressed(){
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
// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int frame;
  int nframes;
  String prefissofile;

  Animation(String prefissofile, int nframes) {
    this.nframes = nframes;
    this.prefissofile = prefissofile;
    images = new PImage[nframes];
    updateDirection("up");
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

  Player(String prefissofile, int nframes){
    animation = new Animation(prefissofile, nframes);
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
