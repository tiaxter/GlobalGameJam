import ptmx.*;
import java.awt.Dimension;

class Game extends Scene {

  // Map container
  Ptmx map;
  String mapName;
  int mapId;

  // Map parsing
  ArrayList<Collectible> oggettiCollezionabili = new ArrayList<Collectible>();
  static final int PuP = 3;

  ArrayList<Exit> exitPositions = new ArrayList<Exit>();

  int walkableLayerIndex;

  // Player state 
  Player player;
  boolean accept_inputs;  
  
  // starting view coordinates
  int camera_x = 0;
  int camera_y = 0;

  static final int DIR_UP = 1;
  static final int DIR_DOWN = 0;
  static final int DIR_LEFT = 2;
  static final int DIR_RIGHT = 3;
  static final int DIR_IDLE = 4;

  // Spawn points
  static final int START_X_TOPFLOOR = 192 * 3;
  static final int START_Y_TOPFLOOR = 192 * 3;

  static final int START_X_GROUNDFLOOR = 192 * 3;
  static final int START_Y_GROUNDFLOOR = 192 * 3;


  // Controller and status
  Controller controller;
  ControlIO control;

  boolean controller1[] = {
    false,
    false,
    false,
    false
  };

  boolean controller2[] = {
    false,
    false,
    false,
    false
  };

  GlobalGameJam main_applet;

  Game(float ratio, String map, int idMap) {
    super(ratio);
    this.mapName = map;
    this.mapId = idMap;
  }

  boolean init(PApplet instance) {
    player = new Player(instance);

    main_applet = (GlobalGameJam)instance;

    if(mapId == Constants.GAME_TOPFLOOR)
    {
      player.setPosition(START_X_TOPFLOOR, START_Y_TOPFLOOR);
    }
    else 
    {
        if(mapId == Constants.GAME_GROUNDFLOOR){
        player.setPosition(START_X_GROUNDFLOOR ,START_Y_GROUNDFLOOR);
        }

    }

    control = ControlIO.getInstance(instance);
    controller = new Controller(control);
    map = new Ptmx(instance, mapName);
    walkableLayerIndex = searchLayer("Walkable");
    pupPosition();
    searchExitPositions();
    stairPositions();

    return (player != null && map != null);
  }

  void endTransition()
  {}

  void reset()
  {
    camera_x = camera_y = 0;
    if(mapId == Constants.GAME_TOPFLOOR)
    {
      player.setPosition(START_X_TOPFLOOR, START_Y_TOPFLOOR);
    }
    else 
    {
        if(mapId == Constants.GAME_GROUNDFLOOR){
        player.setPosition(START_X_GROUNDFLOOR ,START_Y_GROUNDFLOOR);
        }

    }

    accept_inputs = true;
  }

  int searchLayer(String str) {
    int layerindex = 0;
    int maplayer[];
    do {
      layerindex++;
      maplayer = map.getData(layerindex);
      if (maplayer != null && map.getName(layerindex).equals(str))
        break;
    } while (maplayer != null);
    
    if (maplayer != null)
    {
      return layerindex;
    }

    return -2;
  }

  /*int[]*/ void pupPosition(){
  for(int i = 0; i < map.getMapSize().x; i++){
      for(int j = 0; j < map.getMapSize().y; j++){
        if(map.getTileIndex(walkableLayerIndex, i, j) == 3){
          oggettiCollezionabili.add(new Collectible((i*map.getTileSize().x),(j*map.getTileSize().y),i, j, PuP, false));
        }
      }
    }
    
    for(Collectible c: oggettiCollezionabili){
      println(c.toString());
    }
  }


void searchExitPositions() {
  final int MAX_EXITS = 2;
  for (int layer = 1; layer <= MAX_EXITS; layer++) {
    String layerName = "Exit" + layer;
    int layerIndex = searchLayer(layerName);
    if (layerIndex != -2) {
      ArrayList<Dimension> cells = new ArrayList<Dimension>(); 
      for (int i = 0; i < map.getMapSize().x; i++) {
        for (int j = 0; j < map.getMapSize().y; j++) {
          if (map.getTileIndex(layerIndex, i, j) > 0) {
            cells.add(new Dimension(i,j));
          }
        }
      }

      int min_x = 1000, max_x = -1, min_y = 1000, max_y = -1;
      for(Dimension d: cells)
      {
          if(d.width < min_x)
            min_x = d.width;
          
          if(d.height < min_y)
            min_y = d.height;

          if (d.width > max_x)
            max_x = d.width;

          if (d.height > max_y)
            max_y = d.height;    
      }
      Exit e = new Exit(min_x, min_y, max_x, max_y);
      exitPositions.add(e);
    }
  }

}

void stairPositions() {
  int x_exit = -1, y_exit = -1;
  String stairStrings[] = { "Stairs", "EndStairs"};
  ArrayList<Dimension> cells = new ArrayList<Dimension>(); 
  for (String s : stairStrings) 
  {
    int layerIndex = searchLayer(s);
    if (layerIndex != -2) {
      for (int i = 0; i < map.getMapSize().x; i++) {
        for (int j = 0; j < map.getMapSize().y; j++) {
          if (map.getTileIndex(layerIndex, i, j) > 0) {
            if (s.equals("EndStairs"))
            {
              x_exit = i;
              y_exit = j;
            }
            else
            {
              cells.add(new Dimension(i,j));
            }
          }
        }
      }
    }
  }

  int min_x = 1000, max_x = -1, min_y = 1000, max_y = -1;
  for(Dimension d: cells)
  {
      if(d.width < min_x)
        min_x = d.width;
      
      if(d.height < min_y)
        min_y = d.height;

      if (d.width > max_x)
        max_x = d.width;

      if (d.height > max_y)
        max_y = d.height;    
  }

  Ladder l = new Ladder(min_x, min_y, max_x, max_y, x_exit, y_exit);
  exitPositions.add(l);

}



