// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  Frames[] frames;
  int currentDirection;
  int nframes;
  String prefissofile;
  int frame = 0;
  int imageCount = 1;
  int xpos, ypos;

  Animation(String prefisso, int nframes) {
    frames = new Frames[5];
    for(int i = 0; i < 5; i++){
      switch(i){
        case 0:
          frames[i] = new Frames(prefisso + "_down_", nframes, 100);
          break;
        case 1:
          frames[i] = new Frames(prefisso + "_up_", nframes, 100);
          break;
        case 2:
          frames[i] = new Frames(prefisso + "_left_", nframes, 100);
          break;
        case 3:
          frames[i] = new Frames(prefisso + "_right_", nframes, 100);
          break;
        case 4:
          frames[i] = new Frames(prefisso, nframes, 500);
          break;

      }
    }
    this.nframes = nframes;
    this.prefissofile = prefisso;
    this.images = new PImage[nframes];

    updateDirection(3);
  }

  void updateDirection(int dir){

    currentDirection = dir;

  }

  void display(float x, float y) {
    frames[currentDirection].display(x, y);
  }

}
