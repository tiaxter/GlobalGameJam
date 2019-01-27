import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 
import org.gamecontrolplus.gui.*; 
import org.gamecontrolplus.*; 
import net.java.games.input.*; 
import ptmx.*; 
import java.awt.Dimension; 
import processing.video.*; 
import java.lang.Math; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GlobalGameJam extends PApplet {



float ratio = 0.0f;

Scene scenes[] = { null, null, null, null};
SoundFile music;

final int FADEOUT_TIME_MS = 1000;

int currentScene;
int target_scene;

boolean fade = false;
float screen_x = 0.0f;


PFont myfont;

public void setup()
{
    background(0);

    myfont = createFont("Pixelmania.ttf", 50);
    textFont(myfont);

    
    ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);

    scenes[Constants.MENU_SCENE] = new Menu(ratio);
    scenes[Constants.GAME_TOPFLOOR] = new Game(ratio, "Levels/Placeholder/What.tmx", Constants.GAME_TOPFLOOR);
    scenes[Constants.GAME_GROUNDFLOOR] = new Game(ratio, "Levels/PianoT/PianoT.tmx", Constants.GAME_GROUNDFLOOR);
    scenes[Constants.GAME_OVER] = new GameOver(ratio);

    if (!(scenes[Constants.MENU_SCENE].init(this) && 
          scenes[Constants.GAME_GROUNDFLOOR].init(this) && 
          scenes[Constants.GAME_TOPFLOOR].init(this) &&
          scenes[Constants.GAME_OVER].init(this)))
    {
      print("Error initializing scenes!");
      System.exit(-1);
    }
    currentScene = Constants.MENU_SCENE;

    music = new SoundFile(this, "Sounds/RumoreBiancoCasa.wav");
    music.amp(0.5f);
    music.loop();

}

public void transition(int nextScene)
{
  if (!fade)
  {
    fade = true;
    target_scene = nextScene;
    screen_x = - Constants.SCREEN_W;

  }
}


public void draw()
{


    // ratio = min((float)this.width / Constants.SCREEN_W, (float )this.height / Constants.SCREEN_H);
    // if (ratio < 1.0)
    // {
    //     //scale(3.0);
    //     //translate(((float)width - Constants.SCREEN_W * ratio) / 2.0, ((float)height - Constants.SCREEN_H * ratio / 2.0));
    // }

    fill(255,255);
    scenes[currentScene].draw();

    if (fade)
    {
      screen_x += 40.0f;
      fill(50,255);
      rect(screen_x, 0, width, height);

      if (screen_x > 0)
      {
        currentScene = target_scene;
        scenes[currentScene].reset();
      }

      if (screen_x > width)
      {
        fade = false;
        scenes[currentScene].endTransition();
      }

    }

}


public void keyReleased()
{
  scenes[currentScene].keyReleased();
}

public void keyPressed()
{
  scenes[currentScene].keyPressed();
}
// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  Frames[] frames;
  int currentDirection;
  int nframes;
  String prefissofile;
  int frame = 0;
  int imageCount = 1;
  int xpos, ypos;

  Animation(String prefisso, int nframes) {
    frames = new Frames[5];
    for(int i = 0; i < 5; i++){
      switch(i){
        case 0:
          frames[i] = new Frames(prefisso + "_down_", nframes, 100);
          break;
        case 1:
          frames[i] = new Frames(prefisso + "_up_", nframes, 100);
          break;
        case 2:
          frames[i] = new Frames(prefisso + "_left_", nframes, 100);
          break;
        case 3:
          frames[i] = new Frames(prefisso + "_right_", nframes, 100);
          break;
        case 4:
          frames[i] = new Frames(prefisso, nframes, 500);
          break;

      }
    }
    this.nframes = nframes;
    this.prefissofile = prefisso;
    this.images = new PImage[nframes];

    updateDirection(3);
  }

  public void updateDirection(int dir){

    currentDirection = dir;

  }

  public void display(float x, float y) {
    frames[currentDirection].display(x, y);
  }

}
class Collectible{
  float absx;
  float absy;
  float mapx;
  float mapy;
  int collectible_type;
  boolean picked;
  PImage image;

