///
///Room in the maze containing a Flock, a boss Enemy or an Modifier
///
class Room{
  
  int sizeX, sizeY;
  
  int x, y;
  
  boolean[] door;
  Room[] neighbours;
  
  float percentage;
  float chance;
  
  Flock flock;
  
  boolean visited;
  
  boolean bossRoom;
  boolean hasItem;
  
  Modifier modifier;
  boolean gaveModifier;
  String lastModifierName;
  
  MessageObservable messObs;
  
  Room(int nx, int ny, int nsizeX, int nsizeY){
    
    x = nx;
    y = ny;
    sizeX = nsizeX;
    sizeY = nsizeY;
    
    percentage = 0.65;
    chance = 0.8;
    
    door = new boolean[4];
    neighbours = new Room[4];
    
    visited = false;
    
    messObs = new MessageObservable();
    
  }
  
  Room(int nx, int ny, int nsizeX, int nsizeY, float npercentage){
    
    x = nx;
    y = ny;
    sizeX = nsizeX;
    sizeY = nsizeY;
    
    percentage = npercentage - random(ROOM_PERCENTAGE_MIN_DEGRADE, ROOM_PERCENTAGE_MAX_DEGRADE);
    
    
    chance = random(1);
    
    door = new boolean[4];
    neighbours = new Room[4];
    
    messObs = new MessageObservable();
    
  }
  
  int getX(){return x;}
  int getY(){return y;}
  int getSizeX(){return sizeX;}
  int getSizeY(){return sizeY;}
  
  boolean isVisited(){return visited;}
  void visitRoom(){visited = true;}
  
  Flock getFlock(){return flock;}
  boolean roomDone(){return flock.isEmpty();}
  
  Modifier getModifier(){return modifier;}
  boolean hasTakenModifier(){return gaveModifier;}
  
  ///
  ///Notifies that the player has taken the item in the room
  ///
  void takeModifier(){
    gaveModifier = true;
    messObs.notifyObs();
    messObs.message = lastModifierName;
  }
  String getLastModifierName(){return lastModifierName;}
  
  MessageObservable getMessageObservale(){return messObs;}
  
  ///
  ///Tells if the room has more than one door (to know if a room is a dead end)
  ///
  boolean hasMultipleNeighbours(){
    
    int neighboursCount = 0;
    
    for(int i = 0; i < 4; i++){
      if(neighbours[i] != null){
        neighboursCount++;
      }
    }
    
    return neighboursCount > 1;
    
  }
  
  ///
  ///Generate its flock depending on if it is a boss room or not
  ///
  void createFlock(int amount, int level){
    
    if(bossRoom){
      flock = new Flock(0, null);
      flock.addBoss(new PVector((x + sizeX/2) * (width/VIEWPORT_GRID_RATIO), (y + sizeY/2) * (width/VIEWPORT_GRID_RATIO)), level);
    }else {
      PVector spawnPoint = new PVector((x + sizeX/2) * (width/VIEWPORT_GRID_RATIO), (y + sizeY/2) * (width/VIEWPORT_GRID_RATIO));
      flock = new Flock(amount, spawnPoint);
    }
    
    visited = false;
    
  }
  
  ///
  ///Updates the flock
  ///
  void update(float delta, PVector playerPos){
    
    flock.update(delta, playerPos);
    
  }
  
  
  
  
  ///
  ///Tells the type of the given cell
  ///
  int getType(int ox, int oy){
    
    if(ox >= x && ox < x + sizeX && oy >= y && oy < y + sizeY){
      if(ox == x + sizeX/2 && oy == y + sizeY/2 && hasItem){
        return GRID_ITEM;
      }else {
        return GRID_WALKABLE;
      }
    }else if(ox >= x - 1 && ox <= x + sizeX && oy >= y - 1 && oy <= y + sizeY){
      if(ox == x - 1 && oy == y + floor(sizeY/2) && door[DIR_LEFT]){
        return GRID_DOOR;
      }else if(ox == x + sizeX && oy == y + floor(sizeY/2) && door[DIR_RIGHT]){
        return GRID_DOOR;
      }else if(oy == y - 1 && ox == x + floor(sizeX/2) && door[DIR_UP]){
        return GRID_DOOR;
      }else if(oy == y + sizeY && ox == x + floor(sizeX/2) & door[DIR_DOWN]){
        return GRID_DOOR;
      }
      return GRID_WALL;
    }else {
      return GRID_OBSTACLE;
    }
    
  }
  
