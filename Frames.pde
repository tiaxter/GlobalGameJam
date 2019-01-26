class Frames{

  PImage images[];
  int frame = 0;
  int numero_frames;

  Frames(String nome, int numero_frames){
    this.numero_frames = numero_frames;
    images = new PImage[numero_frames];
    for(int i=0; i< numero_frames; i++){
      images[i] = loadImage(nome + i + ".png");
    }
  }

  void display(float x, float y) {
    frame = (frame+1) % numero_frames;
    image(images[frame], x, y);
  }

}
