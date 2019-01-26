// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int frame;
  int nframes;
  String prefissofile;

  Animation(String prefissofile, int nframes) {
    this.nframes = nframes;
    this.prefissofile = prefissofile;
    images = new PImage[nframes];
    updateDirection("up");
  }

  void updateDirection(String direction){
    for (int i = 0; i < nframes; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = prefissofile + "_" + direction + "_" + i + ".png";
      //String filename = prefissofile + "_" + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  void display() {
    frame = (frame+1) % nframes;
    image(images[frame], 0, 0);
  }

}
