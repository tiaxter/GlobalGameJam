class Player{
  Animation animation;
  float x;
  float y;

  Player(String prefissofile, int nframes){
    animation = new Animation(prefissofile, nframes);
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

}
