class GameOver extends Scene
{
  GlobalGameJam instance;

  GameOver(float ratio) {super(ratio);}
  boolean init(PApplet instance) { this.instance = (GlobalGameJam)instance; return true;}
  void draw(){
    background(0);

    text("WHAT A LAME GAME OVER", 100, 100);

  }
  void keyPressed()
  {


  }
  
  void endTransition()
  {}
  
  void reset()
  {

  }

  void keyReleased(){    
    instance.transition(Constants.MENU_SCENE);
  }


}