class Door
{
  float absx;
  float absy;
  float mapx;
  float mapy;
  boolean opened;
  PImage image;

  Door(float absx, float absy, float mapx, float mapy, boolean opened){
    this.absx = absx;
    this.absy = absy;
    this.mapx = mapx;
    this.mapy = mapy;
    this.opened = opened;
    this.image = loadImage("icon.png");
  }

  @Override
  String toString(){
    return "Absolute X : " + absx + "\nAbsolute Y: " + absy +
    "\nMap X : " + mapx + "\nMap Y : " + mapy +
    "\nPorta aperta: " + opened;
  }

  void draw(int camera_x, int camera_y)
  {
    if (!opened)
    {
      image(image, this.absx - camera_x, this.absy - camera_y);
    }
  }

  boolean isColliding(int grid_x, int grid_y)
  {
    return grid_x == this.mapx && grid_y == this.mapy; 
  }

  void setOpened(boolean p)
  {
    this.opened = p;
  }

}
