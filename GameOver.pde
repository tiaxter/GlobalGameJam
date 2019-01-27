class GameOver extends Scene
{
  GlobalGameJam instance;

  GameOver(float ratio) {super(ratio);}
  boolean init(PApplet instance) { this.instance = (GlobalGameJam)instance; return true;}
  void draw(){
    background(0);

    if (instance.getLastWinner() == Constants.JONNY)
      text("JONNY E' RIUSCITO A RIMANERE A CASA!", 100, 100);
    else
      text("KENNY E' RIUSCITO A RAGGIUNGERE LA LIBERTA'!", 100, 100);
  
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