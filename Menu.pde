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
    secondVideo.stop();
    firstVideo.stop();
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
    // println(moviePlaying);
    // if (moviePlaying == 1)
    // {
    //   image(firstVideo, 0, 0);
    // }
    // else if (moviePlaying == 2)
    // {
    //   image(secondVideo, 0, 0);
    // }
    
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
    
    text("WHAT A LAME MENU", 100, 100);
    
  }

  // void movieEvent(Movie m)
  // {
  //   m.read();
  // }
  
  void keyPressed()
  {


  }

  void keyReleased(){
    println("Starting transition...");
    
    instance.transition(Constants.GAME_GROUNDFLOOR);

  }


}