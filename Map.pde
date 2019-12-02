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


  void toggleGrid(float x, float y) {

    int i = floor(x * getSizeX() / width);
    int j = floor(y * getSizeY() / height);

    if (isWalkable(i, j)) {
      setObstacle(i, j);
    } else {
      setWalkable(i, j);
    }
  }

  boolean inGrid(int i, int j) {

    if (i >= 0 && i < grid.length && j >= 0 && j < grid[0].length) {
      return true;
    }

    return false;
  }

  void setWalkable(int i, int j) {

    if (inGrid(i, j)) {
      grid[i][j] = GRID_WALKABLE;
    }
  }

  void setObstacle(int i, int j) {

    if (inGrid(i, j)) {
      grid[i][j] = GRID_OBSTACLE;
    }
  }

  void setRWalkable(float x, float y) {

    int i = floor(x * getSizeX() / width);
    int j = floor(y * getSizeY() / height);

    setWalkable(i, j);
  }

  void setRObstacle(float x, float y) {

    int i = floor(x * getSizeX() / width);
    int j = floor(y * getSizeY() / height);

    setObstacle(i, j);
  }


  boolean isWalkable(int i, int j) {

    if (inGrid(i, j)) {
      if (grid[i][j] == GRID_WALKABLE) {
        return true;
      }
    }

    return false;
  }

  boolean isObstacle(int i, int j) {

    if (inGrid(i, j)) {
      if (grid[i][j] == GRID_OBSTACLE) {
        return true;
      }
    }

    return false;
  }

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


  void visitGrid(int i, int j) {

    visited[i][j] = true;
  }
  
  void update(){
    
    
    
  }

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

  void show(){
    
    map.beginDraw();
      
    map.colorMode(RGB);
    map.background(0);
    
    map.noStroke();  

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {

        if (grid[i][j] == GRID_WALKABLE) {

          if (visited[i][j]) {
            map.fill(100);
          }else {
            map.fill(150, 255, 255);
          }
          
        } else if (grid[i][j] == GRID_OBSTACLE) {
          map.fill(255);
        }else if(grid[i][j] == GRID_WALL){
          map.fill(150, 0, 0);
        }else if(grid[i][j] == GRID_BOSS_WALL){
          map.fill(150, 150, 0);
        }
        
        
        map.rect(i * (width/getSizeX()), j * (height/getSizeY()), (width/getSizeX()), (height/getSizeY()));
        
      }
      
    }

    map.fill(255);
    map.rect(0, height, width, height + (height/getSizeY())/2);
    map.rect(width, 0, width + (width/getSizeX())/2, height + (height/getSizeY())/2);
    
    map.endDraw();
    
    
    beginShape();
    
      texture(map);
      
      vertex(0, 0, 0, 0);
      vertex(width, 0, map.width, 0);
      vertex(width, height, map.width, map.height);
      vertex(0, height, 0, map.height);
    
    endShape();
    
  }
  
  
  void createGrid() {

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
    
    rooms.get(0).createFlock(0, level);
    
  }
  
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
    
  }
  
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
  
  
  
  boolean inRoom(int x, int y, int sx, int sy){
    
    if(x >= 0 && x + sx < gridWidth && y >= 0 && y + sy < gridHeight){
      return true;
    }
    return false;
    
  }


  void carvePassage(int i, int j) {

    for (int swap = 0; swap < random(20, 30); swap++) {

      int pos1 = int(random(4));
      int pos2 = int(random(4));

      while (pos2 == pos1) {
        pos2 = int(random(4));
      }

      int oldVal = DIR[pos1];
      DIR[pos1] = DIR[pos2];
      DIR[pos2] = oldVal;
    }

    for (int k = 0; k < 4; k++) {

      int offsetX = DIRX[DIR[k]];
      int offsetY = DIRY[DIR[k]];

      if (inGrid(i + offsetX, j + offsetY)) {

        if (grid[i + offsetX][j + offsetY] == GRID_OBSTACLE) {

          grid[i + offsetX][j + offsetY] = GRID_WALKABLE;
          grid[i + offsetX/2][j + offsetY/2] = GRID_WALKABLE;
          carvePassage(i + offsetX, j + offsetY);
        }
        
      }
      
    }
    
  }
  
  
  
  void setEnemiesObservables(ParticleObserver obs){
    
    for(Room part : rooms){
      for(Enemy opart : part.getFlock().getEnemies()){
        obs.addObservable(opart.getParticleObservable());
      }
    }
    
  }


}
