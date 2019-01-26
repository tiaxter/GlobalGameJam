float ratio = 0.0;

Scene scenes[] = { null, null};

final int FADEOUT_TIME_MS = 1000;

int currentScene;
int target_scene;

boolean fade = false;
float time;
float delta_time;
float fade_level = 0.0;
float fade_delta = 0.0;

void setup()
{
    background(0);
    fullScreen();
    //size(1024,540);
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);

    scenes[Constants.MENU_SCENE] = new Menu(ratio);
    scenes[Constants.GAME_SCENE] = new Game(ratio);

    if (!(scenes[Constants.MENU_SCENE].init(this) && scenes[Constants.GAME_SCENE].init(this)))
    {
      print("Error initializing scenes!");
      System.exit(-1);
    }
    currentScene = Constants.GAME_SCENE;
    
    time = millis();
}

void transition(int nextScene)
{
  if (!fade)
  {
    println("GGJ Starting transition...");
    fade = true;
    fade_level = 0.0;
    time = millis();
    fade_delta = 1.0 / FADEOUT_TIME_MS;
    target_scene = nextScene;
    delta_time = 0.0f;
  }
}


void draw()
{
    delta_time += millis() - time;    
    
    if (fade)
    {
      if (delta_time > FADEOUT_TIME_MS && fade)
      {
        fade = false;
        fade_delta = -1.0 / FADEOUT_TIME_MS;
        println("end of fade out" + fade_level);
        delta_time = 0.0f;
      }
    }
    else
    {
      if (delta_time > FADEOUT_TIME_MS)
      {
        currentScene = target_scene;    
        fade_level = 0;
        fade_delta = 0.0;
      }
    }
    fade_level = fade_level + fade_delta * delta_time;
    
    time = millis();

    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    if (ratio < 1.0)
    {
        //scale(3.0);
        //translate(((float)width - Constants.SCREEN_W * ratio) / 2.0, ((float)height - Constants.SCREEN_H * ratio / 2.0));
    }

    scenes[currentScene].draw();

    fill(0, fade_level);
    rect(0, 0, width, height);    

}


void keyReleased()
{
  scenes[currentScene].keyReleased();
}

void keyPressed()
{
  scenes[currentScene].keyPressed();
}
