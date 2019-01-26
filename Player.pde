final int  PLAYER_WIDTH = 64;
final int  PLAYER_HEIGHT = 64;

import java.lang.Math;

final int PLAYER_TIME_SLOT = 5000;

class Player{
  Animation animation_jonny;
  Animation animation_kenny;

  float x;
  float y;

  float time = 0;
  float delta_time = 0.0f;

  // Used to switch between the players
  boolean currentPlayer = true;

  PImage img;

  Player(String prefisso_file, int nframes){
    animation_jonny = new Animation("Sprites\\Kenny\\P2_move", 5);
    animation_kenny = new Animation("Sprites\\Jonny\\P1_move", 5);
    img = loadImage("icon.png");
    x = 192*3;
    y = 192*3;
    setDirection(Game.DIR_IDLE);
    time = millis();
  }

  boolean isActive(int currPlayer)
  {
    return (currPlayer == 1 && currentPlayer) || (currPlayer == 0 && !currentPlayer);

  }

  void setDirection(int dir) {
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
    if (this.x + delta_x >= 0 && this.x + delta_x < levelW - 128)
      this.x += delta_x;

    if (this.y + delta_y >= 0 && this.y + delta_y <  levelH - 128)
      this.y += delta_y;
  }

float[] simulateMove(int delta_x, int delta_y, int levelW, int levelH){
  float x = this.x;
  float y = this.y;

  if (x + delta_x >= 0 && x + delta_x < levelW - 128 - PLAYER_WIDTH)
    x += delta_x;

  if (y + delta_y >= 0 && y + delta_y <  levelH - 128 - PLAYER_HEIGHT)
    y += delta_y;
  
  return new float[] {x, y};

}

  void draw(int camera_x, int camera_y)
  {
    double timer = Math.round(((PLAYER_TIME_SLOT - delta_time) / 1000.0) * 10d) / 10d;

    fill(255,255);
    text(String.valueOf(timer), 50, 50);
    delta_time += millis() - time;    
    
    if (delta_time > PLAYER_TIME_SLOT)
    {
      currentPlayer = !currentPlayer;   
      delta_time = 0.0f;   
    }
    time = millis();

    if (img != null)
    {
      if (currentPlayer)
      {
        animation_jonny.display((this.x - camera_x), (this.y - camera_y));
      }
      else 
      {
        animation_kenny.display((this.x - camera_x), (this.y - camera_y));
      }
      //image(img, (this.x - camera_x), (this.y - camera_y));
    }
  }
}
