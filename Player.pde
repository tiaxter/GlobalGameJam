class Player{
  Animation animation;
  float x;
  float y;

  PImage img;

  Player(String prefisso_file, int nframes){
    //animation = new Animation(prefisso_file, nframes);
    img = loadImage("icon.png");
    x = 0;
    y = 0;
  }

  void setDirection(int dir) {
    switch(dir){
      case 0:
        animation.updateDirection("up");
        break;
      case 1:
        animation.updateDirection("down");
        break;
      case 2:
        animation.updateDirection("left");
        break;
      case 3:
        animation.updateDirection("right");
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

  void draw(int camera_x, int camera_y)
  {
    if (img != null)
    {
      image(img, (this.x - camera_x), (this.y - camera_y));
    }
  }
}
