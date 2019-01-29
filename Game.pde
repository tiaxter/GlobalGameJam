import ptmx.*;
import java.awt.Dimension;
import java.util.Arrays;

class Game extends Scene {

  // Map container
  Ptmx map;
  String mapName;
  int mapId;

  // Map parsing
  ArrayList<Collectible> oggettiCollezionabili = new ArrayList<Collectible>();
  static final int PuP = 3;
  ArrayList<Door> porte = new ArrayList<Door>();
  ArrayList<Exit> exitPositions = new ArrayList<Exit>();

  int walkableLayerIndex;

  // Player state
  Player player;
  boolean accept_inputs;
  boolean paused;
  boolean showNote;
  String currentNote;
  float timePauseStart = 0;

  // starting view coordinates
  int camera_x = 0;
  int camera_y = 0;

  static final int DIR_UP = 1;
  static final int DIR_DOWN = 0;
  static final int DIR_LEFT = 2;
  static final int DIR_RIGHT = 3;
  static final int DIR_IDLE = 4;

  // Spawn points
  static final int START_X_TOPFLOOR = Constants.PLAYER_WIDTH * 3;
  static final int START_Y_TOPFLOOR = Constants.PLAYER_HEIGHT * 3;

  static final int START_X_GROUNDFLOOR = Constants.PLAYER_WIDTH  * 3;
  static final int START_Y_GROUNDFLOOR = Constants.PLAYER_HEIGHT * 3;


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

    map = new Ptmx(instance, mapName);
    walkableLayerIndex = searchLayer("Walkable");
    pupPosition();
    searchExitPositions();
    stairPositions();
    paused = false;

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

    player.resetTimers();

    // Map parsing
    for (Collectible c : oggettiCollezionabili)
    {
      c.resetStatus();
    }

    paused = false;
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

  int indexObjects = searchLayer("Objects");

  int objectIds[] = {274, 275, 276, 287, 288};

  if (indexObjects != -2)
  {
    println("Found object layer " + indexObjects);
    for(int i = 0; i < map.getMapSize().x; i++)
    {
        for(int j = 0; j < map.getMapSize().y; j++)
        {
          int tileIdx = map.getTileIndex(indexObjects, i, j) + 1;
          for (int z = 0; z < 5; ++z)
          {
            if (objectIds[z] == tileIdx)
            {
              oggettiCollezionabili.add(new Collectible((i*map.getTileSize().x),(j*map.getTileSize().y),i, j, tileIdx , false));
            }
          }
        }
      }
  }
  println("Collectibles:");
  for(Collectible c: oggettiCollezionabili){
    println(c.toString());
  }
}


void searchExitPositions() {
  final int MAX_EXITS = 4;
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
      setDirection(String.valueOf(main_applet.controller.LeftAnalogX()), true, false);
      setDirection(String.valueOf(main_applet.controller.LeftAnalogY()), false, false);
      setDirection(String.valueOf(main_applet.controller.RightAnalogX()), true, true);
      setDirection(String.valueOf(main_applet.controller.RightAnalogY()), false, true);

      if (main_applet.controller.BackPressed())
      {
        main_applet.transition(Constants.MENU_SCENE);
      }
      if (main_applet.controller.StartPressed())
      {
        if (millis() - timePauseStart > 500)
        {

           setPaused(!paused);
           timePauseStart = millis();
        }
      }

    } catch (Exception e) {
      //print(e);

    }

    map.draw(camera_x, camera_y);
    drawObjects(camera_x, camera_y);
    player.draw(camera_x, camera_y);

    if (paused)
    {
      fill(50,170);
      rect(0,0,width,height);
      fill(255,255);
      if (!showNote)
      {
        text("PAUSE", 50, 100);
      }
      else
      {
        text(currentNote, 50, 75);
        text("PREMI P O START PER CONTINUARE", 50, main_applet.height - 50);
      }
    }

    if (controller1[DIR_LEFT])
      moveCamera((int)(-5.0 * ratio), 0, 0);

    if (controller2[DIR_LEFT])
      moveCamera((int)(-5.0 * ratio), 0, 1);


    if (controller1[DIR_RIGHT])
      moveCamera((int)(5.0 * ratio), 0, 0);

    if(controller2[DIR_RIGHT])
      moveCamera((int)(5.0 * ratio), 0, 1);


    if (controller1[DIR_UP])
     moveCamera(0, (int)(-5.0 * ratio), 0);

     if( controller2[DIR_UP])
      moveCamera(0, (int)(-5.0 * ratio), 1);

    if (controller1[DIR_DOWN])
      moveCamera(0, (int)(5.0 * ratio), 0);

    if(controller2[DIR_DOWN])
      moveCamera(0, (int)(5.0 * ratio), 1);

  }

