import ptmx.*;

class Game extends Scene {

  Controller controller;
  ControlIO control;
  Player player;
  int walkableLayerIndex;

  // camera_x: offset dove lo sfondo inizia
  // camera_y: offset dove lo sfondo inizia

  int camera_x = 0;
  int camera_y = 0;

  static final int DIR_UP = 0;
  static final int DIR_DOWN = 1;
  static final int DIR_LEFT = 2;
  static final int DIR_RIGHT = 3;

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

  Game(float ratio) {
    super(ratio);
  }

  boolean init(PApplet instance) {
    player = new Player("test", 1);
    control = ControlIO.getInstance(instance);
    controller = new Controller(control);
    map = new Ptmx(instance, "floor1.tmx");
    walkableLayerIndex = walkableLayer();
    return (player != null && map != null);
  }

  int walkableLayer() {
    int layerindex = 0;
    int maplayer[];
    do {
      layerindex++;
      maplayer = map.getData(layerindex);
    } while (maplayer != null && !maplayer.equals("Walkable"));
    for (int x = 0; x < 10; x++) {
      for (int y = 0; y < 10; y++) {
        print(map.getTileIndex(layerindex - 1, x, y));
      }
      println("\n");
    }
    return layerindex - 1;
  }

  boolean isWalkable(int x, int y) {
    println(walkableLayerIndex);
    println(x);
    println(y);
    println(map.getTileIndex(walkableLayerIndex, x, y));
    if (map.getTileIndex(walkableLayerIndex, x, y) >= 0) {
      print("CI PUOI CAMMINARE");
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


    // textSize(8);
    // for(int nx = 0; nx < map.getMapSize().x; nx++)
    // for(int ny = 0; ny < map.getMapSize().y; ny++){
    // float px = map.mapToCam(nx, ny).x;
    // float py = map.mapToCam(nx, ny).y;
    // ellipse(px, py, 2, 2);
    // text(nx + "," + ny, px, py);
    // }


    if (controller1[DIR_LEFT] || controller2[DIR_LEFT])
      moveCamera((int)(-5.0 * ratio), 0);

    if (controller1[DIR_RIGHT] || controller2[DIR_RIGHT])
      moveCamera((int)(5.0 * ratio), 0);

    if (controller1[DIR_UP] || controller2[DIR_UP])
      moveCamera(0, (int)(-5.0 * ratio));

    if (controller1[DIR_DOWN] || controller2[DIR_DOWN])
      moveCamera(0, (int)(5.0 * ratio));

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
        controller1[DIR_DOWN] = false;
      }

      if (xoy < -0.5) {
        controller1[DIR_UP] = true;
        player.setDirection(DIR_UP);
      } else {
        controller1[DIR_UP] = false;
      }
    } else {
      if (xoy < -0.5) {
        controller1[DIR_LEFT] = true;
        player.setDirection(DIR_LEFT);
      } else {
        controller1[DIR_LEFT] = false;
      }

      if (xoy > 0.5) {
        controller1[DIR_RIGHT] = true;
        player.setDirection(DIR_RIGHT);
      } else {
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


  void moveCamera(int delta_x, int delta_y) {
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
      }

      //else
      if (keyCode == RIGHT)
        controller2[DIR_RIGHT] = false;

      //else
      if (keyCode == UP)
        controller2[DIR_UP] = false;


      if (keyCode == LEFT)
        controller2[DIR_LEFT] = false;
      //
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
  }
}