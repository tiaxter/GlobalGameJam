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
    this.prefissofile = prefisso;
    this.images = new PImage[nframes];

    updateDirection("left");
  }

  void updateDirection(String direction){

    direction = "left";

    for (int i = 0; i < nframes; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = prefissofile + "_" + direction + "_" + i + ".png";
      //String filename = prefissofile + "_" + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  void display(x, y) {
    frame = (frame+1) % nframes;
    image(images[frame], x, y);
  }

}
