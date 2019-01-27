class Ladder extends Exit
{

  int x_start, y_start, x_end, y_end;
  int x_exit, y_exit;

  Ladder(int x_start, int y_start,int  x_end, int y_end)
  {
      super(x_start, y_start, x_end, y_end);
      this.x_exit = x_end;
      this.y_exit = y_end;

      println("Added ladder " + this.toString());

  }

  Ladder(int x_start, int y_start,int  x_end, int y_end, int x_exit, int y_exit)
  {
      super(x_start, y_start, x_end, y_end);
      this.x_exit = x_exit;
      this.y_exit = y_exit; 
      println("Added ladder 1 " + this.toString());
  }

  @Override
  boolean isGameOver(int player_x, int player_y)
  { 
    println("Checking ladder at " + player_x + "  " + player_y);
      return (player_x == x_end) && (player_y == y_end);
  }

  String toString()
  {
    return ("Ladder @ {" + x_start + ", " + y_start + ", " + x_end + ", " + y_end + ","  + x_end + ", " + y_end  + "}" );
  }

}