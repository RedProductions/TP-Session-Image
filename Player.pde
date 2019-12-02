class Player extends GObject{
  
  boolean moving[];
  
  PVector firePos;
  
  int frame;
  float frameChangeRate;
  float lastFrameChanged;
  
  PVector fireDir;
  float fireSpeed;
  
  boolean firing;
  float fireRate;
  float lastFired;
  
  FiringObserver observer;
  ParticleObservable partObs;
  
  float accSpeed;
  
  private boolean nextLevel;
  
  int health;
  int maxHealth;
  
  
  float lastHurt;
  float hurtRate;
  boolean alive;
  
  
  GUI gui;
  
  Player(Room newRoom){
    
    size = new PVector(width/VIEWPORT_GRID_WIDTH, height/VIEWPORT_GRID_HEIGHT);
    size.div(1.75);
    
    
    resetLevel(newRoom);
    
    acc = new PVector();
    vel = new PVector();
    
    moving = new boolean[4];
    
    frame = 0;
    frameChangeRate = 100;
    lastFrameChanged = 0;
    
    fireSpeed = TILE_SIZE_PIXELS/63;
    fireDir = new PVector(0, 0);
    
    fireRate = 300;
    lastFired = fireRate;
    
    hurtRate = 1500;
    lastHurt = 0;
    
    
    maxHealth = PLAYER_STARTING_HEALTH;
    health = maxHealth;
    
    accSpeed = TILE_SIZE_PIXELS/PLAYER_ACC_SPEED;
    
    alive = true;
    
    gui = new GUI();
    
    gui.setHealth(health);
    gui.setMaxHealth(maxHealth);
    
  }
  
  void resetLevel(Room newRoom){
    
    pos = new PVector((newRoom.getX() + newRoom.getSizeX()/2) * (width/VIEWPORT_GRID_RATIO), (newRoom.getY() + newRoom.getSizeY()/2) * (width/VIEWPORT_GRID_RATIO));
    firePos = new PVector(pos.x + size.x/2, pos.y + size.y/3);
    
    nextLevel = false;
    
    partObs = new ParticleObservable();
    
  }
  
  boolean isAlive(){return alive;}
  
  ParticleObservable getParticleObservable(){return partObs;}
  void setObserver(FiringObserver nobserver){
    observer = nobserver;
  }
  
  PVector getFirePos(){return firePos;}
  PVector getScreenPos(PVector viewPos){return new PVector(pos.x - viewPos.x + size.x/2, pos.y - viewPos.y + size.y/2);}
  PVector getVel(){return vel;}
  PVector getFireVel(){return new PVector(fireDir.x * fireSpeed + vel.x/3, fireDir.y * fireSpeed + vel.y/3);}
  int getTeam(){return PROJECTILE_PLAYER;}
  
  boolean getNextLevel(){return nextLevel;}
  
  void show(){}
  
  
  void show(ViewPort view){
    
    int imageSizeX = PlayerTileSet.getImageWidth();
    int imageSizeY = PlayerTileSet.getImageHeight();
    
    
    //println("Player: ", pos);
    
    pushMatrix();
    
      translate(-view.getPos().x, -view.getPos().y);
      translate(pos.x, pos.y, 2);
      
      if(moving[DIR_RIGHT]){
        scale(-1, 1);
        translate(-size.x, 0);
      }
      
      noStroke();
      noFill();
      
      beginShape();
      
      if(alive){
        if(moving[DIR_UP]){
          texture(PlayerTileSet.getBackTile(frame));
        }else {
          
          if(currentTime - lastHurt >= hurtRate){
            if(firing){
              texture(PlayerTileSet.getShootTile(frame));
            }else {
              texture(PlayerTileSet.getFrontTile(frame));
            }
          }else {
            texture(PlayerTileSet.getHurtTile(frame));
          }
          
        }
      }else {
          texture(PlayerTileSet.getDeadTile(0));
      }
      
      vertex(0, 0, 0, 0);
      vertex(size.x, 0, imageSizeX, 0);
      vertex(size.x, size.y, imageSizeX, imageSizeY);
      vertex(0, size.y, 0, imageSizeY);
      
      //fill(255, 200, 200);
      
      //ellipseMode(CORNER);
      //ellipse(0, 0, size.x, size.y);
      
      endShape();
      
      
    popMatrix();
    
    
    gui.show();
    
  }
  
  void limitSpeed(){
    
    if(vel.mag() > TILE_SIZE_PIXELS/PLAYER_MAX_SPEED){
      vel.setMag(TILE_SIZE_PIXELS/PLAYER_MAX_SPEED);
    }
    
  }
  
  void update(float deltaTime){
    
    
    
  }
  
  void update(float deltaTime, ViewPort view){
    
    PVector pastPos = pos.copy();
    
    boolean movingAny = false;
    
    if(moving[DIR_DOWN]){
      acc.y += accSpeed;
      movingAny = true;
    }
    if(moving[DIR_UP]){
      acc.y -= accSpeed;
      movingAny = true;
    }
    if(moving[DIR_LEFT]){
      acc.x -= accSpeed;
      movingAny = true;
    }
    if(moving[DIR_RIGHT]){
      acc.x += accSpeed;
      movingAny = true;
    }
    
    vel.add(acc);
    pos.add(vel);
    pos.add(PVector.mult(vel, deltaTime/FRAME_DELTA));
    
    vel.mult(0.85);
    
    acc.mult(0);
    
    firePos.x = pos.x + size.x/2;
    firePos.y = pos.y + size.y/4;
    
    limitSpeed();
    
    
    if(movingAny){
      
      if(currentTime - lastFrameChanged >= frameChangeRate){
        frame = (frame+1)%PlayerTileSet.getFrameAmount();
        lastFrameChanged = currentTime;
      }
      
    }
    
    
    int doorDir = view.getRoom().onDoor(pos, size);
    
    if(doorDir != -1){
      
      if(view.getRoom().isBoss()){
        nextLevel = true;
      }
      
      Room newRoom = view.getRoom().getRoom(doorDir);
      if(!nextLevel){
        
        view.setRoom(newRoom);
      
        if(doorDir == DIR_LEFT){
          
          pos.x -= (width/VIEWPORT_GRID_RATIO)*2;
          vel.mult(0);
          
        }else if(doorDir == DIR_RIGHT){
          
          pos.x += (width/VIEWPORT_GRID_RATIO)*2;
          vel.mult(0);
          
        }else if(doorDir == DIR_UP){
          
          pos.y -= (width/VIEWPORT_GRID_RATIO)*2;
          vel.mult(0);
          
          
        }else if(doorDir == DIR_DOWN){
          
          pos.y += (width/VIEWPORT_GRID_RATIO)*2;
          vel.mult(0);
          
        }
        
      }
      
    }else {
      
      boolean[] hitSide = view.getRoom().sideOnWall(pos, size);
      
      for(int i = 0; i < 4; i++){
      
        if(hitSide[i]){
          
          if(i == DIR_LEFT || i == DIR_RIGHT){
            pos.x = pastPos.x;
            vel.x = 0;
          }else if(i == DIR_DOWN || i == DIR_UP){
            pos.y = pastPos.y;
            vel.y = 0;
          }
          
        }
        
      }
      
    }
    
    
    if(firing){
      
      if(currentTime - lastFired >= fireRate){
        
        observer.notifyPropertyChanged();
        
        lastFired = currentTime;
        
      }
      
      
    }
    
    
    
  }
  
  
  
  void controll(char k){
    
    if(k == 'a'){
      moving[DIR_LEFT] = true;
    }else if(k == 'd'){
      moving[DIR_RIGHT] = true;
    }
    if(k == 'w'){
      moving[DIR_UP] = true;
    }else if(k == 's'){
      moving[DIR_DOWN] = true;
    }
    
    if(k == CODED){
      
      if(keyCode == LEFT){
        firing = true;
        fireDir.x = -1;
        fireDir.y = 0;
      }else if(keyCode == RIGHT){
        firing = true;
        fireDir.x = 1;
        fireDir.y = 0;
      }else if(keyCode == UP){
        firing = true;
        fireDir.x = 0;
        fireDir.y = -1;
      }else if(keyCode == DOWN){
        firing = true;
        fireDir.x = 0;
        fireDir.y = 1;
      }
      
    }
    
  }
  
  void uncontroll(char k){
    
    if(k == 'a'){
      moving[DIR_LEFT] = false;
    }else if(k == 'd'){
      moving[DIR_RIGHT] = false;
    }
    if(k == 'w'){
      moving[DIR_UP] = false;
    }else if(k == 's'){
      moving[DIR_DOWN] = false;
    }
    
    if(k == CODED){
      
      if(keyCode == LEFT){
        firing = false;
        fireDir.x = 0;
        fireDir.y = 0;
      }else if(keyCode == RIGHT){
        firing = false;
        fireDir.x = 0;
        fireDir.y = 0;
      }else if(keyCode == UP){
        firing = false;
        fireDir.x = 0;
        fireDir.y = 0;
      }else if(keyCode == DOWN){
        firing = false;
        fireDir.x = 0;
        fireDir.y = 0;
      }
      
    }
    
  }
  
  void checkEnemyCollisions(Flock flock){
    checkEnemyCollisions(flock.getEnemies());
  }
  
  void checkEnemyCollisions(ArrayList<Enemy> enemies){
    
    for(Enemy part : enemies){
      
      if(collide(part.getCornerPos(), part.getSize())){
        if(currentTime - lastHurt >= hurtRate){
          part.notifyCollision();
          getHit();
          lastHurt = currentTime;
        }
      }
      
    }
    
  }
  
  
  boolean collide(PVector pos2, PVector size2){
    
    if(pos.x <= pos2.x + size2.x && pos.x + size.x >= pos2.x){
      if(pos.y <= pos2.y + size2.y && pos.y + size.y >= pos2.y){
        return true;
      }
    }
    
    return false;
    
  }
  
  
  void getHit(){
    
    health--;
    gui.setHealth(health);
    
    partObs.notifyObs();
    partObs.setParticleParams(getFirePos(), ParticleType.STAR);
    
    if(health <= 0){
      alive = false;
    }
    
  }
  
  
}