  ///
  ///Tells the type of cell by the given global position
  ///
  int getType(float x, float y){
    
    int i = floor(x/(width/VIEWPORT_GRID_RATIO));
    int j = floor(y/(width/VIEWPORT_GRID_RATIO));
    
    return getType(i, j);
    
  }
  
  ///
  ///Tells the image to be rendered on the given cell
  ///
  int getTileType(int ox, int oy){
    
    if(ox >= x && ox < x + sizeX && oy >= y && oy < y + sizeY){
      //floor
      if(ox == x + sizeX/2 && oy == y + sizeY/2 && hasItem){
        if(gaveModifier){
          return TILES_DEFAULT_ITEM_OPENED;
        }else {
          return TILES_DEFAULT_ITEM;
        }
      }else {
        return TILES_FLOOR;
      }
    }else if(ox >= x - 1 && ox <= x + sizeX && oy >= y - 1 && oy <= y + sizeY){
      
      
      //=====DOORS=====\\
      if(ox == x - 1 && oy == y + floor(sizeY/2) && door[DIR_LEFT]){
        if(roomDone()){
          if(!bossRoom){
            if(neighbours[DIR_LEFT].isBoss()){
              return TILES_LEFT_DOOR_BOSS;
            }else {
              return TILES_LEFT_DOOR;
            }
          }else {
            return TILES_LEFT_DOOR_NEXT;
          }
        }else {
          if(neighbours[DIR_LEFT].isBoss()){
            return TILES_LEFT_DOOR_LOCKED_BOSS;
          }else {
            return TILES_LEFT_DOOR_LOCKED;
          }
        }
      }else if(ox == x + sizeX && oy == y + floor(sizeY/2) && door[DIR_RIGHT]){
        if(roomDone()){
          if(!bossRoom){
            if(neighbours[DIR_RIGHT].isBoss()){
              return TILES_RIGHT_DOOR_BOSS;
            }else {
              return TILES_RIGHT_DOOR;
            }
          }else {
            return TILES_RIGHT_DOOR_NEXT;
          }
        }else {
          if(neighbours[DIR_RIGHT].isBoss()){
              return TILES_RIGHT_DOOR_LOCKED_BOSS;
            }else {
              return TILES_RIGHT_DOOR_LOCKED;
            }
        }
      }else if(oy == y - 1 && ox == x + floor(sizeX/2) && door[DIR_UP]){
        if(roomDone()){
          if(!bossRoom){
            if(neighbours[DIR_UP].isBoss()){
              return TILES_TOP_DOOR_BOSS;
            }else {
              return TILES_TOP_DOOR;
            }
          }else {
            return TILES_TOP_DOOR_NEXT;
          }
        }else {
          if(neighbours[DIR_UP].isBoss()){
            return TILES_TOP_DOOR_LOCKED_BOSS;
          }else {
            return TILES_TOP_DOOR_LOCKED;
          }
        }
      }else if(oy == y + sizeY && ox == x + floor(sizeX/2) & door[DIR_DOWN]){
        if(roomDone()){
          if(!bossRoom){
            if(neighbours[DIR_DOWN].isBoss()){
              return TILES_BOTTOM_DOOR_BOSS;
            }else {
              return TILES_BOTTOM_DOOR;
            }
          }else {
            return TILES_BOTTOM_DOOR_NEXT;
          }
        }else {
          if(neighbours[DIR_DOWN].isBoss()){
            return TILES_BOTTOM_DOOR_LOCKED_BOSS;
          }else {
            return TILES_BOTTOM_DOOR_LOCKED;
          }
        }
      }
      
      //=====CORNERS=====\\
      if(ox == x - 1 && oy == y - 1){
        //up left
        return TILES_TOPLEFT;
      }else if(ox == x + sizeX && oy == y - 1){
        //up right
        return TILES_TOPRIGHT;
      }else if(ox == x - 1 && oy == y + sizeY){
        //bottom left
        return TILES_BOTTOMLEFT;
      }else if(ox == x + sizeX && oy == y + sizeY){
        //bottom right
        return TILES_BOTTOMRIGHT;
      }
      
      //=====wALLS=====\\
      if(ox == x - 1){
        //left
        return TILES_LEFT;
      }else if(ox == x + sizeX){
        //right
        return TILES_RIGHT;
      }else if(oy == y - 1){
        //top
        return TILES_TOP;
      }else if(oy == y + sizeY){
        //bottom
        return TILES_BOTTOM;
      }
      
      
      return -1;
      
    }else {
      
      //void
      
      return -1;
    }
    
  }
  
  
  float getPercentage(){return percentage;}
  
