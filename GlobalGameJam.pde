
import processing.sound.*;
float ratio = 0.0;

Scene scenes[] = { null, null, null, null};
SoundFile music;

final int FADEOUT_TIME_MS = 1000;

int currentScene;
int target_scene;

boolean fade = false;
float screen_x = 0.0;


PFont myfont;

void setup()
{
    background(0);

    myfont = createFont("Pixelmania.ttf", 32);
    textFont(myfont);

    fullScreen();
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);

    scenes[Constants.MENU_SCENE] = new Menu(ratio);
    scenes[Constants.GAME_TOPFLOOR] = new Game(ratio, "Levels/Placeholder/What.tmx", Constants.GAME_TOPFLOOR);
    scenes[Constants.GAME_GROUNDFLOOR] = new Game(ratio, "Levels/PianoT/PianoT.tmx", Constants.GAME_GROUNDFLOOR);
    scenes[Constants.GAME_OVER] = new GameOver(ratio);

    if (!(scenes[Constants.MENU_SCENE].init(this) && 
          scenes[Constants.GAME_GROUNDFLOOR].init(this) && 
          scenes[Constants.GAME_TOPFLOOR].init(this) &&
          scenes[Constants.GAME_OVER].init(this)))
    {
      print("Error initializing scenes!");
      System.exit(-1);
    }
    currentScene = Constants.MENU_SCENE;

    music = new SoundFile(this, "Sounds/RumoreBiancoCasa.mp3");
    music.amp(0.5);
    music.loop();

}

void transition(int nextScene)
{
  if (!fade)
  {
    fade = true;
    target_scene = nextScene;
    screen_x = - Constants.SCREEN_W;

  }
}


void draw()
{


    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    if (ratio < 1.0)
    {
        //scale(3.0);
        //translate(((float)width - Constants.SCREEN_W * ratio) / 2.0, ((float)height - Constants.SCREEN_H * ratio / 2.0));
    }

    fill(255,255);
    scenes[currentScene].draw();

    if (fade)
    {
      screen_x += 40.0;
      fill(50,255);
      rect(screen_x, 0, width, height);

      if (screen_x > 0)
      {
        currentScene = target_scene;
        scenes[currentScene].reset();
      }

      if (screen_x > Constants.SCREEN_W)
      {
        fade = false;
      }

    }

}


void keyReleased()
{
  scenes[currentScene].keyReleased();
}

void keyPressed()
{
  scenes[currentScene].keyPressed();
}
