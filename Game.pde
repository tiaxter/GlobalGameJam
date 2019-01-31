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

  static final int START_X_GARDEN = Constants.PLAYER_WIDTH  * 3;
  static final int START_Y_GARDEN = Constants.PLAYER_HEIGHT * 3;

  static final int START_X_MANSION = Constants.PLAYER_WIDTH  * 3;
  static final int START_Y_MANSION = Constants.PLAYER_HEIGHT * 3;

  GlobalGameJam main_applet;
  int exitSceneId;
  int stairSceneId;
  

  Game(float ratio, String map, int idMap, int onStairId, int onExitId) {
    super(ratio);
    this.mapName = map;
    this.mapId = idMap;
    this.exitSceneId = onExitId;
    this.stairSceneId = onStairId;
  }

  boolean init(PApplet instance) {
    player = new Player(instance);

    main_applet = (GlobalGameJam)instance;

    if(mapId == Constants.GAME_TOPFLOOR)
    {
      player.setPosition(START_X_TOPFLOOR, START_Y_TOPFLOOR);
    }
    else if(mapId == Constants.GAME_GROUNDFLOOR){
        player.setPosition(START_X_GROUNDFLOOR ,START_Y_GROUNDFLOOR);
    }
    else if(mapId == Constants.GAME_MANSION){
        player.setPosition(START_X_MANSION ,START_Y_MANSION);
    }
    else if(mapId == Constants.GAME_GARDEN){
        player.setPosition(START_X_GARDEN ,START_Y_GARDEN);
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
      Exit e = new Exit(min_x * Constants.TILE_W, min_y * Constants.TILE_H, (max_x+1) * Constants.TILE_W, (max_y+1) * Constants.TILE_H);
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

  Ladder l = new Ladder(min_x * Constants.TILE_W, min_y * Constants.TILE_H,
                        (max_x+1) * Constants.TILE_W, (max_y+1) * Constants.TILE_H, 
                        x_exit * Constants.TILE_W, y_exit * Constants.TILE_H);
  exitPositions.add(l);

}

  boolean isWalkableArea(int xs, int xe, int ys, int ye) 
  {
    boolean walkable = true;

    int x1 = (int)(xs/map.getTileSize().x);
    int x2 = (int)(xe/map.getTileSize().x);
    int y1 = (int)(ys/map.getTileSize().y);
    int y2 = (int)(ye/map.getTileSize().y);

    return (map.getTileIndex(walkableLayerIndex, x1, y1) > 0 &&
            map.getTileIndex(walkableLayerIndex, x2, y1) > 0 &&
            map.getTileIndex(walkableLayerIndex, x1, y2) > 0 &&
            map.getTileIndex(walkableLayerIndex, x2, y2) > 0
    );
    
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
      setDirection(String.valueOf(main_applet.controller.LeftAnalogX()), true, Constants.KENNY);
      setDirection(String.valueOf(main_applet.controller.LeftAnalogY()), false, Constants.KENNY);
      setDirection(String.valueOf(main_applet.controller.RightAnalogX()), true, Constants.JONNY);
      setDirection(String.valueOf(main_applet.controller.RightAnalogY()), false, Constants.JONNY);

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

    if (main_applet.controllers[Constants.KENNY][DIR_LEFT])
      moveCamera((int)(-5.0 * ratio), 0, 0);

    if (main_applet.controllers[Constants.JONNY][DIR_LEFT])
      moveCamera((int)(-5.0 * ratio), 0, 1);


    if (main_applet.controllers[Constants.KENNY][DIR_RIGHT])
      moveCamera((int)(5.0 * ratio), 0, 0);

    if(main_applet.controllers[Constants.JONNY][DIR_RIGHT])
      moveCamera((int)(5.0 * ratio), 0, 1);

    if (main_applet.controllers[Constants.KENNY][DIR_UP])
     moveCamera(0, (int)(-5.0 * ratio), 0);

     if( main_applet.controllers[Constants.JONNY][DIR_UP])
      moveCamera(0, (int)(-5.0 * ratio), 1);

    if (main_applet.controllers[Constants.KENNY][DIR_DOWN])
      moveCamera(0, (int)(5.0 * ratio), 0);

    if(main_applet.controllers[Constants.JONNY][DIR_DOWN])
      moveCamera(0, (int)(5.0 * ratio), 1);

  }

void setDirection(String dir, boolean x, int currPlayer) {
    float xoy;
    try {
      xoy = Float.valueOf(dir);
    } catch (Exception e) {
      xoy = 0;
    }

    if(currPlayer == Constants.KENNY)
    {
      if (!x) {
        if (xoy > 0.5) {
          main_applet.controllers[Constants.KENNY][DIR_DOWN] = true;
          player.setDirection(DIR_DOWN);
        } else {
          if (main_applet.controllers[Constants.KENNY][DIR_DOWN] == true)
            player.setDirection(DIR_IDLE);

          main_applet.controllers[Constants.KENNY][DIR_DOWN] = false;
        }

        if (xoy < -0.5) {
          main_applet.controllers[Constants.KENNY][DIR_UP] = true;
          player.setDirection(DIR_UP);
        } else {
          if (main_applet.controllers[Constants.KENNY][DIR_UP] == true)
            player.setDirection(DIR_IDLE);

          main_applet.controllers[Constants.KENNY][DIR_UP] = false;
        }
      } else {
        if (xoy < -0.5) {
          main_applet.controllers[Constants.KENNY][DIR_LEFT] = true;
          player.setDirection(DIR_LEFT);
        } else {
          if (main_applet.controllers[Constants.KENNY][DIR_LEFT] == true)
            player.setDirection(DIR_IDLE);

          main_applet.controllers[Constants.KENNY][DIR_LEFT] = false;
        }

        if (xoy > 0.5) {
          main_applet.controllers[Constants.KENNY][DIR_RIGHT] = true;
          player.setDirection(DIR_RIGHT);
        } else {
          if (main_applet.controllers[Constants.KENNY][DIR_RIGHT] == true)
            player.setDirection(DIR_IDLE);
          main_applet.controllers[Constants.KENNY][DIR_RIGHT] = false;
        }
      }
    }else{
      if (!x) {
        if (xoy > 0.5) {
          main_applet.controllers[Constants.JONNY][DIR_DOWN] = true;
          player.setDirection(DIR_DOWN);
        } else {
          if (main_applet.controllers[Constants.JONNY][DIR_DOWN] == true)
            player.setDirection(DIR_IDLE);

          main_applet.controllers[Constants.JONNY][DIR_DOWN] = false;
        }

        if (xoy < -0.5) {
          main_applet.controllers[Constants.JONNY][DIR_UP] = true;
          player.setDirection(DIR_UP);
        } else {
          if (main_applet.controllers[Constants.JONNY][DIR_UP] == true)
            player.setDirection(DIR_IDLE);

          main_applet.controllers[Constants.JONNY][DIR_UP] = false;
        }
      } else {
        if (xoy < -0.5) {
          main_applet.controllers[Constants.JONNY][DIR_LEFT] = true;
          player.setDirection(DIR_LEFT);
        } else {
          if (main_applet.controllers[Constants.JONNY][DIR_LEFT] == true)
            player.setDirection(DIR_IDLE);

          main_applet.controllers[Constants.JONNY][DIR_LEFT] = false;
        }

        if (xoy > 0.5) {
          main_applet.controllers[Constants.JONNY][DIR_RIGHT] = true;
          player.setDirection(DIR_RIGHT);
        } else {
          if (main_applet.controllers[Constants.JONNY][DIR_RIGHT] == true)
            player.setDirection(DIR_IDLE);
          main_applet.controllers[Constants.JONNY][DIR_RIGHT] = false;
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

    int curr_player_bb_xs = (int)player.x + (Constants.PLAYER_WIDTH - Constants.PLAYER_WIDTH_BB) / 2;
    int curr_player_bb_xe = (int)player.x + (Constants.PLAYER_WIDTH + Constants.PLAYER_WIDTH_BB) / 2;
    int curr_player_bb_ys = (int)player.y + (Constants.PLAYER_HEIGHT - Constants.PLAYER_HEIGHT_BB) / 2;
    int curr_player_bb_ye = (int)player.y + (Constants.PLAYER_HEIGHT + Constants.PLAYER_HEIGHT_BB) / 2;
    
    int next_player_bb_xs = (int)xy[0] + (Constants.PLAYER_WIDTH - Constants.PLAYER_WIDTH_BB) / 2;
    int next_player_bb_xe = (int)xy[0] + (Constants.PLAYER_WIDTH + Constants.PLAYER_WIDTH_BB) / 2;
    int next_player_bb_ys = (int)xy[1] + (Constants.PLAYER_HEIGHT - Constants.PLAYER_HEIGHT_BB) / 2;
    int next_player_bb_ye = (int)xy[1] + (Constants.PLAYER_HEIGHT + Constants.PLAYER_HEIGHT_BB) / 2;

    fill(255,0,0,255);
    rect(curr_player_bb_xs - camera_x, curr_player_bb_ys - camera_y, curr_player_bb_xe - curr_player_bb_xs, curr_player_bb_ye - curr_player_bb_ys);
    
    fill(0,255,0,255);
    rect(next_player_bb_xs - camera_x, next_player_bb_ys - camera_y, next_player_bb_xe - next_player_bb_xs, next_player_bb_ye - next_player_bb_ys);
    
    // Check for exits and ladders
    for(Exit e: exitPositions)
    {
      // Stairs checks... movement can only be horizontal
      if (e instanceof Ladder)
      {
        // Moving away from an exit tile
        if(!e.isPlayerOverAreaBox(next_player_bb_xs, next_player_bb_xe, next_player_bb_ys, next_player_bb_ye))
        {
          // to a standard tile
          if(e.isPlayerOverAreaBox(curr_player_bb_xs, curr_player_bb_xe, curr_player_bb_ys, curr_player_bb_ye))
          {
            if (main_applet.controllers[movement_player][DIR_DOWN] || 
                main_applet.controllers[movement_player][DIR_UP] ||
                e.isGameOverBox(curr_player_bb_xs, curr_player_bb_xe, curr_player_bb_ys, curr_player_bb_ye))
            {
              return;
            }
          }
        }
        else
        {
          if(!e.isPlayerOverAreaBox(curr_player_bb_xs, curr_player_bb_xe, curr_player_bb_ys, curr_player_bb_ye))
          {
            // moving from non-stair to stair cannot happen from the end!
            if (e.isGameOverBox(next_player_bb_xs, next_player_bb_xe, next_player_bb_ys, next_player_bb_ye))
              return;
          }

          if (main_applet.controllers[movement_player][DIR_DOWN] || main_applet.controllers[movement_player][DIR_UP])
          {
            return;
          }
        }
      }

      // Moving towards an exit tile
      if(e.isPlayerOverAreaBox(next_player_bb_xs, next_player_bb_xe, next_player_bb_ys, next_player_bb_ye))
      {
        // Win conditions for each player
        if (movement_player == Constants.JONNY && e instanceof Ladder && e.isGameOverBox(next_player_bb_xs, next_player_bb_xe, next_player_bb_ys, next_player_bb_ye))
        {
          main_applet.setLastWinner(Constants.JONNY);
          main_applet.transition(this.stairSceneId);
          accept_inputs = false;
        }

        if(movement_player == Constants.KENNY && !(e instanceof Ladder))
        {
          main_applet.setLastWinner(Constants.KENNY);
          main_applet.transition(this.exitSceneId);
          accept_inputs = false;
        }
      }
    }

    // Check ground collisions
    if (isWalkableArea(next_player_bb_xs, next_player_bb_xe, next_player_bb_ys, next_player_bb_ye)) 
    {
      player.move(delta_x, delta_y, getTileMapWidth(), getTileMapHeight());

      if (player.x >= main_applet.width / 2 && player.x < getTileMapWidth() - main_applet.width / 2) {
        camera_x = camera_x + delta_x;
      }

      if (player.y >= main_applet.height / 2 && player.y < getTileMapHeight() - main_applet.height / 2) {
        camera_y = camera_y + delta_y;
      }

      testCollectObject(next_player_bb_xs, next_player_bb_xe, next_player_bb_ys, next_player_bb_ye, player.currentPlayer);
    }
  }

  void keyReleased() {
    if (key == CODED) {

      if (player.isActive(Constants.JONNY))
      {
        if (keyCode == DOWN) {
          main_applet.controllers[Constants.JONNY][DIR_DOWN] = false;
        }

        //else
        if (keyCode == RIGHT){
          main_applet.controllers[Constants.JONNY][DIR_RIGHT] = false;
        }

        //else
        if (keyCode == UP){
          main_applet.controllers[Constants.JONNY][DIR_UP] = false;
        }


        if (keyCode == LEFT){
          main_applet.controllers[Constants.JONNY][DIR_LEFT] = false;
        }
        //
      }

      if (main_applet.controllers[Constants.JONNY][DIR_UP] == false && 
          main_applet.controllers[Constants.JONNY][DIR_DOWN] == false && 
          main_applet.controllers[Constants.JONNY][DIR_LEFT] == false && 
          main_applet.controllers[Constants.JONNY][DIR_RIGHT] == false)
          player.setDirection(DIR_IDLE);
    }

    if (player.isActive(Constants.KENNY))
    {
      if (key == 'S' || key == 's') {
        main_applet.controllers[Constants.KENNY][DIR_DOWN] = false;
      }

      //else
      if (key == 'D' || key == 'd'){
        main_applet.controllers[Constants.KENNY][DIR_RIGHT] = false;
      }

      //else
      if (key == 'W' || key == 'w'){
        main_applet.controllers[Constants.KENNY][DIR_UP] = false;
      }


      if (key == 'A' || key == 'a'){
        main_applet.controllers[Constants.KENNY][DIR_LEFT] = false;
      }

      if (main_applet.controllers[Constants.KENNY][DIR_UP] == false && 
          main_applet.controllers[Constants.KENNY][DIR_DOWN] == false && 
          main_applet.controllers[Constants.KENNY][DIR_LEFT] == false && 
          main_applet.controllers[Constants.KENNY][DIR_RIGHT] == false)
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

      if (player.isActive(Constants.JONNY))
      {

        if (keyCode == DOWN) {
          main_applet.controllers[Constants.JONNY][DIR_DOWN] = true;
          player.setDirection(DIR_DOWN);
        }
        //else
        if (keyCode == RIGHT) {
          main_applet.controllers[Constants.JONNY][DIR_RIGHT] = true;
          player.setDirection(DIR_RIGHT);
        }
        //else
        if (keyCode == UP) {
          main_applet.controllers[Constants.JONNY][DIR_UP] = true;
          player.setDirection(DIR_UP);
        }
        if (keyCode == LEFT) {
          main_applet.controllers[Constants.JONNY][DIR_LEFT] = true;
          player.setDirection(DIR_LEFT);
        }
      }    
    }

    if (player.isActive(Constants.KENNY))
    {

      if (key == 'S' || key == 's') {
        main_applet.controllers[Constants.KENNY][DIR_DOWN] = true;
        player.setDirection(DIR_DOWN);
      }

      //else
      if (key == 'D' || key == 'd'){
        main_applet.controllers[Constants.KENNY][DIR_RIGHT] = true;
        player.setDirection(DIR_RIGHT);
      }

      //else
      if (key == 'W' || key == 'w'){
          main_applet.controllers[Constants.KENNY][DIR_UP] = true;
          player.setDirection(DIR_UP);
      }

      if (key == 'A' || key == 'a'){
        main_applet.controllers[Constants.KENNY][DIR_LEFT] = true;
        player.setDirection(DIR_LEFT);
      }
    }
  }

  void drawObjects(int camera_x, int camera_y)
  {
    for(Collectible c : oggettiCollezionabili)
    {
        c.draw(camera_x, camera_y);
    }
  }

  void testCollectObject(int player_xs, int player_xe, int player_ys, int player_ye, int currentPlayer)
  {
    for(Collectible c : oggettiCollezionabili)
    {
        if (c.isCollidingBox(player_xs, player_xe, player_ys, player_ye))
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