  boolean[] getDoors(){return door;}
  boolean getDoor(int side){
    if(side >= 0 && side < 4){
      return door[side];
    }
    return false;
  }
  Room getRoom(int side){
    if(side >= 0 && side < 4){
      if(door[side]){
        return neighbours[side];
      }
    }
    return null;
  }
  
  void setDoor(int side){
    if(side >= 0 && side < 4){
      door[side] = true;
    }
  }
  void setRoom(int side, Room nroom){
    if(side >= 0 && side < 4){
      neighbours[side] = nroom;
    }
  }
  
  ///
  ///Tells if a room can be created as its neighbour depending on its success rate
  ///
  boolean canCreateRoom(){
    return percentage + random(-ROOM_PERCENTAGE_RANDOM, ROOM_PERCENTAGE_RANDOM) > chance;
  }
  
  ///
  ///Tells if a room is colliding with himself
  ///
  boolean collide(Room oroom){
    
    int ox = oroom.getX();
    int oy = oroom.getY();
    int osx = oroom.getSizeX();
    int osy = oroom.getSizeY();
    
    if(x <= ox + osx && x + sizeX >= ox){
      if(y <= oy + osy && y + sizeY >= oy){
        return true;
      }
    }
    
    
    return false;
    
  }
  
  boolean isBoss(){return bossRoom;}
  boolean hasItem(){return hasItem;}
  
  void setBoss(){
    bossRoom = true;
  }
  void setItem(){
    hasItem = true;
    if(!generateModifier()){
      println("bad item was loaded");
    }
  }
  
  ///
  ///Tells if the given global position is on a non-walkable cell
  ///
  boolean onWall(PVector opos){
    
    int ox = floor((opos.x)/(width/VIEWPORT_GRID_RATIO));
    int oy = floor(opos.y/(width/VIEWPORT_GRID_RATIO));
    
    if(ox >= x && ox < x + sizeX && oy >= y && oy < y + sizeY){
      //inside room
      return false;
    }else if(ox >= x - 1 && ox <= x + sizeX && oy >= y - 1 && oy <= y + sizeY){
      
      //on wall
      
      return true;
    }else {
      //outside room
      return false;
    }
    
  }
  
  ///
  ///Tells the side of the door if the hitBox is on a door cell
  ///
  int onDoor(PVector opos, PVector osize){
    
    if(roomDone()){
      if(onWall(opos) || onWall(new PVector(opos.x + osize.x, opos.y + osize.y))){
        
        int ox = floor(opos.x/(width/VIEWPORT_GRID_RATIO));
        int oy = floor(opos.y/(width/VIEWPORT_GRID_RATIO));
        
        int osx = floor((opos.x + osize.x)/(width/VIEWPORT_GRID_RATIO));
        int osy = floor((opos.y + osize.y)/(width/VIEWPORT_GRID_RATIO));
        
        if(ox == x - 1 && oy == y + floor(sizeY/2) && door[DIR_LEFT]){
          return DIR_LEFT;
        }else if(osx == x + sizeX && oy == y + floor(sizeY/2) && door[DIR_RIGHT]){
          return DIR_RIGHT;
        }else if(oy == y - 1 && ox == x + floor(sizeX/2) && door[DIR_UP]){
          return DIR_UP;
        }else if(osy == y + sizeY && ox == x + floor(sizeX/2) & door[DIR_DOWN]){
          return DIR_DOWN;
        }
        
      }
    }
    
    return -1;
    
  }
  
