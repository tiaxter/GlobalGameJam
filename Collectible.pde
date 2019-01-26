class Collectible{
  float absx;
  float absy;
  float mapx;
  float mapy;
  int collectible_type;
  boolean picked;

  Collectible(float absx, float absy, float mapx, float mapy, int collectible_type, boolean picked){
    this.absx = absx;
    this.absy = absy;
    this.mapx = mapx;
    this.mapy = mapy;
    this.collectible_type = collectible_type;
    this.picked = picked;
  }

  @Override
  String toString(){
    return "Absolute X : " + absx + "\nAbsolute Y: " + absy +
    "\nMap X : " + mapx + "\nMap Y : " + mapy +
    "\nTipo di oggetto : " + collectible_type;
  }

}
