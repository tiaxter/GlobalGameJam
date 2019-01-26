import ptmx.*;

class Game extends Scene {
  ArrayList<Collectible> oggettiCollezionabili = new ArrayList<Collectible>();
  static final int PuP = 3;

  Controller controller;
  ControlIO control;
  Player player;
  int walkableLayerIndex;

  int camera_x = 0;
  int camera_y = 0;

  String mapName;
  
  static final int DIR_UP = 1;
  static final int DIR_DOWN = 0;
  static final int DIR_LEFT = 2;
  static final int DIR_RIGHT = 3;
  static final int DIR_IDLE = 4;


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

  Ptmx map;

  Game(float ratio, String map) {
    super(ratio);
    this.mapName = map;
  }

  boolean init(PApplet instance) {
    player = new Player("test", 1);
    control = ControlIO.getInstance(instance);
    controller = new Controller(control);
    map = new Ptmx(instance, mapName);
    walkableLayerIndex = walkableLayer();
    pupPosition();
    return (player != null && map != null);
  }

  int walkableLayer() {
    int layerindex = 0;
    int maplayer[];
    do {
      layerindex++;
      maplayer = map.getData(layerindex);
    } while (maplayer != null && !maplayer.equals("Walkable"));
    return layerindex - 1;
  }

  /*int[]*/ void pupPosition(){
  for(int i = 0; i < map.getMapSize().x; i++){
      for(int j = 0; j < map.getMapSize().y; j++){
        if(map.getTileIndex(walkableLayerIndex, i, j) == 3){
          oggettiCollezionabili.add(new Collectible((i*map.getTileSize().x),(j*map.getTileSize().y),i, j, PuP, false));
          //println("Un regalo per te in pos x = " + i + "y = "+ j);
        }
      }
    }
    for(Collectible c: oggettiCollezionabili){
      println(c.toString());
    }
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
    } catch (Exception e) {
      //print(e);

    }

    imageMode(CORNER);

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

    if (!player.isActive(movement_player))
      return;

    float xy[] = player.simulateMove(delta_x, delta_y, getTileMapWidth(), getTileMapHeight());
    if (isWalkable((int)(xy[0] / map.getTileSize().x), (int)(xy[1] / map.getTileSize().y))) {
      player.move(delta_x, delta_y, getTileMapWidth(), getTileMapHeight());

      if (player.x >= Constants.SCREEN_W / 2 && player.x < getTileMapWidth() - Constants.SCREEN_W / 2) {
        camera_x = camera_x + delta_x;
      }

      if (player.y >= Constants.SCREEN_H / 2 && player.y < getTileMapHeight() - Constants.SCREEN_H / 2) {
        camera_y = camera_y + delta_y;
      }

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