  Collectible(float absx, float absy, float mapx, float mapy, int collectible_type, boolean picked){
    this.absx = absx;
    this.absy = absy;
    this.mapx = mapx;
    this.mapy = mapy;
    this.collectible_type = collectible_type;
    this.picked = picked;
    this.image = loadImage("icon.png");
  }

  public @Override
  String toString(){
    return "Absolute X : " + absx + "\nAbsolute Y: " + absy +
    "\nMap X : " + mapx + "\nMap Y : " + mapy +
    "\nTipo di oggetto : " + collectible_type;
  }

  public void draw(int camera_x, int camera_y)
  {
    if (!picked)
    {
      image(image, this.absx - camera_x, this.absy - camera_y);
    }
  }

  public boolean isColliding(int player_x, int player_y)
  {
    return player_x == this.mapx && player_y == this.mapy; 
  }

  public void setPicked(boolean p)
  {
    this.picked = p;
  }

}

class Constants{
  
static final int SCREEN_W = 2048;
static final int SCREEN_H = 1080;


static final int LEVEL_W = 2048*2;
static final int LEVEL_H = 1080*2;


static final int MENU_SCENE = 0;
static final int GAME_TOPFLOOR = 1;
static final int GAME_GROUNDFLOOR = 2;
static final int GAME_OVER = 3;


static final int  PLAYER_WIDTH = 192;
static final int  PLAYER_HEIGHT = 192;

static final int VIDEO_W = 1280;
static final int VIDEO_H = 720;

};




 class Controller{
  ControlDevice stick;
  ControlIO control;

  Controller(ControlIO control){
    this.control = control;
    stick = control.getMatchedDeviceSilent("xb360");
  }

  public boolean Apressed(){
    return stick.getButton("Green").pressed();
  }

  public boolean Xpressed(){
    return stick.getButton("Blue").pressed();
  }

   public boolean Ypressed(){
    return stick.getButton("Yellow").pressed();
  }

   public boolean Bpressed(){
    return stick.getButton("Red").pressed();
  }

   public boolean LBpressed(){
    return stick.getButton("LB").pressed();
  }

   public boolean RBpressed(){
    return stick.getButton("RB").pressed();
  }

   public boolean BackPressed(){
    return stick.getButton("Back").pressed();
  }

   public boolean StartPressed(){
    return stick.getButton("Start").pressed();
  }

   public float LeftAnalogX(){
    return stick.getSlider("LeftAnalogX").getValue();
  }

   public float LeftAnalogY(){
    return stick.getSlider("LeftAnalogY").getValue();
  }

   public float RightAnalogX(){
    return stick.getSlider("RightAnalogX").getValue();
  }

   public float RightAnalogY(){
    return stick.getSlider("RightAnalogY").getValue();
  }

}
class Door
{
  float absx;
  float absy;
  float mapx;
  float mapy;
  boolean opened;
  PImage image;

  Door(float absx, float absy, float mapx, float mapy, boolean opened){
    this.absx = absx;
    this.absy = absy;
    this.mapx = mapx;
    this.mapy = mapy;
    this.opened = opened;
    this.image = loadImage("icon.png");
  }

  public @Override
  String toString(){
    return "Absolute X : " + absx + "\nAbsolute Y: " + absy +
    "\nMap X : " + mapx + "\nMap Y : " + mapy +
    "\nPorta aperta: " + opened;
  }

  public void draw(int camera_x, int camera_y)
  {
    if (!opened)
    {
      image(image, this.absx - camera_x, this.absy - camera_y);
    }
  }

  public boolean isColliding(int grid_x, int grid_y)
  {
    return grid_x == this.mapx && grid_y == this.mapy; 
  }

