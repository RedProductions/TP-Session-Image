///
///Main player of the game
///
class Player extends GObject{
  
  boolean moving[];
  
  PVector firePos;
  
  int frame;
  float frameChangeRate;
  float lastFrameChanged;
  
  PVector fireDir;
  float fireSpeed;
  
  boolean firing;
  
  FiringObserver observer;
  ParticleObservable partObs;
  SoundObservable soundObs;
  
  float accSpeed;
  
  private Projectiles projectiles;
  
  private boolean nextLevel;
  
  int health;
  int maxHealth;
  
  
  float lastHurt;
  float hurtRate;
  boolean alive;
  
  
  GUI gui;
  
  
  Modifier modifier;
  
  Player(Room newRoom){
    
    
    modifier = new Modifier();
    
    size = new PVector(width/VIEWPORT_GRID_WIDTH, height/VIEWPORT_GRID_HEIGHT);
    size.div(1.75);
    
    
    
    acc = new PVector();
    vel = new PVector();
    
    moving = new boolean[4];
    
    frame = 0;
    frameChangeRate = 100;
    lastFrameChanged = 0;
    
    fireSpeed = TILE_SIZE_PIXELS/63;
    fireDir = new PVector(0, 0);
    
    
    
    hurtRate = 1500;
    lastHurt = 0;
    
    
    maxHealth = PLAYER_STARTING_HEALTH;
    health = 6;
    
    accSpeed = TILE_SIZE_PIXELS/PLAYER_ACC_SPEED;
    
    alive = true;
    
    soundObs = new SoundObservable();
    
    gui = new GUI();
    
    gui.setHealth(health);
    gui.setMaxHealth(maxHealth);
    
    projectiles = new Projectiles();
    
    resetLevel(newRoom, 0);
    
    
    //UNCOMMENT FOR GOD MODE
    //modifier.getAttributeMods()[AttributesModifiers.RANDOMHUE.ordinal()] = true;
    //modifier.getAttributeMods()[AttributesModifiers.PIERCING.ordinal()] = true;
    //modifier.getValueMods()[ValuesModifiers.FIRERATE.ordinal()] = 0.25;
    //modifier.getValueMods()[ValuesModifiers.SIZE.ordinal()] = 3;
    
    applyModifier();
    
  }
  
  ///
  ///Resets the player for the next level
  ///
  void resetLevel(Room newRoom, int level){
    
    pos = new PVector((newRoom.getX() + newRoom.getSizeX()/2) * (width/VIEWPORT_GRID_RATIO), (newRoom.getY() + newRoom.getSizeY()/2) * (width/VIEWPORT_GRID_RATIO));
    firePos = new PVector(pos.x + size.x/2, pos.y + size.y/3);
    
    nextLevel = false;
    
    gui.setLevel(level);
    
    partObs = new ParticleObservable();
    
    projectiles.clearProjectiles();
    
  }
  
  
  
  
  ///
  ///Combines a given modifier to its current modifier
  ///
  void combineModifiers(Modifier mod){
    modifier.combine(mod);
    applyModifier();
    
    soundObs.notifyObs();
    if(mod.isUpgrade()){
      soundObs.setSound(Sounds.UPGRADE);
    }else {
      soundObs.setSound(Sounds.DOWNGRADE);
    }
    
  }
  
  ///
  ///Applies the modifier's attributes to the player
  ///
  void applyModifier(){
    
    float[] valuesMod = modifier.getPlayerMods();
    
    int index = PlayerModifiers.SPEED.ordinal();
    accSpeed *= valuesMod[index];
    
    index = PlayerModifiers.HEALTH.ordinal();
    
    maxHealth += valuesMod[index];
    
    if(valuesMod[index] > 0){
      for(int i = 0; i < valuesMod[index]/2; i++){
        heal();
      }
    }else if(valuesMod[index] < 0){
      health += (valuesMod[index] + 1);
      getHit();
    }
    
    
    modifier.resetPlayerModifiers();
    
    projectiles.setModifier(modifier);
    
    
  }
  
  
  
  ///
  ///Forces the death of a player
  ///
  void kill(){alive = false;}
  
  boolean isAlive(){return alive;}
  
  ParticleObservable getParticleObservable(){return partObs;}
  SoundObservable getSoundObservable(){return soundObs;}
  
  ///
  ///Set the projectile fireing observer
  ///
  void setObserver(FiringObserver nobserver){
    observer = nobserver;
  }
  
