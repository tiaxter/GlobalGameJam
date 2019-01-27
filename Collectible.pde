class Collectible{
  float absx;
  float absy;
  float mapx;
  float mapy;
  int collectible_type;
  boolean picked;
  PImage image;

  Collectible(float absx, float absy, float mapx, float mapy, int collectible_type, boolean picked){
    this.absx = absx;
    this.absy = absy;
    this.mapx = mapx;
    this.mapy = mapy;
    this.collectible_type = collectible_type;
    this.picked = picked;
    this.image = loadImage("icon.png");
  }

  @Override
  String toString(){
    return "Absolute X : " + absx + "\nAbsolute Y: " + absy +
    "\nMap X : " + mapx + "\nMap Y : " + mapy +
    "\nTipo di oggetto : " + collectible_type;
  }

  void draw(int camera_x, int camera_y)
  {
    if (!picked)
    {
      image(image, this.absx - camera_x, this.absy - camera_y);
    }
  }

  boolean isColliding(int player_x, int player_y)
  {
    return player_x == this.mapx && player_y == this.mapy; 
  }

  void setPicked(boolean p)
  {
    this.picked = p;
  }

}
