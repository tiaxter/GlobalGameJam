import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice stick;

void setup( ) {
  control = ControlIO.getInstance(this);
  stick = control.getMatchedDevice("xb360");
}

boolean Apressed(){
  return stick.getButton("Green").pressed()
}

boolean Xpressed(){
  return stick.getButton("Blue").pressed()
}

boolean Ypressed(){
  return stick.getButton("Yellow").pressed()
}

boolean Bpressed(){
  return stick.getButton("Red").pressed()
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
