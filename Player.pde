import java.lang.Math;

int PLAYER_TIME_SLOT[] = { Constants.DEFAULT_TIMER, Constants.DEFAULT_TIMER };

class Player{

  Animation animation_jonny;
  Animation animation_kenny;

  int direction;
  boolean paused;

  float x;
  float y;

  float time = 0;
  float delta_time = 0.0f;

  SoundFile steps_jonny[];
  SoundFile steps_kenny[];

  SoundFile currentStepSound;

  // Used to switch between the players
  int currentPlayer = Constants.JONNY;

  Player(PApplet instance){
    animation_kenny = new Animation("Sprites\\Kenny\\P2_move", 5);
    animation_jonny = new Animation("Sprites\\Jonny\\P1_move", 5);

    loadSounds(instance);

    direction = Game.DIR_IDLE;
    animation_jonny.updateDirection(Game.DIR_IDLE);
    animation_kenny.updateDirection(Game.DIR_IDLE);
    time = millis();
    paused = false;
  }

  void resetTimers()
  {
    PLAYER_TIME_SLOT[0] = PLAYER_TIME_SLOT[1] = Constants.DEFAULT_TIMER;
  }

  void loadSounds(PApplet instance)
  {
      steps_jonny = new SoundFile[4];
      steps_kenny = new SoundFile[4];

      steps_jonny[0] = new SoundFile(instance, "Sounds\\passi_bambino_4.wav");
      steps_jonny[1] = new SoundFile(instance, "Sounds\\passi_bambino_3_01.wav");
      steps_jonny[2] = new SoundFile(instance, "Sounds\\passi_bambino_2.wav");
      steps_jonny[3] = new SoundFile(instance, "Sounds\\passi_bambino_1.wav");

      steps_kenny[0] = new SoundFile(instance, "Sounds\\passi_bambino_distorto_4.wav");
      steps_kenny[1] = new SoundFile(instance, "Sounds\\passi_bambino_distorto_3.wav");
      steps_kenny[2] = new SoundFile(instance, "Sounds\\passi_bambino_distorto_2.wav");
      steps_kenny[3] = new SoundFile(instance, "Sounds\\passi_bambino_distorto_1.wav");
  }

  void updateStepSound()
  {
    if (direction != Game.DIR_IDLE)
    {
      if ((currentStepSound != null && !currentStepSound.isPlaying()) || currentStepSound == null)
      {
        int rand_step = (int)(Math.random() * 10) % 4;
        if (currentPlayer == Constants.JONNY)
          currentStepSound = steps_jonny[rand_step];
        else 
          currentStepSound = steps_kenny[rand_step];
     
        currentStepSound.play();
      }
    }

  }

  void setPaused(boolean paused)
  {
    this.paused = paused;
    if(!paused)
    {
      time = millis();
    }
  }

  void setPosition(int x, int y)
  {
    this.x = x;
    this.y = y;
  }

  boolean isActive(int currPlayer)
  {
    return (currPlayer == currentPlayer);

  }

  void powerUp(int currentPLayer)
  {
    PLAYER_TIME_SLOT[currentPlayer] += 1000;
  }

  void setDirection(int dir) {
    
      if (paused)
        return;

      direction = dir;

     if (currentPlayer ==  Constants.JONNY)
      {
        animation_jonny.updateDirection(dir);
      }
      else
      {
        animation_kenny.updateDirection(dir);
      }
  }

  void move(int delta_x, int delta_y, int levelW, int levelH)
  {
    if (this.x + delta_x >= 0 && this.x + delta_x < levelW  - Constants.PLAYER_WIDTH)
      this.x += delta_x;

    if (this.y + delta_y >= 0 && this.y + delta_y <  levelH - Constants.PLAYER_HEIGHT)
      this.y += delta_y;
  }

float[] simulateMove(int delta_x, int delta_y, int levelW, int levelH){
  float x = this.x;
  float y = this.y;

  if (x + delta_x >= 0 && x + delta_x < levelW - Constants.PLAYER_WIDTH)
    x += delta_x;

  if (y + delta_y >= 0 && y + delta_y <  levelH - Constants.PLAYER_HEIGHT)
    y += delta_y;
  
  return new float[] {x, y};

}

  void draw(int camera_x, int camera_y)
  {
    double timer = Math.round(((PLAYER_TIME_SLOT[currentPlayer] - delta_time) / 1000.0) * 10d) / 10d;

    if(!paused)
    {
      fill(0,255);
      text(String.valueOf(timer), 25, 25);
      fill(255,255);
      text(String.valueOf(timer), 25, 25);
    
      delta_time += millis() - time;    
      updateStepSound();
    }

    if (delta_time > PLAYER_TIME_SLOT[currentPlayer])
    {
      if(currentPlayer == Constants.JONNY)
        currentPlayer = Constants.KENNY;
      else
       currentPlayer = Constants.JONNY;

      setDirection(Game.DIR_IDLE);
      delta_time = 0.0f;   
    }
    time = millis();

    if (currentPlayer == Constants.JONNY)
    {
      animation_jonny.display((this.x - camera_x), (this.y - camera_y));
    }
    else 
    {
      animation_kenny.display((this.x - camera_x), (this.y - camera_y));
    }
  }
}
