// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int nframes;
  String prefissofile;
  int frame = 0;
  int imageCount = 1;
  int xpos, ypos;
  
  Animation(String prefisso, int nframes) {
    this.nframes = nframes;
    this.prefissofile = prefissofile;
    this.images = new PImage[nframes];
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
