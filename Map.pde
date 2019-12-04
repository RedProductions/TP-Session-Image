///
///Handles the grid, the list of Room and the miniMap of the current level
///
class Map {

  int gridWidth, gridHeight;
  
  int grid[][];

  boolean visited[][];
  ArrayList<Room> rooms;
  
  PGraphics map;
  
  int level;
  
  Map(int nlevel) {
    
    level = nlevel;
    
    gridWidth = width/GRID_RATIO;
    gridHeight = height/GRID_RATIO;
    
    grid = new int[gridWidth][gridHeight];
    visited = new boolean[gridWidth][gridHeight];
    
    resetSize();
    
    
    createGrid();
    
  }
  
  
  
  ///
  ///Changes the size of the fullscreen map when the screen size changes(WIP)
  ///
  void resetSize(){
    
    map = createGraphics(width, height);
    
  }
  
  Room getCurrentRoom(){return rooms.get(0);}
  
  PImage getMap(){return map;}

  int getSizeX() {
    return grid.length;
  }
  int getSizeY() {
    return grid[0].length;
  }

  int[][] getGrid(){return grid;}
  


  int getIDX(float x) {

    int i = floor(x * getSizeX() / width);

    return i;
  }
  int getIDY(float y) {

    int j = floor(y * getSizeY() / height);

    return j;
  }

  ///
  ///Changes a cell to be walkable or not
  ///
  void toggleGrid(float x, float y) {

    int i = floor(x * getSizeX() / width);
    int j = floor(y * getSizeY() / height);

    if (isWalkable(i, j)) {
      setObstacle(i, j);
    } else {
      setWalkable(i, j);
    }
  }

  ///
  ///Tells if the given index is in bounds of the grid
  ///
  boolean inGrid(int i, int j) {

    if (i >= 0 && i < grid.length && j >= 0 && j < grid[0].length) {
      return true;
    }

    return false;
  }
  
  ///
  ///Sets the given cell to be walkable
  ///
  void setWalkable(int i, int j) {

    if (inGrid(i, j)) {
      grid[i][j] = GRID_WALKABLE;
    }
  }

  ///
  ///Sets the given cell to be non-walkable
  ///
  void setObstacle(int i, int j) {

    if (inGrid(i, j)) {
      grid[i][j] = GRID_OBSTACLE;
    }
  }
  
  ///
  ///Sets the cell at the given global position to be walkable
  ///
  void setRWalkable(float x, float y) {

    int i = floor(x * getSizeX() / width);
    int j = floor(y * getSizeY() / height);

    setWalkable(i, j);
  }
  
  ///
  ///Sets the cell at the given global position to be non-walkable
  ///
  void setRObstacle(float x, float y) {

    int i = floor(x * getSizeX() / width);
    int j = floor(y * getSizeY() / height);

    setObstacle(i, j);
  }

  ///
  ///Tells if the given cell is walkable
  ///
  boolean isWalkable(int i, int j) {

    if (inGrid(i, j)) {
      if (grid[i][j] == GRID_WALKABLE) {
        return true;
      }
    }

    return false;
  }

  ///
  ///Tells if the given cell is non-walkable
  ///
  boolean isObstacle(int i, int j) {

    if (inGrid(i, j)) {
      if (grid[i][j] == GRID_OBSTACLE) {
        return true;
      }
    }

    return false;
  }
  
  ///
  ///Tells if the cell at the given global position is walkable
  ///
  boolean isRWalkable(float x, float y) {

    int i = floor(x * getSizeX() / width);
    int j = floor(y * getSizeY() / height);


    if (inGrid(i, j)) {
      if (grid[i][j] == GRID_WALKABLE) {
        return true;
      }
    }

    return false;
  }
  
  ///
  ///Tells if the cell at the given global position is non-walkable
  ///
  boolean isRObstacle(float x, float y) {

    int i = floor(x * getSizeX() / width);
    int j = floor(y * getSizeY() / height);

    if (inGrid(i, j)) {
      if (grid[i][j] == GRID_OBSTACLE) {
        return true;
      }
    }

    return false;
  }

  ///
  ///Sets the given cell to a cell that has been visited by the player
  ///
  void visitGrid(int i, int j) {

    if(i >= 0 && i < visited.length){
      if(j >= 0 && j < visited[0].length){
        visited[i][j] = true;
      }
    }
    
  }
  
  ///
  ///Updates the rooms and the grid
  ///
  void update(){
    
    for(Room part : rooms){
      
      if(part.isVisited()){
        
        for(int i = part.getX() - 1; i <= part.getX() + part.getSizeX(); i++){
          for(int j = part.getY() - 1; j <= part.getY() + part.getSizeY(); j++){
            
            visitGrid(i, j);
            
          }
        }
        
      }
      
    }
    
  }

