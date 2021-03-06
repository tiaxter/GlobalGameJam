import processing.video.*;
Movie firstVideo;  
Movie secondVideo;  

int moviePlaying;

class Menu extends Scene
{
  GlobalGameJam instance;

  Menu(float ratio) {
    super(ratio);
    moviePlaying = 0;
  }
  
  boolean init(PApplet instance) 
  {
    this.instance = (GlobalGameJam)instance; 
    firstVideo= new Movie(instance, "Video\\Transition.mp4")
    {
      @Override
      public void eosEvent()
      {
        super.eosEvent();
        firstVideoCompleted();
      }
    };

    secondVideo = new Movie(instance, "Video\\Transformation.mp4");
    reset();
    return true;
  }

  void reset()
  {
    moviePlaying = 0;
    firstVideo.play();
    moviePlaying = 1;

  }

  void firstVideoCompleted()
  {
    firstVideo.stop();
    secondVideo.loop();
    moviePlaying = 2;
  }
  
  
  void draw(){

    background(0);
    
    pushMatrix();
    //scale(ratio);
    translate(((float)instance.width - Constants.VIDEO_W) / 2.0, (((float)instance.height - Constants.VIDEO_H)/ 2.0));

    if (moviePlaying == 1)
    {
      if (firstVideo.available())
        firstVideo.read();
      image(firstVideo, 0, 0);
    }
    else if (moviePlaying == 2)
    {
      if (secondVideo.available())
        secondVideo.read();
      image(secondVideo, 0, 0);
    }
    
    text("THE PLACE\nWHERE I BELONG", 50, 50);
    
    text("PREMI UN TASTO PER INIZIARE", 100, Constants.VIDEO_H - 100);

    popMatrix(); 

    try {
      
      if (instance.controller.Apressed() || 
          instance.controller.Bpressed() || 
          instance.controller.Xpressed() || 
          instance.controller.Ypressed() || 
          instance.controller.StartPressed() ||
          instance.controller.BackPressed() || 
          instance.controller.LBpressed() ||
          instance.controller.RBpressed())
          {
              keyPressed();
              keyReleased();
          }
    }
    catch(Exception e){}
  }


  void endTransition()
  {
  }

  void keyPressed()
  {
    secondVideo.stop();
    firstVideo.stop();
  }

  void keyReleased(){
    moviePlaying = 0;
    instance.transition(Constants.GAME_GROUNDFLOOR);

  }


}