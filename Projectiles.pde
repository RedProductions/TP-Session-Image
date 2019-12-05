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
    
    ArrayList<Projectile> spawn = new ArrayList<Projectile>();
    
    int spawnAmount = 1;
    float angleStep = 0;
    float angleOffset = 0;
    
    if(modifier.getAtt(AttributesModifiers.QUADSHOT)){
      spawnAmount = 4;
      angleStep = QUARTER_PI/6;
      angleOffset = -QUARTER_PI/3;
    }else if(modifier.getAtt(AttributesModifiers.TRISHOT)){
      spawnAmount = 3;
      angleStep = QUARTER_PI/4;
      angleOffset = -QUARTER_PI/4;
    }
    
    if(modifier.getAtt(AttributesModifiers.QUADDIR)){
      for(int i = 0; i < 4; i++)
        spawnProjectiles(pos, vel, index, spawn, HALF_PI*i, angleOffset, spawnAmount, angleStep);
    }else if(modifier.getAtt(AttributesModifiers.SPLIT)){
      spawnProjectiles(pos, vel, index, spawn, QUARTER_PI/2, angleOffset, spawnAmount, angleStep);
      spawnProjectiles(pos, vel, index, spawn, -QUARTER_PI/2, angleOffset, spawnAmount, angleStep);
    }else if(modifier.getAtt(AttributesModifiers.BACKWARDS)){
      spawnProjectiles(pos, vel, index, spawn, PI, angleOffset, spawnAmount, angleStep);
    }else {
      spawnProjectiles(pos, vel, index, spawn, 0, angleOffset, spawnAmount, angleStep);
    }
    
    
    for(Projectile part : spawn){
      
      part.combineModifiers(modifier);
      projectiles.add(part);
      partObserver.addObservable(part.getParticleObservable());
      soundObserver.addObservable(part.getSoundObservable());
      
    }
    
  }
  
  void spawnProjectiles(PVector pos, PVector vel, int index, ArrayList<Projectile> spawn, float angle, float offset, int amount, float step){
    for(int i = 0; i < amount; i++){
      spawn.add(new Projectile(pos, vel.copy().rotate((angle + offset) + step*i), index));
    }
  }
  
  
  
  ///
  ///Removes every projectile
  ///
  void clearProjectiles(){
    projectiles.clear();
  }
  
  
  
}
