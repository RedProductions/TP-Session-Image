///
///Handles all the Projectile
///
class Projectiles{
  
  ArrayList<Projectile> projectiles;
  FiringObserver observant;
  
  ParticleObserver partObserver;
  SoundObserver soundObserver;
  
  Modifier modifier;
  
  float fireRate;
  float lastFired;
  
  Projectiles(){
    
    projectiles = new ArrayList<Projectile>();
    modifier = new Modifier();
    
    fireRate = 300;
    lastFired = fireRate;
    
  }
  
  ///
  ///Tells if the player can fire again
  ///
  boolean canFire(){
    return currentTime - lastFired >= fireRate * modifier.getVal(ValuesModifiers.FIRERATE);
  }
  void hasFired(){lastFired = currentTime;}
  
  void setModifier(Modifier mod){
    modifier = mod;
  }
  
  void setParticleObserver(ParticleObserver nobserver){
    partObserver = nobserver;
  }
  void setSoundObserver(SoundObserver nobserver){
    soundObserver = nobserver;
  }
  
  void setObservant(FiringObserver nobservant){
    observant = nobservant;
  }
  
  ///
  ///Updates all the projectiles
  ///
  void update(float deltaTime, ViewPort view){
    
    for(int i = projectiles.size() - 1; i >= 0; i--){
      
      Projectile part = projectiles.get(i);
      
      part.update(deltaTime, view);
      
      if(!part.isAlive()){
        projectiles.remove(i);
      }
      
    }
    
  }
  
  ///
  ///Checks the collision with a flock for every projectile
  ///
  void checkEnemyCollisions(Flock flock){
    
    for(Projectile part : projectiles){
      part.collide(flock.getEnemies());
    }
    
  }
  
  ///
  ///Render method relative to the view port
  ///
  void show(ViewPort view){
    
    for(Projectile part : projectiles){
      part.show(view);
    }
    
  }
  
  ///
  ///Add a projectile by its given parameters and modifier
  ///
  void addProjectile(PVector pos, PVector vel, int index){
    
    Projectile[] part = new Projectile[4];
    
    if(modifier.getAtt(AttributesModifiers.SPLIT)){
      part[0] = new Projectile(pos, vel.copy().rotate(QUARTER_PI/2), index);
      part[1] = new Projectile(pos, vel.copy().rotate(-QUARTER_PI/2), index);
    }else if(modifier.getAtt(AttributesModifiers.TRISHOT)){
      part[0] = new Projectile(pos, vel.copy(), index);
      part[1] = new Projectile(pos, vel.copy().rotate(-QUARTER_PI/4), index);
      part[2] = new Projectile(pos, vel.copy().rotate(QUARTER_PI/4), index);
    }else if(modifier.getAtt(AttributesModifiers.QUADSHOT)){
      part[0] = new Projectile(pos, vel.copy().rotate(QUARTER_PI/6), index);
      part[1] = new Projectile(pos, vel.copy().rotate(-QUARTER_PI/6), index);
      part[2] = new Projectile(pos, vel.copy().rotate(QUARTER_PI/2), index);
      part[3] = new Projectile(pos, vel.copy().rotate(-QUARTER_PI/2), index);
    }else if(modifier.getAtt(AttributesModifiers.QUADDIR)){
      part[0] = new Projectile(pos, vel.copy(), index);
      part[1] = new Projectile(pos, vel.copy().rotate(HALF_PI), index);
      part[2] = new Projectile(pos, vel.copy().rotate(PI), index);
      part[3] = new Projectile(pos, vel.copy().rotate(PI + HALF_PI), index);
    }else if(modifier.getAtt(AttributesModifiers.BACKWARDS)){
      part[0] = new Projectile(pos, vel.copy().rotate(PI), index);
    }else {
      part[0] = new Projectile(pos, vel, index);
    }
    
    
    for(int i = 0; i < part.length; i++){
      
      if(part[i] != null){
        part[i].combineModifiers(modifier);
        projectiles.add(part[i]);
        partObserver.addObservable(part[i].getParticleObservable());
        soundObserver.addObservable(part[i].getSoundObservable());
      }
      
    }
    
  }
  
  
  
  ///
  ///Removes every projectile
  ///
  void clearProjectiles(){
    projectiles.clear();
  }
  
  
  
}