  ///
  ///Tells if a hitBox is hitting a non-walkable cell
  ///
  boolean[] sideOnWall(PVector pos, PVector size){
    
    boolean[] hitSides = new boolean[4];
    
    if(onWall(new PVector(pos.x, pos.y)) && onWall(new PVector(pos.x, pos.y + size.y))){
      hitSides[DIR_LEFT] = true;
    }
    if(onWall(new PVector(pos.x, pos.y)) && onWall(new PVector(pos.x + size.x, pos.y))){
      hitSides[DIR_UP] = true;
    }
    if(onWall(new PVector(pos.x + size.x, pos.y)) && onWall(new PVector(pos.x + size.x, pos.y + size.y))){
      hitSides[DIR_RIGHT] = true;
    }
    if(onWall(new PVector(pos.x, pos.y + size.y)) && onWall(new PVector(pos.x + size.x, pos.y + size.y))){
      hitSides[DIR_DOWN] = true;
    }
    
    
    return hitSides;
    
  }
  
  ///
  ///Render its flock
  ///
  void show(ViewPort view){
    
    flock.show(view);
    
  }
  
  
  
  ///
  ///Loads a modifier file and creates a new modifier from it
  ///
  boolean generateModifier(){
    
    int fileIndex = int(random(ITEM_AMOUNT))+1;
    //fileIndex = 26;
    modifier = new Modifier();
    
    //LOAD MAIN JSON
    JSONObject json;
    try{
      json = loadJSONObject("data/items/item" + fileIndex + ".json");
    }catch(NullPointerException e){
      return false;
    }
    
    if(json != null){
      
      boolean upgrade = json.getBoolean("upgrade");
      lastModifierName = json.getString("name");
      
      //LOAD CHILD
      JSONObject Att = json.getJSONObject("Attributes");
      JSONObject Val = json.getJSONObject("Values");
      JSONObject Pla = json.getJSONObject("Player");
      
      
      //LOAD VALUES
      if(Val != null){
        
        for(int i = 0; i < ValuesModifiers.values().length; i++){
          
          String argument = ValuesModifiers.values()[i].toString();
          
          try{
            
            float mod = Val.getFloat(argument);
            modifier.getValueMods()[ValuesModifiers.valueOf(argument).ordinal()] = mod;
            
          }catch(NullPointerException e){}
          
        }
        
      }
      
      
      //LOAD ATTRIBUTES
      if(Att != null){
        
        for(int i = 0; i < AttributesModifiers.values().length; i++){
          
          String argument = AttributesModifiers.values()[i].toString();
          
          try{
            
            boolean mod = Att.getBoolean(argument);
            modifier.getAttributeMods()[AttributesModifiers.valueOf(argument).ordinal()] = mod;
            
          }catch(NullPointerException e){}
          
        }
        
      }
      
      
      //LOAD PLAYER VALUES
      if(Pla != null){
        
        for(int i = 0; i < PlayerModifiers.values().length; i++){
          
          String argument = PlayerModifiers.values()[i].toString();
          
          try{
            
            float mod = Pla.getFloat(argument);
            modifier.getPlayerMods()[PlayerModifiers.valueOf(argument).ordinal()] = mod;
            
          }catch(NullPointerException e){}
          
        }
        
      }
      
      modifier.setUpgrade(upgrade);
      
      return true;
      
    }else {
      return false;
    }
    
  }
  
  
}  
