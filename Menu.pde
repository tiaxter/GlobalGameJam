class Menu extends Scene
{
  GlobalGameJam instance;

  Menu(float ratio) {super(ratio);}
  boolean init(PApplet instance) { this.instance = (GlobalGameJam)instance; return true;}
  void draw(){


    text("WHAT A LAME MENU", 100, 100);

  }
  void keyPressed()
  {


  }

  void keyReleased(){
    println("Starting transition...");
    
    instance.transition(Constants.GAME_SCENE);

  }


}