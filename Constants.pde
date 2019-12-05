final float FRAME_RATE = 60;
final float FRAME_DELTA = 1000/FRAME_RATE;

final PVector GRAVITY = new PVector(0, 1);
final PVector WIND = new PVector(0, 0);
final float AIR_DENSITY = 0.97;


final float PIXEL_TO_METER = 100;


final boolean DEBUG = false;
final boolean SV_CHEAT = true;

//=====TILES=====\\

static int TILES_VOID = -1;

static int TILES_TOP = 0;
static int TILES_BOTTOM = 1;
static int TILES_LEFT = 2;
static int TILES_RIGHT = 3;

static int TILES_TOPLEFT = 4;
static int TILES_TOPRIGHT = 5;
static int TILES_BOTTOMRIGHT = 6;
static int TILES_BOTTOMLEFT = 7;

static int TILES_FLOOR = 8;

static int TILES_TOP_DOOR = 9;
static int TILES_BOTTOM_DOOR = 10;
static int TILES_LEFT_DOOR = 11;
static int TILES_RIGHT_DOOR = 12;

static int TILES_TOP_DOOR_LOCKED = 13;
static int TILES_BOTTOM_DOOR_LOCKED = 14;
static int TILES_LEFT_DOOR_LOCKED = 15;
static int TILES_RIGHT_DOOR_LOCKED = 16;

static int TILES_TOP_DOOR_NEXT = 17;
static int TILES_BOTTOM_DOOR_NEXT = 18;
static int TILES_LEFT_DOOR_NEXT = 19;
static int TILES_RIGHT_DOOR_NEXT = 20;

static int TILES_DEFAULT_ITEM = 21;
static int TILES_DEFAULT_ITEM_OPENED = 22;

static int TILES_TOP_DOOR_LOCKED_BOSS = 23;
static int TILES_BOTTOM_DOOR_LOCKED_BOSS = 24;
static int TILES_LEFT_DOOR_LOCKED_BOSS = 25;
static int TILES_RIGHT_DOOR_LOCKED_BOSS = 26;

static int TILES_TOP_DOOR_BOSS = 27;
static int TILES_BOTTOM_DOOR_BOSS = 28;
static int TILES_LEFT_DOOR_BOSS = 29;
static int TILES_RIGHT_DOOR_BOSS = 30;

//=====GRID=====\\

final int GRID_WALKABLE = 0;
final int GRID_OBSTACLE = 1;
final int GRID_WALL = 2;
final int GRID_BOSS_WALL = 3;
final int GRID_DOOR = 4;
final int GRID_ITEM = 5;

final int GRID_RATIO = 15;

final int[] DIRX = {2, -2, 0, 0};
final int[] DIRY = {0, 0, 2, -2};

//DIRECTION OF DOOR IN A ROOM
final int[] DIR = {0, 1, 2, 3};
final int[] DIR_MIRROR = {1, 0, 3, 2};

final int DIR_RIGHT = 0;
final int DIR_LEFT = 1;
final int DIR_DOWN = 2;
final int DIR_UP = 3;


float TILE_SIZE_PIXELS;


//=====ROOMS=====\\

final int ROOM_MIN_SIZE = 3;
final int ROOM_MAX_SIZE = 12;


final float ROOM_PERCENTAGE_MIN_DEGRADE = 0.01;
final float ROOM_PERCENTAGE_MAX_DEGRADE = 0.05;

final float ROOM_PERCENTAGE_RANDOM = 0.1;


final int ROOM_MIN_AMOUNT = 10;
final int ROOM_MAX_AMOUNT = 100;


//=====VIEWPORT=====\\

final float VIEWPORT_GRID_WIDTH = 8;
final float VIEWPORT_GRID_HEIGHT = 4.5;


final float VIEWPORT_GRID_RATIO = 14;


//=====PLAYER=====\\


final float PLAYER_MAX_SPEED = 50;
final float PLAYER_ACC_SPEED = 500;

final int PLAYER_STARTING_HEALTH = 6;



//=====PROJECTILES=====\\



final int ITEM_AMOUNT = 26;


final int PROJECTILE_PLAYER = 0;
final int PROJECTILE_ENEMY = 1;
final int PROJECTILE_OMNI = 2;


final float PROJECTILE_SIZE_RATIO = 50;



//=====FADER=====\\

final float FADER_SPEED = 05;
final float FADER_STOP = 1000;
