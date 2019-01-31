class Exit
{
  int x_start, y_start, x_end, y_end;


  Exit(int x_start, int y_start,int  x_end, int y_end)
  {
      this.x_start = x_start; 
      this.y_start = y_start;
      this.x_end = x_end;
      this.y_end = y_end ; 
  }

  boolean isPlayerOverArea(int player_x, int player_y)
  {
    return (player_x >= x_start && player_x <= x_end && player_y >= y_start && player_y <= y_end);
  }

  boolean isPlayerOverAreaBox(int player_xs, int player_xe, int player_ys, int player_ye)
  {
    return( player_xs < x_end && 
            player_xe > x_start &&
            player_ys < y_end && 
            player_ye > y_start);
  }

  boolean isGameOver(int player_x, int player_y)
  {
      return isPlayerOverArea(player_x, player_y);
  }
  
  boolean isGameOverBox(int player_xs, int player_xe, int player_ys, int player_ye)
  {
      return isPlayerOverAreaBox(player_xs, player_xe, player_ys, player_ye);
  }

  void draw(int cam_x, int cam_y)
  {
    // fill(255,255,0,255);
    // rect(x_start - cam_x, y_start - cam_y, x_end - x_start, y_end - y_start);
    // fill(255,255);
  }

  String toString()
  {
    return ("Exit @ {" + x_start + ", " + y_start + ", " + x_end + ", " + y_end + "}" );
  }

}