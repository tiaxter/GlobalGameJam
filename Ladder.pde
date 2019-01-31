class Ladder extends Exit
{

  int x_exit, y_exit;

  Ladder(int x_start, int y_start,int  x_end, int y_end)
  {
      super(x_start, y_start, x_end, y_end);
      this.x_exit = x_end;
      this.y_exit = y_end;
  }

  Ladder(int x_start, int y_start,int  x_end, int y_end, int x_exit, int y_exit)
  {
      super(x_start, y_start, x_end, y_end);
      this.x_exit = x_exit;
      this.y_exit = y_exit; 
  }

  @Override
  boolean isGameOver(int player_x, int player_y)
  { 
      return (player_x == x_end) && (player_y == y_end);
  }

 void draw(int cam_x, int cam_y)
  {
    // fill(255,255,0,255);
    // rect(x_start - cam_x, y_start - cam_y, x_end - x_start, y_end - y_start);
    // fill(127,127,0,255);
    // rect(x_exit - cam_x, y_exit - cam_y, Constants.TILE_W, Constants.TILE_H);
    // fill(255,255);
  }

@Override boolean isGameOverBox(int player_xs, int player_xe, int player_ys, int player_ye)
  {
    return( player_xs < x_exit + Constants.TILE_W && 
            player_xe > x_exit &&
            player_ys < y_exit + Constants.TILE_H && 
            player_ye > y_exit);
  }


  String toString()
  {
    return ("Ladder @ {" + x_start + ", " + y_start + ", " + x_end + ", " + y_end + ","  + x_exit + ", " + y_exit  + "}" );
  }

}