  ///
  ///Renders a simplified minimap
  ///
  void showSimple() {

    map.noStroke();
    map.fill(100);

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {

        if (grid[i][j] != GRID_OBSTACLE && visited[i][j]) {
          map.rect(i * (width/getSizeX()), j * (height/getSizeY()), (width/getSizeX()), (height/getSizeY()));
        }
      }
    }
  }

  ///
  ///Renders the normal minimap
  ///
  void show(){
    
    map.beginDraw();
      
    map.colorMode(RGB);
    map.background(0,0);
    
    map.noStroke();  

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {

        if(grid[i][j] == GRID_WALKABLE) {

          if(visited[i][j]) {
            map.fill(75, 175);
            map.rect(i * (width/getSizeX()), j * (height/getSizeY()), (width/getSizeX()), (height/getSizeY()));
          }
          
        }else if(grid[i][j] == GRID_WALL || grid[i][j] == GRID_BOSS_WALL){
          if (visited[i][j]) {
            map.fill(25, 175);
            map.rect(i * (width/getSizeX()), j * (height/getSizeY()), (width/getSizeX()), (height/getSizeY()));
          }
        }
        
        
        
      }
      
    }
    
    map.endDraw();
    
    pushMatrix();
    translate(width - width/5, 0, 6);
    
    noStroke();
    
    beginShape();
      
      texture(map);
      
      int mapHeight = map.height * floor(width/5) / map.width;
      
      vertex(0, 0, 0, 0);
      vertex(width/5, 0, map.width, 0);
      vertex(width/5, mapHeight, map.width, map.height);
      vertex(0, mapHeight, 0, map.height);
      
      
    endShape();
    
    popMatrix();
    
  }
  
  ///
  ///Renders the complete map with all grid information
  ///
  void showFull(){
    
    
    map.beginDraw();
      
    map.colorMode(RGB);
    map.background(25);
    
    map.noStroke();  

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {

        if(grid[i][j] == GRID_WALKABLE) {

          if(grid[i][j] == GRID_ITEM){
            map.fill(255, 255, 0);
          }else {
            map.fill(255);
          }
          map.rect(i * (width/getSizeX()), j * (height/getSizeY()), (width/getSizeX()), (height/getSizeY()));
          
        }else if(grid[i][j] == GRID_WALL){
            map.fill(175);
            map.rect(i * (width/getSizeX()), j * (height/getSizeY()), (width/getSizeX()), (height/getSizeY()));
        }else if(grid[i][j] == GRID_BOSS_WALL){
          map.fill(175, 0, 0);
          map.rect(i * (width/getSizeX()), j * (height/getSizeY()), (width/getSizeX()), (height/getSizeY()));
        }
        
        
        
        
      }
      
    }
    
    map.endDraw();
    
    pushMatrix();
    
    noStroke();
    
    beginShape();
      
      texture(map);
      
      vertex(0, 0, 0, 0);
      vertex(width, 0, map.width, 0);
      vertex(width, height, map.width, map.height);
      vertex(0, height, 0, map.height);
      
      
    endShape();
    
    popMatrix();
    
  }
  
  ///
  ///Initiates the generation of the room maze and spawns in the flocks
  ///
  public void createGrid() {

    for (int i = 0; i < getSizeX(); i++) {
      for (int j = 0; j < getSizeY(); j++) {

        grid[i][j] = GRID_OBSTACLE;
        visited[i][j] = false;
      }
    }
    
    createDungeon();
    
    for(int i = 1; i < rooms.size(); i++){
      
      rooms.get(i).createFlock(int(random(5 + level/2, 10 + level/2)), level);
      
    }
    
    Room spawnRoom = rooms.get(0);
    
    spawnRoom.createFlock(0, level);
    spawnRoom.visitRoom();
    
  }
  
  ///
  ///Generates the rooms for the maze and sets the boss and item room
  ///
  void createDungeon(){
    
    if(rooms != null){
      rooms.clear();
    }
    
    rooms = new ArrayList<Room>();
    
    
    int sizeX = 7;
    int sizeY = 5;
    
    int x = int(gridWidth/2 - sizeX/2);
    int y = int(gridHeight/2 - sizeY/2);
    
    
    rooms.add(new Room(x, y, sizeX, sizeY));
    
    int tries = 0;
    
    while(rooms.size() < ROOM_MIN_AMOUNT && tries < ROOM_MIN_AMOUNT*2){
      createRoom(rooms.get(0));
      tries++;
    }
    
    
    rooms.get(rooms.size() - 1).setBoss();
    rooms.get(rooms.size() - 2).setItem();
    
    int itemX = rooms.get(rooms.size() - 2).getX() + rooms.get(rooms.size() - 2).getSizeX()/2;
    int itemY = rooms.get(rooms.size() - 2).getY() + rooms.get(rooms.size() - 2).getSizeY()/2;
    
    
    
    
    for(Room part : rooms){
      
      for(int i = part.getX(); i < part.getX() + part.getSizeX(); i++){
        for(int j = part.getY(); j < part.getY() + part.getSizeY(); j++){
          
          if(i < gridWidth && i >= 0 && j < gridHeight && j >= 0){
            grid[i][j] = GRID_WALKABLE;
          }
          
        }
      }
      
      
      for(int i = part.getX() - 1; i <= part.getX() + part.getSizeX(); i++){
        for(int j = part.getY() - 1; j <= part.getY() + part.getSizeY(); j++){
          
          if(i < gridWidth && i >= 0 && j < gridHeight && j >= 0){
            if(grid[i][j] == GRID_OBSTACLE){
              if(part.isBoss()){
                grid[i][j] = GRID_BOSS_WALL;
              }else {
                grid[i][j] = GRID_WALL;
              }
            }
          }
          
        }
      }
      
    }
    
    
    grid[itemX][itemY] = GRID_ITEM;
    
  }
  
  ///
  ///Recursively creates a room in the maze
  ///
  void createRoom(Room neighbour){
    
    for(int side = 0; side < 4; side++){
      
      int sizeX = int(random(ROOM_MIN_SIZE, ROOM_MAX_SIZE));
      int sizeY = int(random(ROOM_MIN_SIZE, ROOM_MAX_SIZE));
      
      if(sizeX%2 == 0){
        sizeX++;
      }
      if(sizeY%2 == 0){
        sizeY++;
      }
      
      int x = int(gridWidth/2 - sizeX/2);
      int y = int(gridHeight/2 - sizeY/2);
      
      int ox = neighbour.getX();
      int oy = neighbour.getY();
      int osx = neighbour.getSizeX();
      int osy = neighbour.getSizeY();
      
      Room newRoom = null;
      
      if(side == DIR_LEFT){
        
        x = ox - sizeX - 1;
        y = oy + osy/2 - sizeY/2;
        if(inRoom(x, y, sizeX, sizeY)){
          
          newRoom = new Room(x, y, sizeX, sizeY, neighbour.getPercentage());
          
        }else {
          return;
        }
        
      }else if(side == DIR_RIGHT){
        
        x = ox + osx + 1;
        y = oy + osy/2 - sizeY/2;
        if(inRoom(x, y, sizeX, sizeY)){
          
          newRoom = new Room(x, y, sizeX, sizeY, neighbour.getPercentage());
          
        }else {
          return;
        }
        
      }else if(side == DIR_UP){
        
        x = ox + osx/2 - sizeX/2;
        y = oy - sizeY - 1;
        if(inRoom(x, y, sizeX, sizeY)){
          
          newRoom = new Room(x, y, sizeX, sizeY, neighbour.getPercentage());
          
        }else {
          return;
        }
        
      }else if(side == DIR_DOWN){
        
        x = ox + osx/2 - sizeX/2;
        y = oy + osy+1;
        if(inRoom(x, y, sizeX, sizeY)){
          
          newRoom = new Room(x, y, sizeX, sizeY, neighbour.getPercentage());
          
        }else {
          return;
        }
        
      }
      
      
      if(newRoom != null){
        
        boolean collision = false;
        
        for(Room part : rooms){
          if(part.collide(newRoom)){
            collision = true;
          }
        }
        if(!collision && newRoom.canCreateRoom()){
          
          if(side == DIR_UP){
            grid[ox + osx/2][oy - 1] = GRID_WALKABLE;
          }else if(side == DIR_DOWN){
            grid[ox + osx/2][oy + osy] = GRID_WALKABLE;
          }else if(side == DIR_LEFT){
            grid[ox - 1][oy + osy/2] = GRID_WALKABLE;
          }else if(side == DIR_RIGHT){
            grid[ox + osx][oy + osy/2] = GRID_WALKABLE;
          }
          
          rooms.add(newRoom);
          
          if(rooms.size() < ROOM_MAX_AMOUNT){
            neighbour.setDoor(side);
            neighbour.setRoom(side, newRoom);
            
            newRoom.setDoor(DIR_MIRROR[side]);
            newRoom.setRoom(DIR_MIRROR[side], neighbour);
            
            createRoom(newRoom);
          }
        }
      }
      
      
      
    }
    
    
  }
  
  
  ///
  ///Tells if a room is in bound of the grid
  ///
  boolean inRoom(int x, int y, int sx, int sy){
    
    //minimum at 4 to prevent in-between where the view port would glitch between room edge and world edge
    if(x >= 4 && x + sx < gridWidth && y >= 5 && y + sy < gridHeight){
      return true;
    }
    return false;
    
  }

  
  
  ///
  ///Passes the observers to the flocks
  ///
  void setEnemiesObservables(ParticleObserver npartObs, SoundObserver nsoundObs){
    
    for(Room part : rooms){
      for(Enemy opart : part.getFlock().getEnemies()){
        npartObs.addObservable(opart.getParticleObservable());
        nsoundObs.addObservable(opart.getSoundObservable());
      }
    }
    
  }
  
  ///
  ///Passes the message observer to the rooms
  ///
  void setMessageObservables(MessageObserver messObs){
    
    for(Room part : rooms){
      messObs.addObservable(part.getMessageObservale());
    }
    
  }


}
