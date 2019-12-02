static class RoomTileSet{
  
  static PImage[] images;
  
  static int tileSizeX;
  static int tileSizeY;
  
  static void generate(PApplet app){
    
    images = new PImage[21];
    
    images[TILES_BOTTOM] = app.loadImage("gfx/rooms/walls/bottomwall.png");
    images[TILES_TOP] = app.loadImage("gfx/rooms/walls/topwall.png");
    images[TILES_RIGHT] = app.loadImage("gfx/rooms/walls/rightwall.png");
    images[TILES_LEFT] = app.loadImage("gfx/rooms/walls/leftwall.png");
    
    images[TILES_BOTTOMLEFT] = app.loadImage("gfx/rooms/walls/bottomleft.png");
    images[TILES_BOTTOMRIGHT] = app.loadImage("gfx/rooms/walls/bottomright.png");
    images[TILES_TOPLEFT] = app.loadImage("gfx/rooms/walls/topleft.png");
    images[TILES_TOPRIGHT] = app.loadImage("gfx/rooms/walls/topright.png");
    
    images[TILES_BOTTOM_DOOR] = app.loadImage("gfx/rooms/walls/bottomdoor.png");
    images[TILES_TOP_DOOR] = app.loadImage("gfx/rooms/walls/topdoor.png");
    images[TILES_RIGHT_DOOR] = app.loadImage("gfx/rooms/walls/rightdoor.png");
    images[TILES_LEFT_DOOR] = app.loadImage("gfx/rooms/walls/leftdoor.png");
    
    images[TILES_BOTTOM_DOOR_LOCKED] = app.loadImage("gfx/rooms/walls/bottomdoorclosed.png");
    images[TILES_TOP_DOOR_LOCKED] = app.loadImage("gfx/rooms/walls/topdoorclosed.png");
    images[TILES_RIGHT_DOOR_LOCKED] = app.loadImage("gfx/rooms/walls/rightdoorclosed.png");
    images[TILES_LEFT_DOOR_LOCKED] = app.loadImage("gfx/rooms/walls/leftdoorclosed.png");
    
    images[TILES_BOTTOM_DOOR_NEXT] = app.loadImage("gfx/rooms/walls/bottomdoornext.png");
    images[TILES_TOP_DOOR_NEXT] = app.loadImage("gfx/rooms/walls/topdoornext.png");
    images[TILES_RIGHT_DOOR_NEXT] = app.loadImage("gfx/rooms/walls/rightdoornext.png");
    images[TILES_LEFT_DOOR_NEXT] = app.loadImage("gfx/rooms/walls/leftdoornext.png");
    
    images[TILES_FLOOR] = app.loadImage("gfx/rooms/walls/floor.png");
    
    tileSizeX = images[TILES_FLOOR].width;
    tileSizeY = images[TILES_FLOOR].height;
    
  }
  
  static int getFrameAmount(){return images.length;}
  
  static PImage getTile(int index){return getImage(index);}
  
  static PImage getImage(int index){
    if(images != null){
      if(index >= 0 && index < images.length){
        return images[index];
      }
    }
    return null;
  }
  
  static int getImageWidth(){return tileSizeX;}
  static int getImageHeight(){return tileSizeY;}
  
}