  boolean isWalkable(int x, int y) {
    if (map.getTileIndex(walkableLayerIndex, x, y) >= 0) {
      return true;
    }
    return false;
  }

  int getPlayerTileX() {
    return (int)(player.x / map.getTileSize().x);
  }

  int getPlayerTileY() {
    return (int)(player.y / map.getTileSize().y);
  }

  void draw() {

    try {
      setDirection(String.valueOf(controller.LeftAnalogX()), true);
      setDirection(String.valueOf(controller.LeftAnalogY()), false);

      if (controller.StartPressed() || controller.BackPressed())
      {
        main_applet.transition(Constants.MENU_SCENE);
      }

    } catch (Exception e) {
      //print(e);

    }

    map.draw(camera_x, camera_y);
    player.draw(camera_x, camera_y);


    if (controller1[DIR_LEFT])
      moveCamera((int)(-10.0 * ratio), 0, 0);

    if (controller2[DIR_LEFT])
      moveCamera((int)(-10.0 * ratio), 0, 1);


    if (controller1[DIR_RIGHT])
      moveCamera((int)(10.0 * ratio), 0, 0);

    if(controller2[DIR_RIGHT])
      moveCamera((int)(10.0 * ratio), 0, 1);


    if (controller1[DIR_UP])
     moveCamera(0, (int)(-10.0 * ratio), 0);

     if( controller2[DIR_UP])
      moveCamera(0, (int)(-10.0 * ratio), 1);

    if (controller1[DIR_DOWN])
      moveCamera(0, (int)(10.0 * ratio), 0);

    if(controller2[DIR_DOWN])
      moveCamera(0, (int)(10.0 * ratio), 1);

  }

  void setDirection(String dir, boolean x) {
    float xoy;
    try {
      xoy = Float.valueOf(dir);
    } catch (Exception e) {
      xoy = 0;
    }

    if (!x) {
      if (xoy > 0.5) {
        controller1[DIR_DOWN] = true;
        player.setDirection(DIR_DOWN);
      } else {
        if (controller1[DIR_DOWN] == true)
          player.setDirection(DIR_IDLE);

        controller1[DIR_DOWN] = false;
      }

      if (xoy < -0.5) {
        controller1[DIR_UP] = true;
        player.setDirection(DIR_UP);
      } else {
        if (controller1[DIR_UP] == true)
          player.setDirection(DIR_IDLE);

        controller1[DIR_UP] = false;
      }
    } else {
      if (xoy < -0.5) {
        controller1[DIR_LEFT] = true;
        player.setDirection(DIR_LEFT);
      } else {
        if (controller1[DIR_LEFT] == true)
          player.setDirection(DIR_IDLE);

        controller1[DIR_LEFT] = false;
      }

      if (xoy > 0.5) {
        controller1[DIR_RIGHT] = true;
        player.setDirection(DIR_RIGHT);
      } else {
        if (controller1[DIR_RIGHT] == true)
          player.setDirection(DIR_IDLE);
        controller1[DIR_RIGHT] = false;
      }
    }
  }


  int getTileMapWidth() {
    return (int)(map.getTileSize().x * map.getMapSize().x);
  }

  int getTileMapHeight() {
    return (int)(map.getTileSize().y * map.getMapSize().y);
  }


