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

  boolean isCollidingBox(int player_xs, int player_xe, int player_ys, int player_ye)
  {
    //TODO: define note width rather than using palyer width
    return( player_xs < absx + Constants.PLAYER_WIDTH_BB && 
            player_xe > absx &&
            player_ys < absy + Constants.PLAYER_HEIGHT_BB && 
            player_ye > absy);
  }

  void setOpened(boolean p)
  {
    this.opened = p;
  }

}
