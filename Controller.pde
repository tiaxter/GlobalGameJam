import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

 class Controller{
  ControlDevice stick;
  ControlIO control;

  Controller(ControlIO control){
    this.control = control;
    stick = control.getMatchedDeviceSilent("xb360");
  }

  boolean Apressed(){
    return stick.getButton("Green").pressed();
  }

  boolean Xpressed(){
    return stick.getButton("Blue").pressed();
  }

   boolean Ypressed(){
    return stick.getButton("Yellow").pressed();
  }

   boolean Bpressed(){
    return stick.getButton("Red").pressed();
  }

   boolean LBpressed(){
    return stick.getButton("LB").pressed();
  }

   boolean RBpressed(){
    return stick.getButton("RB").pressed();
  }

   boolean BackPressed(){
    return stick.getButton("Back").pressed();
  }

   boolean StartPressed(){
    return stick.getButton("Start").pressed();
  }

   float LeftAnalogX(){
    return stick.getSlider("LeftAnalogX").getValue();
  }

   float LeftAnalogY(){
    return stick.getSlider("LeftAnalogY").getValue();
  }

   float RightAnalogX(){
    return stick.getSlider("RightAnalogX").getValue();
  }

   float RightAnalogY(){
    return stick.getSlider("RightAnalogY").getValue();
  }

}