void setDirection(String dir, boolean x, boolean right) {
    float xoy;
    try {
      xoy = Float.valueOf(dir);
    } catch (Exception e) {
      xoy = 0;
    }

    if(!right){
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
    }else{
      if (!x) {
        if (xoy > 0.5) {
          controller2[DIR_DOWN] = true;
          player.setDirection(DIR_DOWN);
        } else {
          if (controller2[DIR_DOWN] == true)
            player.setDirection(DIR_IDLE);

          controller2[DIR_DOWN] = false;
        }

        if (xoy < -0.5) {
          controller2[DIR_UP] = true;
          player.setDirection(DIR_UP);
        } else {
          if (controller2[DIR_UP] == true)
            player.setDirection(DIR_IDLE);

          controller2[DIR_UP] = false;
        }
      } else {
        if (xoy < -0.5) {
          controller2[DIR_LEFT] = true;
          player.setDirection(DIR_LEFT);
        } else {
          if (controller2[DIR_LEFT] == true)
            player.setDirection(DIR_IDLE);

          controller2[DIR_LEFT] = false;
        }

        if (xoy > 0.5) {
          controller2[DIR_RIGHT] = true;
          player.setDirection(DIR_RIGHT);
        } else {
          if (controller2[DIR_RIGHT] == true)
            player.setDirection(DIR_IDLE);
          controller2[DIR_RIGHT] = false;
        }
      }
    }

  }


  int getTileMapWidth() {
    return (int)(map.getTileSize().x * map.getMapSize().x);
  }

  int getTileMapHeight() {
    return (int)(map.getTileSize().y * map.getMapSize().y);
  }

  void setPaused(boolean paused)
  {
    if (this.paused && showNote)
    {
        showNote = false;
    }

    this.paused = paused;
    player.setPaused(paused);
  }

  void moveCamera(int delta_x, int delta_y, int movement_player) {

    if (accept_inputs && !player.isActive(movement_player))
      return;

    if (paused)
    {
      return;
    }

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
              return;
            }
          }
        }

        // Moving over a ladder tile
        if(e.isPlayerOverArea(next_player_tile_x, next_player_tile_y))
        {
          if (player.direction != Game.DIR_LEFT && player.direction != Game.DIR_RIGHT)
          {
            return;
          }
        }
      }

      // Moving towards an exit tile
      if(e.isPlayerOverArea(next_player_tile_x, next_player_tile_y))
      {
        // Win conditions for each player
        if (movement_player == Constants.JONNY && e instanceof Ladder && e.isGameOver(next_player_tile_x, next_player_tile_y))
        {
          main_applet.setLastWinner(Constants.JONNY);
          println("GAME OVER: Jonny wins");
          main_applet.transition(Constants.GAME_OVER);
          accept_inputs = false;
        }

        if(movement_player == Constants.KENNY && !(e instanceof Ladder))
        {
          main_applet.setLastWinner(Constants.KENNY);
          main_applet.transition(Constants.GAME_OVER);
          println("GAME OVER: Kenny wins");
          accept_inputs = false;
        }
      }
    }

    // Check ground collisions
    if (isWalkable(next_player_tile_x, next_player_tile_y)) {
      player.move(delta_x, delta_y, getTileMapWidth(), getTileMapHeight());

      if (player.x >= main_applet.width / 2 && player.x < getTileMapWidth() - main_applet.width / 2) {
        camera_x = camera_x + delta_x;
      }

      if (player.y >= main_applet.height / 2 && player.y < getTileMapHeight() - main_applet.height / 2) {
        camera_y = camera_y + delta_y;
      }

      testCollectObject(next_player_tile_x, next_player_tile_y, player.currentPlayer);
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

    if (key == 'P' || key == 'p'){
      setPaused(!paused);
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

  void drawObjects(int camera_x, int camera_y)
  {
    for(Collectible c : oggettiCollezionabili)
    {
        c.draw(camera_x, camera_y);
    }
  }

  void testCollectObject(int player_x, int player_y, int currentPlayer)
  {
    for(Collectible c : oggettiCollezionabili)
    {
        if (c.isColliding(player_x, player_y))
        {
            if (!c.picked)
            {
              handlePickedObject(c.collectible_type, currentPlayer, c.getText(currentPlayer));
              player.powerUp(currentPlayer);
            }

            c.setPicked(true);
        }
    }
  }

  void handlePickedObject(int collectible_id, int currentPlayer, String text)
  {
      if(currentPlayer == Constants.JONNY)
        println("Raccolto elemento " + collectible_id + " da Jonny");
      else
        println("Raccolto elemento " + collectible_id + " da Kenny");

      currentNote = text;
      showNote = true;
      paused = true;
      player.setPaused(true);
  }


  boolean isDoorClosed(int x, int y)
  {
    for(Door d : porte)
    {
        if (d.isColliding(x, y))
        {
            return (!d.opened);
        }
    }
    return false;
  }

}
