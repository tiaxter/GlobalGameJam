class Player{
  Animation animation;
  float x;
  float y;

  Player(String prefisso_file, int nframes){
    animation = new Animation(prefisso_file, nframes);
  }

  void setDirection(int dir) {
    switch(dir){
      case 0:
        updateDirection("up");
        break;
      case 1:
        updateDirection("down");
        break;
      case 2:
        updateDirection("left");
        break;
      case 3:
        updateDirection("right");
        break
    }
  }

}
