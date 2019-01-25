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





static int DESIGN_W = 1920;
static int DESIGN_H = 1080;
float ratio = 0.0f;
PImage img;
ControlIO control;
ControlDevice stick;
float px, py;
boolean trailOn;

public void setup()
{
    control = ControlIO.getInstance(this);
    // Find a device that matches the configuration file
    stick = control.getMatchedDevice("xb360");
    //fullScreen();
    
    ratio = min((float)this.width / this.DESIGN_W, (float )this.height / this.DESIGN_H);
    print(ratio);
    img = loadImage("sfondo.jpg");
}

public void draw()
{
    //print(stick.getSlider("LeftAnalogX").getValue());
    //print(stick.getSlider("LeftAnalogY").getValue());
    //print(stick.getSlider("RightAnalogX").getValue());
    //print(stick.getSlider("RightAnalogY").getValue());
    if(stick.getButton("Red").pressed()){
      System.exit(-1);
    }
    if(stick.getButton("Green").pressed()){
      System.exit(-1);
    }
    if(stick.getButton("Yellow").pressed()){
      System.exit(-1);
    }
    if(stick.getButton("Blue").pressed()){
      System.exit(-1);
    }
    if(stick.getButton("Start").pressed()){
      System.exit(-1);
    }
    if(stick.getButton("Back").pressed()){
      System.exit(-1);
    }
    scale(ratio);
    image(img,0,0);
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
