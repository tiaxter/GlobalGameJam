// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int nframes;

  Animation(String prefisso_file, int nframes) {
    this.nframes = nframes;
    images = new PImage[nframes];
  }

  void updateDirection(string direction){
    for (int i = 0; i < nframes; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = prefisso_file + "_" + direction + "_" + i + ".png";
      images[i] = loadImage(filename);
    }
  }

  void display() {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }

}