  PVector getFirePos(){return firePos;}
  PVector getScreenPos(PVector viewPos){return new PVector(pos.x - viewPos.x + size.x/2, pos.y - viewPos.y + size.y/2);}
  PVector getVel(){return vel;}
  PVector getFireVel(){return new PVector(fireDir.x * fireSpeed + vel.x/3, fireDir.y * fireSpeed + vel.y/3);}
  int getTeam(){return PROJECTILE_PLAYER;}
  
  boolean getNextLevel(){return nextLevel;}
  
  Projectiles getProjectiles(){return projectiles;}
  
  ///
  ///Default render method
  ///
  void show(){}
  
  ///
  ///Render method relative to the view port
  ///
  void show(ViewPort view){
    
    projectiles.show(view);
    
    
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
      
      if(DEBUG){
        stroke(0, 255, 0);
        strokeWeight(3);
      }else {
        noStroke();
      }
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
      
      
      if(DEBUG){
        stroke(0, 150, 0);
        rect(size.x*0.15, 0, size.x - (size.x*0.15) * 2, size.y*0.86);
      }
      
      
    popMatrix();
    
    
    gui.show();
    
  }
  
  ///
  ///Limites the speed of the player when moving
  ///
  void limitSpeed(){
    
    if(vel.mag() > TILE_SIZE_PIXELS/PLAYER_MAX_SPEED){
      vel.setMag(TILE_SIZE_PIXELS/PLAYER_MAX_SPEED);
    }
    
  }
  
  ///
  ///Default update method
  ///
  void update(float deltaTime){
    
    println("Woops! Wrong update!");
    
  }
  
  ///
  ///Updates the calculations and physics and changes the room when crossing a door
  ///
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
        heal();
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
      
      if(projectiles.canFire()){
        
        observer.notifyPropertyChanged();
        soundObs.notifyObs();
        soundObs.setSound(Sounds.PLAYER_SHOOT);
        
        projectiles.hasFired();
        
      }
      
      
    }
    
    
    if(view.getRoom().getType(firePos.x, firePos.y) == GRID_ITEM){
      if(!view.getRoom().hasTakenModifier()){
        
        combineModifiers(view.getRoom().getModifier());
        
        view.getRoom().takeModifier();
      }
    }
    
    
    projectiles.update(deltaTime, view);
    
    
  }
  
  
  ///
  ///Handles a key pressed
  ///
  void controll(char k){
    
    if(alive){
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
    
  }
  
  ///
  ///Handles a key released
  ///
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
  
  ///
  ///Checks for a collision with an entire flock
  ///
  void checkEnemyCollisions(Flock flock){
    checkEnemyCollisions(flock.getEnemies());
  }
  
  ///
  ///Check the collision for multiple enemies
  ///
  void checkEnemyCollisions(ArrayList<Enemy> enemies){
    
    for(Enemy part : enemies){
      
      if(collide(part.getPos(), part.getSize())){
        if(currentTime - lastHurt >= hurtRate){
          part.notifyCollision();
          getHit();
          lastHurt = currentTime;
        }
      }
      
    }
    
  }
  
  ///
  ///Tells if its hitbox is in collision with another hitbox
  ///
  boolean collide(PVector pos2, PVector size2){
    
    if(pos.x + size.x*0.15 <= pos2.x + size2.x/2 && pos.x + size.x - size.x*0.15 >= pos2.x - size2.x/2){
      if(pos.y <= pos2.y + size2.y/2 && pos.y + size.y*0.86 >= pos2.y - size2.y/2){
        return true;
      }
    }
    
    return false;
    
  }
  
  ///
  ///Take damage
  ///
  void getHit(){
    
    health--;
    updateGUI();
    
    partObs.notifyObs();
    partObs.setParticleParams(getFirePos(), ParticleType.STAR);
    
    
    
    if(health <= 0){
      alive = false;
      soundObs.setSound(Sounds.PLAYER_DIE);
    }else {
      soundObs.setSound(Sounds.PLAYER_HURT);
    }
    soundObs.notifyObs();
    
  }
  
  ///
  ///Heal by one hearth
  ///
  void heal(){
    
    health += 2;
    if(health > maxHealth){
      health = maxHealth;
    }
    
    updateGUI();
    
  }
  
  
  ///
  ///Updates the information of the GUI
  ///
  void updateGUI(){
    
    gui.setHealth(health);
    gui.setMaxHealth(maxHealth);
    
  }
  
  
}