  public void setOpened(boolean p)
  {
    this.opened = p;
  }

}
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

  public boolean isPlayerOverArea(int player_x, int player_y)
  {
    return (player_x >= x_start && player_x <= x_end && player_y >= y_start && player_y <= y_end);
  }

  public boolean isGameOver(int player_x, int player_y)
  {
      return isPlayerOverArea(player_x, player_y);
  }
  
  public String toString()
  {
    return ("Exit @ {" + x_start + ", " + y_start + ", " + x_end + ", " + y_end + "}" );
  }

}
class Frames{

  int PLAYER_ANIM_RATE;
  PImage images[];
  int frame = 0;
  int numero_frames;
  float time;
  float delta_time;

  Frames(String nome, int numero_frames, int rate){
    this.numero_frames = numero_frames;
    images = new PImage[numero_frames];
    for(int i=0; i< numero_frames; i++){
      images[i] = loadImage(nome + i + ".png");
    }
    PLAYER_ANIM_RATE = rate;
    time = millis();

  }

  public void display(float x, float y) {

    delta_time += millis() - time;    
    if (delta_time > PLAYER_ANIM_RATE)
    {
      frame = (frame+1) % numero_frames;   
      delta_time = 0.0f;   
    }
    time = millis();

    image(images[frame], x, y);
  }

}



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

  static final int START_X_GROUNDFLOOR = Constants.PLAYER_WIDTH * 3;
  static final int START_Y_GROUNDFLOOR = Constants.PLAYER_HEIGHT * 3;


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

  public boolean init(PApplet instance) {
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
    paused = false;

    return (player != null && map != null);
  }

  public void endTransition()
  {}

  public void reset()
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

    paused = false;
    accept_inputs = true;
  }

  public int searchLayer(String str) {
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

  /*int[]*/ public void pupPosition(){
  for(int i = 0; i < map.getMapSize().x; i++){
      for(int j = 0; j < map.getMapSize().y; j++){
        if(map.getTileIndex(walkableLayerIndex, i, j) > 0 && map.getTileIndex(walkableLayerIndex, i, j) < 10 ){
          oggettiCollezionabili.add(new Collectible((i*map.getTileSize().x),(j*map.getTileSize().y),i, j, PuP + map.getTileIndex(walkableLayerIndex, i, j), false));
        }
      }
    }

    for(Collectible c: oggettiCollezionabili){
      println(c.toString());
    }
  }


public void searchExitPositions() {
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

public void stairPositions() {
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



  public boolean isWalkable(int x, int y) {
    if (map.getTileIndex(walkableLayerIndex, x, y) >= 0) {
      return true;
    }
    return false;
  }

  public int getPlayerTileX() {
    return (int)(player.x / map.getTileSize().x);
  }

  public int getPlayerTileY() {
    return (int)(player.y / map.getTileSize().y);
  }

  public void draw() {

    try {
      setDirection(String.valueOf(controller.LeftAnalogX()), true, false);
      setDirection(String.valueOf(controller.LeftAnalogY()), false, false);
      setDirection(String.valueOf(controller.RightAnalogX()), true, true);
      setDirection(String.valueOf(controller.RightAnalogY()), false, true);

      if (controller.BackPressed())
      {
        main_applet.transition(Constants.MENU_SCENE);
      }
      if (controller.StartPressed())
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
    player.draw(camera_x, camera_y);


    if (paused)
    {
      fill(100,50);
      rect(0,0,width,height);
      fill(255,255);
      text("PAUSE", 100, 100);
    }

    if (controller1[DIR_LEFT])
      moveCamera((int)(-10.0f * ratio), 0, 0);

    if (controller2[DIR_LEFT])
      moveCamera((int)(-10.0f * ratio), 0, 1);


    if (controller1[DIR_RIGHT])
      moveCamera((int)(10.0f * ratio), 0, 0);

    if(controller2[DIR_RIGHT])
      moveCamera((int)(10.0f * ratio), 0, 1);


    if (controller1[DIR_UP])
     moveCamera(0, (int)(-10.0f * ratio), 0);

     if( controller2[DIR_UP])
      moveCamera(0, (int)(-10.0f * ratio), 1);

    if (controller1[DIR_DOWN])
      moveCamera(0, (int)(10.0f * ratio), 0);

    if(controller2[DIR_DOWN])
      moveCamera(0, (int)(10.0f * ratio), 1);

  }

public void setDirection(String dir, boolean x, boolean right) {
    float xoy;
    try {
      xoy = Float.valueOf(dir);
    } catch (Exception e) {
      xoy = 0;
    }

    if(!right){
      if (!x) {
        if (xoy > 0.5f) {
          controller1[DIR_DOWN] = true;
          player.setDirection(DIR_DOWN);
        } else {
          if (controller1[DIR_DOWN] == true)
            player.setDirection(DIR_IDLE);

          controller1[DIR_DOWN] = false;
        }

        if (xoy < -0.5f) {
          controller1[DIR_UP] = true;
          player.setDirection(DIR_UP);
        } else {
          if (controller1[DIR_UP] == true)
            player.setDirection(DIR_IDLE);

          controller1[DIR_UP] = false;
        }
      } else {
        if (xoy < -0.5f) {
          controller1[DIR_LEFT] = true;
          player.setDirection(DIR_LEFT);
        } else {
          if (controller1[DIR_LEFT] == true)
            player.setDirection(DIR_IDLE);

          controller1[DIR_LEFT] = false;
        }

        if (xoy > 0.5f) {
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
        if (xoy > 0.5f) {
          controller2[DIR_DOWN] = true;
          player.setDirection(DIR_DOWN);
        } else {
          if (controller2[DIR_DOWN] == true)
            player.setDirection(DIR_IDLE);

          controller2[DIR_DOWN] = false;
        }

        if (xoy < -0.5f) {
          controller2[DIR_UP] = true;
          player.setDirection(DIR_UP);
        } else {
          if (controller2[DIR_UP] == true)
            player.setDirection(DIR_IDLE);

          controller2[DIR_UP] = false;
        }
      } else {
        if (xoy < -0.5f) {
          controller2[DIR_LEFT] = true;
          player.setDirection(DIR_LEFT);
        } else {
          if (controller2[DIR_LEFT] == true)
            player.setDirection(DIR_IDLE);

          controller2[DIR_LEFT] = false;
        }

        if (xoy > 0.5f) {
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


  public int getTileMapWidth() {
    return (int)(map.getTileSize().x * map.getMapSize().x);
  }

  public int getTileMapHeight() {
    return (int)(map.getTileSize().y * map.getMapSize().y);
  }

  public void setPaused(boolean paused)
  {
    this.paused = paused;
    player.setPaused(paused);
  }

  public void moveCamera(int delta_x, int delta_y, int movement_player) {

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

      testCollectObject(next_player_tile_x, next_player_tile_y, player.currentPlayer);
    }
  }

  public void keyReleased() {
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

  public void keyPressed() {

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

  public void drawObjects(int camera_x, int camera_y)
  {
    for(Collectible c : oggettiCollezionabili)
    {
        c.draw(camera_x, camera_y);
    }
  }

  public void testCollectObject(int player_x, int player_y, boolean currentPlayer)
  {
    for(Collectible c : oggettiCollezionabili)
    {
        if (c.isColliding(player_x, player_y))
        {
            c.setPicked(true);
            handlePickedObject(c.collectible_type, currentPlayer);
        }
    }
  }

  public void handlePickedObject(int collectible_id, boolean currentPlayer)
  {
      if(currentPlayer)
        println("Raccolto elemento " + collectible_id + " da Jonny");
      else
        println("Raccolto elemento " + collectible_id + " da Kenny");
  }


  public boolean isDoorClosed(int x, int y)
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
class GameOver extends Scene
{
  GlobalGameJam instance;

  GameOver(float ratio) {super(ratio);}
  public boolean init(PApplet instance) { this.instance = (GlobalGameJam)instance; return true;}
  public void draw(){
    background(0);

    text("WHAT A LAME GAME OVER", 100, 100);

  }
  public void keyPressed()
  {


  }
  
  public void endTransition()
  {}
  
  public void reset()
  {

  }

  public void keyReleased(){    
    instance.transition(Constants.MENU_SCENE);
  }


}
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

  public @Override
  boolean isGameOver(int player_x, int player_y)
  { 
      return (player_x == x_end) && (player_y == y_end);
  }

  public String toString()
  {
    return ("Ladder @ {" + x_start + ", " + y_start + ", " + x_end + ", " + y_end + ","  + x_exit + ", " + y_exit  + "}" );
  }

}

Movie firstVideo;  
Movie secondVideo;  

int moviePlaying;

class Menu extends Scene
{
  GlobalGameJam instance;

  Menu(float ratio) {
    super(ratio);
    moviePlaying = 0;
  }
  
  public boolean init(PApplet instance) 
  {
    this.instance = (GlobalGameJam)instance; 
    firstVideo= new Movie(instance, "Video\\Transition.mp4")
    {
      @Override
      public void eosEvent()
      {
        super.eosEvent();
        firstVideoCompleted();
      }
    };

    secondVideo = new Movie(instance, "Video\\Transformation.mp4");
    reset();
    return true;
  }

  public void reset()
  {
    moviePlaying = 0;
    firstVideo.play();
    moviePlaying = 1;

  }

  public void firstVideoCompleted()
  {
    firstVideo.stop();
    secondVideo.loop();
    moviePlaying = 2;
  }
  
  
  public void draw(){

    background(0);
    
    pushMatrix();
    //scale(ratio);
    translate(((float)instance.width - Constants.VIDEO_W) / 2.0f, (((float)instance.height - Constants.VIDEO_H)/ 2.0f));

    if (moviePlaying == 1)
    {
      if (firstVideo.available())
        firstVideo.read();
      image(firstVideo, 0, 0);
    }
    else if (moviePlaying == 2)
    {
      if (secondVideo.available())
        secondVideo.read();
      image(secondVideo, 0, 0);
    }
    
    text("WHAT A LAME MENU", 100, 100);

    popMatrix();    
  }
  
  public void endTransition()
  {
    println("End transition menu");
  }

  public void keyPressed()
  {
    secondVideo.stop();
    firstVideo.stop();
  }

  public void keyReleased(){
    println("Starting transition...");
    moviePlaying = 0;
    instance.transition(Constants.GAME_GROUNDFLOOR);

  }


}


final int PLAYER_TIME_SLOT = 3000;

class Player{

  Animation animation_jonny;
  Animation animation_kenny;

  int direction;
  boolean paused;

  float x;
  float y;

  float time = 0;
  float delta_time = 0.0f;

  SoundFile steps_jonny[];
  SoundFile steps_kenny[];

  SoundFile currentStepSound;

  // Used to switch between the players
  boolean currentPlayer = true;

  Player(PApplet instance){
    animation_jonny = new Animation("Sprites\\Kenny\\P2_move", 5);
    animation_kenny = new Animation("Sprites\\Jonny\\P1_move", 5);

    loadSounds(instance);

    direction = Game.DIR_IDLE;
    animation_jonny.updateDirection(Game.DIR_IDLE);
    animation_kenny.updateDirection(Game.DIR_IDLE);
    time = millis();
    paused = false;
  }

  public void loadSounds(PApplet instance)
  {
      steps_jonny = new SoundFile[4];
      steps_kenny = new SoundFile[4];

      steps_jonny[0] = new SoundFile(instance, "Sounds\\passi_bambino_4.wav");
      steps_jonny[1] = new SoundFile(instance, "Sounds\\passi_bambino_3_01.wav");
      steps_jonny[2] = new SoundFile(instance, "Sounds\\passi_bambino_2.wav");
      steps_jonny[3] = new SoundFile(instance, "Sounds\\passi_bambino_1.wav");

      steps_kenny[0] = new SoundFile(instance, "Sounds\\passi_bambino_distorto_4.wav");
      steps_kenny[1] = new SoundFile(instance, "Sounds\\passi_bambino_distorto_3.wav");
      steps_kenny[2] = new SoundFile(instance, "Sounds\\passi_bambino_distorto_2.wav");
      steps_kenny[3] = new SoundFile(instance, "Sounds\\passi_bambino_distorto_1.wav");
  }

  public void updateStepSound()
  {
    if (direction != Game.DIR_IDLE)
    {
      if ((currentStepSound != null && !currentStepSound.isPlaying()) || currentStepSound == null)
      {
        int rand_step = (int)(Math.random() * 10) % 4;
        if (currentPlayer)
          currentStepSound = steps_jonny[rand_step];
        else 
          currentStepSound = steps_kenny[rand_step];
     
        currentStepSound.play();
      }
    }

  }

  public void setPaused(boolean paused)
  {
    this.paused = paused;
    if(!paused)
    {
      time = millis();
    }
  }

  public void setPosition(int x, int y)
  {
    this.x = x;
    this.y = y;
  }

  public boolean isActive(int currPlayer)
  {
    return (currPlayer == 1 && currentPlayer) || (currPlayer == 0 && !currentPlayer);

  }

  public void setDirection(int dir) {
    
      if (paused)
        return;

      direction = dir;

     if (currentPlayer)
      {
        animation_jonny.updateDirection(dir);
      }
      else
      {
        animation_kenny.updateDirection(dir);
      }
  }

  public void move(int delta_x, int delta_y, int levelW, int levelH)
  {
    if (this.x + delta_x >= 0 && this.x + delta_x < levelW  - Constants.PLAYER_WIDTH)
      this.x += delta_x;

    if (this.y + delta_y >= 0 && this.y + delta_y <  levelH - Constants.PLAYER_HEIGHT)
      this.y += delta_y;
  }

public float[] simulateMove(int delta_x, int delta_y, int levelW, int levelH){
  float x = this.x;
  float y = this.y;

  if (x + delta_x >= 0 && x + delta_x < levelW - Constants.PLAYER_WIDTH)
    x += delta_x;

  if (y + delta_y >= 0 && y + delta_y <  levelH - Constants.PLAYER_HEIGHT)
    y += delta_y;
  
  return new float[] {x, y};

}

  public void draw(int camera_x, int camera_y)
  {
    double timer = Math.round(((PLAYER_TIME_SLOT - delta_time) / 1000.0f) * 10d) / 10d;

    if(!paused)
    {
      fill(0,255);
      text(String.valueOf(timer), 54, 54);
      fill(255,255);
      text(String.valueOf(timer), 50, 50);
    
      delta_time += millis() - time;    
      updateStepSound();
    }

    if (delta_time > PLAYER_TIME_SLOT)
    {
      currentPlayer = !currentPlayer;   
      setDirection(Game.DIR_IDLE);
      delta_time = 0.0f;   
    }
    time = millis();

    if (currentPlayer)
    {
      animation_jonny.display((this.x - camera_x), (this.y - camera_y));
    }
    else 
    {
      animation_kenny.display((this.x - camera_x), (this.y - camera_y));
    }
  }
}
class Scene
{
  float ratio = 0.0f;
  Scene(float r) {ratio = r;}
  public boolean init(PApplet instance) { return true;}
  public void draw() {}
  public void keyPressed(){}
  public void keyReleased(){}
   public void reset(){}
   public void endTransition() {}
};
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GlobalGameJam" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
