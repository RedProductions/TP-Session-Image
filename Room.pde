class Room{
  
  int sizeX, sizeY;
  
  int x, y;
  
  boolean[] door;
  Room[] neighbours;
  
  float percentage;
  float chance;
  
  Flock flock;
  
  boolean bossRoom;
  
  Room(int nx, int ny, int nsizeX, int nsizeY){
    
    x = nx;
    y = ny;
    sizeX = nsizeX;
    sizeY = nsizeY;
    
    percentage = 0.65;
    chance = 0.8;
    
    door = new boolean[4];
    neighbours = new Room[4];
    
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
    
  }
  
  int getX(){return x;}
  int getY(){return y;}
  int getSizeX(){return sizeX;}
  int getSizeY(){return sizeY;}
  
  Flock getFlock(){return flock;}
  
  
  void createFlock(int amount, int level){
    
    if(bossRoom){
      flock = new Flock(0, null);
      flock.addBoss(new PVector((x + sizeX/2) * (width/VIEWPORT_GRID_RATIO), (y + sizeY/2) * (width/VIEWPORT_GRID_RATIO)), level);
    }else {
      PVector spawnPoint = new PVector((x + sizeX/2) * (width/VIEWPORT_GRID_RATIO), (y + sizeY/2) * (width/VIEWPORT_GRID_RATIO));
      flock = new Flock(amount, spawnPoint);
    }
    
  }
  
  
  void update(float delta, PVector playerPos){
    
    flock.update(delta, playerPos);
    
  }
  
  
  boolean roomDone(){return flock.isEmpty();}
  
  
  
  int getType(int ox, int oy){
    
    if(ox >= x && ox < x + sizeX && oy >= y && oy < y + sizeY){
      return GRID_WALKABLE;
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
  
  int getTileType(int ox, int oy){
    
    if(ox >= x && ox < x + sizeX && oy >= y && oy < y + sizeY){
      //floor
      return TILES_FLOOR;
    }else if(ox >= x - 1 && ox <= x + sizeX && oy >= y - 1 && oy <= y + sizeY){
      
      
      //=====DOORS=====\\
      if(ox == x - 1 && oy == y + floor(sizeY/2) && door[DIR_LEFT]){
        if(roomDone()){
          if(!bossRoom){
            return TILES_LEFT_DOOR;
          }else {
            return TILES_LEFT_DOOR_NEXT;
          }
        }else {
          return TILES_LEFT_DOOR_LOCKED;
        }
      }else if(ox == x + sizeX && oy == y + floor(sizeY/2) && door[DIR_RIGHT]){
        if(roomDone()){
          if(!bossRoom){
            return TILES_RIGHT_DOOR;
          }else {
            return TILES_RIGHT_DOOR_NEXT;
          }
        }else {
          return TILES_RIGHT_DOOR_LOCKED;
        }
      }else if(oy == y - 1 && ox == x + floor(sizeX/2) && door[DIR_UP]){
        if(roomDone()){
          if(!bossRoom){
            return TILES_TOP_DOOR;
          }else {
            return TILES_TOP_DOOR_NEXT;
          }
        }else {
          return TILES_TOP_DOOR_LOCKED;
        }
      }else if(oy == y + sizeY && ox == x + floor(sizeX/2) & door[DIR_DOWN]){
        if(roomDone()){
          if(!bossRoom){
            return TILES_BOTTOM_DOOR;
          }else {
            return TILES_BOTTOM_DOOR_NEXT;
          }
        }else {
          return TILES_BOTTOM_DOOR_LOCKED;
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
  
  boolean canCreateRoom(){
    return percentage + random(-ROOM_PERCENTAGE_RANDOM, ROOM_PERCENTAGE_RANDOM) > chance;
  }
  
  
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
  
  void setBoss(){
    bossRoom = true;
  }
  
  
  
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
  
  
  void show(ViewPort view){
    
    flock.show(view);
    
  }
  
  
}
