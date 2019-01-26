float ratio = 0.0;

Scene scenes[] = { null, null, null};

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
    //size(1024,540);
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);

    scenes[Constants.MENU_SCENE] = new Menu(ratio);
    scenes[Constants.GAME_TOPFLOOR] = new Game(ratio, "Levels/Placeholder/What.tmx");
    scenes[Constants.GAME_GROUNDFLOOR] = new Game(ratio, "Levels/PianoT/PianoT.tmx");

    if (!(scenes[Constants.MENU_SCENE].init(this) && scenes[Constants.GAME_GROUNDFLOOR].init(this) && scenes[Constants.GAME_TOPFLOOR].init(this)))
    {
      print("Error initializing scenes!");
      System.exit(-1);
    }
    currentScene = Constants.MENU_SCENE;

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

    scenes[currentScene].draw();

    if (fade)
    {
      screen_x += 50.0;
      fill(50,255);
      rect(screen_x, 0, width, height);

      if (screen_x > 0)
      {
        currentScene = target_scene;
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
