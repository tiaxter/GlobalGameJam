class Player{
  Animation animation_move;
  Animation animation_idle;
  float x;
  float y;

  PImage img;

  Player(String prefisso_file, int nframes){
    animation_move = new Animation("Sprites\\P1_move", 6);
    img = loadImage("icon.png");
    x = 0;
    y = 0;
  }

  void setDirection(int dir) {
    switch(dir){
      case 0:
        animation_move.updateDirection("up");
        break;
      case 1:
        animation_move.updateDirection("down");
        break;
      case 2:
        animation_move.updateDirection("left");
        break;
      case 3:
        animation_move.updateDirection("right");
        break;
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

  if (x + delta_x >= 0 && x + delta_x < levelW - 128)
    x += delta_x;

  if (y + delta_y >= 0 && y + delta_y <  levelH - 128)
    y += delta_y;

    return new float[] {x, y};

}

  void draw(int camera_x, int camera_y)
  {
    if (img != null)
    {
      animation_move.display((this.x - camera_x), (this.y - camera_y));
      //image(img, (this.x - camera_x), (this.y - camera_y));
    }
  }
}
