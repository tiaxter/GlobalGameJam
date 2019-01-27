class Exit
{
  int x_start, y_start, x_end, y_end;


  Exit(int x_start, int y_start,int  x_end, int y_end)
  {
      this.x_start = x_start; 
      this.y_start = y_start;
      this.x_end = x_end;
      this.y_end = y_end ; 
      println("Added exit " + this.toString());
  }

  boolean isPlayerOverArea(int player_x, int player_y)
  {
    return (player_x >= x_start && player_x <= x_end && player_y >= y_start && player_y <= y_end);
  }

  boolean isGameOver(int player_x, int player_y)
  {
      return isPlayerOverArea(player_x, player_y);
  }
  
  String toString()
  {
    return ("Exit @ {" + x_start + ", " + y_start + ", " + x_end + ", " + y_end + "}" );
  }

}