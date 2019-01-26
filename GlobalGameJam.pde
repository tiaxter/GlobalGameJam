float ratio = 0.0;

Scene scenes[] = { null, null};

int currentScene;

void setup()
{
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

}

void draw()
{
    background(0xFF0000);
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    if (ratio < 1.0)
    {
        scale(ratio);
        translate(((float)width - Constants.SCREEN_W * ratio) / 2.0, ((float)height - Constants.SCREEN_H * ratio / 2.0));
    }

    scenes[currentScene].draw();

    //player.animation.display();
}


void keyReleased()
{
  scenes[currentScene].keyReleased();
}

void keyPressed()
{
  scenes[currentScene].keyPressed();
}



