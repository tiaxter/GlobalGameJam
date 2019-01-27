import java.lang.Math;

final int PLAYER_TIME_SLOT = 3000;

class Player{

  Animation animation_jonny;
  Animation animation_kenny;

  int direction;

  float x;
  float y;

  float time = 0;
  float delta_time = 0.0f;

  SoundFile steps_jonny[];
  SoundFile steps_kenny[];

  SoundFile currentStepSound;

  // Used to switch between the players
  boolean currentPlayer = true;

  Player(PApplet instance){
    animation_jonny = new Animation("Sprites\\Kenny\\P2_move", 5);
    animation_kenny = new Animation("Sprites\\Jonny\\P1_move", 5);

    loadSounds(instance);

    direction = Game.DIR_IDLE;
    animation_jonny.updateDirection(Game.DIR_IDLE);
    animation_kenny.updateDirection(Game.DIR_IDLE);
    time = millis();
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
        if (currentPlayer)
          currentStepSound = steps_jonny[rand_step];
        else 
          currentStepSound = steps_kenny[rand_step];
     
        currentStepSound.play();
      }
    }

  }

  void setPosition(int x, int y)
  {
    this.x = x;
    this.y = y;
  }

  boolean isActive(int currPlayer)
  {
    return (currPlayer == 1 && currentPlayer) || (currPlayer == 0 && !currentPlayer);

  }

  void setDirection(int dir) {
    
      direction = dir;

     if (currentPlayer)
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
    double timer = Math.round(((PLAYER_TIME_SLOT - delta_time) / 1000.0) * 10d) / 10d;

    fill(0,255);
    text(String.valueOf(timer), 54, 54);
    fill(255,255);
    text(String.valueOf(timer), 50, 50);
    delta_time += millis() - time;    
    
    updateStepSound();

    if (delta_time > PLAYER_TIME_SLOT)
    {
      currentPlayer = !currentPlayer;   
      setDirection(Game.DIR_IDLE);
      delta_time = 0.0f;   
    }
    time = millis();

    if (currentPlayer)
    {
      animation_jonny.display((this.x - camera_x), (this.y - camera_y));
    }
    else 
    {
      animation_kenny.display((this.x - camera_x), (this.y - camera_y));
    }
  }
}
