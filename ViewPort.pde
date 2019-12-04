///
///Camera on top of the Map and Room
///
class ViewPort{
  
  PVector pos;
  float size;
  
  Room currentRoom;
  SoundObservable soundObs;
  boolean finishedRoom;
  
  
  ViewPort(Room newRoom){
    
    currentRoom = newRoom;
    
    size = width/VIEWPORT_GRID_RATIO;
    
    pos = new PVector();
    pos.x = ((currentRoom.getX() + ceil(currentRoom.getSizeX()/2)) - VIEWPORT_GRID_WIDTH/2)*size - size*2.5;
    pos.y = ((currentRoom.getY() + currentRoom.getSizeY()/2) - VIEWPORT_GRID_HEIGHT/2)*size - size/2;
    
    soundObs = new SoundObservable();
    finishedRoom = true;
    
  }
  
  SoundObservable getSoundObservable(){return soundObs;}
  
  ///
  ///Centers itself on the given position
  ///
  void setPos(PVector npos){
    pos.x = npos.x;
    pos.y = npos.y;
    
    pos.x -= floor(VIEWPORT_GRID_WIDTH/2 + 3)*size;
    pos.y -= ceil(VIEWPORT_GRID_HEIGHT/2 + 1)*size;
    
  }
  
  ///
  ///Makes the given room the room to be visible
  ///
  void setRoom(Room newRoom){
    
    currentRoom = newRoom;
    
    if(currentRoom.getFlock().getEnemies().size() > 0){
      soundObs.notifyObs();
      soundObs.setSound(Sounds.DOOR_LOCK);
      finishedRoom = false;
    }
    
    currentRoom.visitRoom();
    
  }
  
  PVector getPos(){return pos;}
  
  int getX(){return floor(pos.x/size);}
  int getY(){return floor(pos.y/size);}
  
  Room getRoom(){return currentRoom;}
  
  ///
  ///Limits the camera to the room edges
  ///
  void limitCamera(){
    
    if(currentRoom.getSizeX() - 1 > VIEWPORT_GRID_WIDTH){
      
      if(getX() < currentRoom.getX() - 2){
        pos.x = (currentRoom.getX() - 2)*size;
      }else if(getX() > currentRoom.getX() + currentRoom.getSizeX() - VIEWPORT_GRID_WIDTH - 5){
        pos.x = (currentRoom.getX() + currentRoom.getSizeX() - VIEWPORT_GRID_WIDTH - 4)*size;
      }
      
    }else {
      
      pos.x = ((currentRoom.getX() + ceil(currentRoom.getSizeX()/2)) - VIEWPORT_GRID_WIDTH/2)*size - size*2.5;
      
    }
    
    
    if(currentRoom.getSizeY() > VIEWPORT_GRID_HEIGHT){
      
      if(getY() < currentRoom.getY() - 2){
        pos.y = (currentRoom.getY() - 2)*size;
      }else if(getY() > currentRoom.getY() + currentRoom.getSizeY() - VIEWPORT_GRID_HEIGHT - 2){
        pos.y = (currentRoom.getY() + currentRoom.getSizeY() - VIEWPORT_GRID_HEIGHT - 2)*size + size*0.5;
      }
      
      
    }else {
      
      pos.y = ((currentRoom.getY() + currentRoom.getSizeY()/2) - VIEWPORT_GRID_HEIGHT/2)*size - size*2;
      
    }
    
  }
  
  ///
  ///Updates the current room and the camera position
  ///
  void update(float delta, PVector playerPos){
    
    limitCamera();
    currentRoom.update(delta, playerPos);
    if(currentRoom.getFlock().getEnemies().size() == 0){
      if(!finishedRoom){
        
        soundObs.notifyObs();
        soundObs.setSound(Sounds.DOOR_UNLOCK);
        
        finishedRoom = true;
        
      }
    }
    
  }
  
  ///
  ///Renders the current room
  ///
  void show(){
    
    background(0);
    noStroke();
    
    int x = getX();
    int y = getY();  
    
    
    for(int i = -1; i <= VIEWPORT_GRID_RATIO; i++){
      for(int j = -1; j <= ceil(height * VIEWPORT_GRID_RATIO / width); j++){
        
        int values = currentRoom.getTileType(x + i, y + j);
        
        if(values != TILES_VOID){
          
          //rect(i * size - pos.x%(width/VIEWPORT_GRID_RATIO), j * size - pos.y%(width/VIEWPORT_GRID_RATIO), size, size);
          
          int imageSizeX = RoomTileSet.getImageWidth();
          int imageSizeY = RoomTileSet.getImageHeight();
          
          pushMatrix();
          translate(i * size - pos.x%(width/VIEWPORT_GRID_RATIO), j * size - pos.y%(width/VIEWPORT_GRID_RATIO));
          
          beginShape();
          
          texture(RoomTileSet.getTile(values));
          
          
          vertex(0, 0, 0, 0);
          vertex(size, 0, imageSizeX, 0);
          vertex(size, size, imageSizeX, imageSizeY);
          vertex(0, size, 0, imageSizeY);
          
          
          endShape();
          
          
          popMatrix();
          
        }
        
      }
    }
    
    currentRoom.show(this);
    
  }
  
  
  
}
