class Frames{

  int PLAYER_ANIM_RATE;
  PImage images[];
  int frame = 0;
  int numero_frames;
  float time;
  float delta_time;

  Frames(String nome, int numero_frames, int rate){
    this.numero_frames = numero_frames;
    images = new PImage[numero_frames];
    for(int i=0; i< numero_frames; i++){
      images[i] = loadImage(nome + i + ".png");
    }
    PLAYER_ANIM_RATE = rate;
    time = millis();

  }

  void display(float x, float y) {

    delta_time += millis() - time;    
    if (delta_time > PLAYER_ANIM_RATE)
    {
      frame = (frame+1) % numero_frames;   
      delta_time = 0.0f;   
    }
    time = millis();

    image(images[frame], x, y);
  }

}
