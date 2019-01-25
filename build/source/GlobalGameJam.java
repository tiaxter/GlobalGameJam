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

int DESIGN_W = 1920;
int DESIGN_H = 1080;

float ratio = 0.0f;
PImage img;
Controller controller;
ControlIO control;



// camera_x: offset dove lo sfondo inizia
// camera_y: offset dove lo sfondo inizia

int camera_x = 0;
int camera_y = 0;

public void setup()
{
    //fullScreen();

    control = ControlIO.getInstance(this);
    controller = new Controller(control);
    if (controller.stick == null) {
      controller = null;
      // End the program NOW!
    }
    
    ratio = min((float)this.width / this.DESIGN_W, (float )this.height / this.DESIGN_H);
    img = loadImage("Level 1 Big Base.png");
}

public void draw()
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
    if (ratio < 1.0f)
    {
        scale(ratio);
        translate(((float)width - this.DESIGN_W * ratio) / 2.0f, ((float)height - this.DESIGN_H * ratio / 2.0f));
    }

    image(img,-camera_x, -camera_y);
}

public void keyPressed(){
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
