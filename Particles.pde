class Particles{
  
  ArrayList<Particle> particles;
  ParticleFactory factory;
  
  ParticleObserver obs;
  
  Particles(){
    
    particles = new ArrayList<Particle>();
    factory = new ParticleFactory();
    
    obs = new ParticleObserver();
    
  }
  
  
  ParticleObserver getParticleObserver(){return obs;}
  
  
  void update(float deltaTime){
    
    for(int i = particles.size() - 1; i >= 0; i--){
      
      Particle part = particles.get(i);
      
      part.update(deltaTime);
      
      if(!part.isAlive()){
        particles.remove(i);
      }
      
    }
    
    
    if(obs.hasNotification()){
      ParticleParams params = obs.getParams();
      PVector spawnPoint = params.spawnPoint;
      ParticleType type = params.type;
      addParticles(int(random(3, 5)), spawnPoint, type);
    }
    
  }
  
  
  void show(ViewPort view){
    
    for(Particle part : particles){
      part.show(view);
    }
    
  }
  
  
  
  
  
  void addParticle(PVector pos, ParticleType type){
    
    Particle part = factory.getParticle(type);
    part.setPos(pos);
    particles.add(part);
    
  }
  
  
  void addParticles(int amount, PVector pos, ParticleType type){
    
    for(int i = 0; i < amount; i++){
      addParticle(pos, type);
    }
    
  }
  
  void addObservable(Observable nobs){
    obs.addObservable(nobs);
  }
  
  void addObservables(ArrayList<Observable> nobs){
    for(Observable part : nobs){
      obs.addObservable(part);
    }
  }
  
}
