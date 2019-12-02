class Projectiles{
  
  ArrayList<Projectile> projectiles;
  FiringObserver observant;
  
  ParticleObserver partObserver;
  
  Projectiles(){
    
    projectiles = new ArrayList<Projectile>();
    
  }
  
  void setObserver(ParticleObserver nobserver){
    partObserver = nobserver;
  }
  
  void setObservant(FiringObserver nobservant){
    observant = nobservant;
  }
  
  void update(float deltaTime, ViewPort view){
    
    for(int i = projectiles.size() - 1; i >= 0; i--){
      
      Projectile part = projectiles.get(i);
      
      part.update(deltaTime, view);
      
      if(!part.isAlive()){
        projectiles.remove(i);
      }
      
    }
    
  }
  
  
  void checkEnemyCollisions(Flock flock){
    
    for(Projectile part : projectiles){
      part.collide(flock.getEnemies());
    }
    
  }
  
  void show(ViewPort view){
    
    for(Projectile part : projectiles){
      part.show(view);
    }
    
  }
  
  void addProjectile(PVector pos, PVector vel, int index){
    Projectile part = new Projectile(pos, vel, index);
    projectiles.add(part);
    partObserver.addObservable(part.getParticleObservable());
  }
  
  
  
}
