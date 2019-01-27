class Menu extends Scene
{
  GlobalGameJam instance;

  Menu(float ratio) {super(ratio);}
  boolean init(PApplet instance) { this.instance = (GlobalGameJam)instance; return true;}
  void draw(){

    background(0);
    text("WHAT A LAME MENU", 100, 100);

  }

  void keyPressed()
  {


  }

  void reset()
  {

  }

  void keyReleased(){
    println("Starting transition...");
    
    instance.transition(Constants.GAME_GROUNDFLOOR);

  }


}