  void moveCamera(int delta_x, int delta_y, int movement_player) {

    if (accept_inputs && !player.isActive(movement_player))
      return;

    float xy[] = player.simulateMove(delta_x, delta_y, getTileMapWidth(), getTileMapHeight());

    int curr_player_tile_x = (int)((player.x + Constants.PLAYER_WIDTH  / 2) / map.getTileSize().x);
    int curr_player_tile_y = (int)((player.y + Constants.PLAYER_HEIGHT / 2) / map.getTileSize().y);

    int next_player_tile_x = (int)((xy[0] + Constants.PLAYER_WIDTH  / 2) / map.getTileSize().x);
    int next_player_tile_y = (int)((xy[1] + Constants.PLAYER_HEIGHT / 2) / map.getTileSize().y);
    

    // Check for exits and ladders
    for(Exit e: exitPositions)
    {

      // Stairs checks... movement can only be horizontal
      if (e instanceof Ladder)
      {
        // Moving away from an exit tile
        if(!e.isPlayerOverArea(next_player_tile_x, next_player_tile_y))
        {
          // to a standard tile
          if(e.isPlayerOverArea(curr_player_tile_x, curr_player_tile_y))
          {

            // If next move takes the player away from the stairs, prevent it unless you're moving horizontally
            if (player.direction != Game.DIR_LEFT || player.direction != Game.DIR_RIGHT);
            {
              println("From ladder to standard blocked...(" + curr_player_tile_x + "," +  curr_player_tile_y + ") => (" + next_player_tile_x + "," + next_player_tile_y + ")");
              return;
            } 
          }
        }

        // Moving over a ladder tile
        if(e.isPlayerOverArea(next_player_tile_x, next_player_tile_y))
        {
          if (player.direction != Game.DIR_LEFT && player.direction != Game.DIR_RIGHT)
          {
            println("Going to ladder with wrong direction...(" + curr_player_tile_x + "," +  curr_player_tile_y + ") => (" + next_player_tile_x + "," + next_player_tile_y + "), " +  player.direction);
            return;
          }
        }
      }

      // Moving towards an exit tile
      if(e.isPlayerOverArea(next_player_tile_x, next_player_tile_y))
      {
        // Win conditions for each player
        if (movement_player == 0 && e instanceof Ladder && e.isGameOver(next_player_tile_x, next_player_tile_y))
        {
          println("GAME OVER: Player 1 wins");
          main_applet.transition(Constants.GAME_OVER);
          accept_inputs = false;
        }
        
        if(movement_player == 1 && !(e instanceof Ladder))
        {
          main_applet.transition(Constants.GAME_OVER);
          println("GAME OVER: Player 2 wins");
          accept_inputs = false;
        }
      }
    }

    // Check ground collisions
    if (isWalkable(next_player_tile_x, next_player_tile_y)) {
      player.move(delta_x, delta_y, getTileMapWidth(), getTileMapHeight());

      if (player.x >= Constants.SCREEN_W / 2 && player.x < getTileMapWidth() - Constants.SCREEN_W / 2) {
        camera_x = camera_x + delta_x;
      }

      if (player.y >= Constants.SCREEN_H / 2 && player.y < getTileMapHeight() - Constants.SCREEN_H / 2) {
        camera_y = camera_y + delta_y;
      }

    }
    else
    {
      println("Going to non walkable...(" + curr_player_tile_x + "," +  curr_player_tile_y + ") => (" + next_player_tile_x + "," + next_player_tile_y + ")");
    }
  }

  void keyReleased() {
    if (key == CODED) {
      if (keyCode == DOWN) {
        controller2[DIR_DOWN] = false;
        player.setDirection(DIR_IDLE);
      }

      //else
      if (keyCode == RIGHT){
        controller2[DIR_RIGHT] = false;
        player.setDirection(DIR_IDLE);
      }

      //else
      if (keyCode == UP){
        controller2[DIR_UP] = false;
        player.setDirection(DIR_IDLE);
      }


      if (keyCode == LEFT){
        controller2[DIR_LEFT] = false;
        player.setDirection(DIR_IDLE);
      }
      //
    }

    if (key == 'S' || key == 's') {
      controller1[DIR_DOWN] = false;
      player.setDirection(DIR_IDLE);
    }

    //else
    if (key == 'D' || key == 'd'){
      controller1[DIR_RIGHT] = false;
      player.setDirection(DIR_IDLE);
    }

    //else
    if (key == 'W' || key == 'w'){
      controller1[DIR_UP] = false;
      player.setDirection(DIR_IDLE);
    }


    if (key == 'A' || key == 'a'){
      controller1[DIR_LEFT] = false;
      player.setDirection(DIR_IDLE);
    }
  }

  void keyPressed() {

    if (key == ESC)
    {
      main_applet.transition(Constants.MENU_SCENE);
      key = 0;
    }

    if (key == CODED) {
      if (keyCode == DOWN) {
        controller2[DIR_DOWN] = true;
        player.setDirection(DIR_DOWN);
      }
      //else
      if (keyCode == RIGHT) {
        controller2[DIR_RIGHT] = true;
        player.setDirection(DIR_RIGHT);
      }
      //else
      if (keyCode == UP) {
        controller2[DIR_UP] = true;
        player.setDirection(DIR_UP);
      }
      if (keyCode == LEFT) {
        controller2[DIR_LEFT] = true;
        player.setDirection(DIR_LEFT);
      }
    }

    if (key == 'S' || key == 's') {
      controller1[DIR_DOWN] = true;
      player.setDirection(DIR_DOWN);
    }

    //else
    if (key == 'D' || key == 'd'){
      controller1[DIR_RIGHT] = true;
      player.setDirection(DIR_RIGHT);
    }

    //else
    if (key == 'W' || key == 'w'){
        controller1[DIR_UP] = true;
        player.setDirection(DIR_UP);
    }

    if (key == 'A' || key == 'a'){
      controller1[DIR_LEFT] = true;
      player.setDirection(DIR_LEFT);
    }
  }
}
