class Enveloppe{
  
  Map map;
  ViewPort view;
  
  Player player;
  Projectiles projectiles;
  
  Particles particles;
  
  Fader fader;
  
  int level;
  
  boolean showMap;
  boolean createLevel;
  
  Enveloppe(){
    
    createAll();
    
  }
  
  
  
  void update(float deltaTime){
    
    
    if(fader.isDone()){
      
      if(player.getNextLevel() || !player.isAlive()){
        fader = new Fader();
        createLevel = true;
      }else {
        view.setPos(player.getFirePos());
        view.update(deltaTime, player.getFirePos());
        
        projectiles.update(deltaTime, view);
        projectiles.checkEnemyCollisions(view.getRoom().getFlock());
        
        
        particles.update(deltaTime);
        
        player.update(deltaTime, view);
        player.checkEnemyCollisions(view.getRoom().getFlock());
        
        
      }
      
    }else {
      
      fader.update();
      if(fader.isFadingIn() && createLevel){
        nextLevel();
      }
      
      view.setPos(player.getFirePos());
      view.update(deltaTime, player.getFirePos());
    }
    
    
  }
  
  
  
  void show(){
    
    if(showMap){
      map.show();
    }else {
      view.show();
      
      particles.show(view);
      
      projectiles.show(view);
      player.show(view);
      
      
      if(!fader.isDone()){
        fader.show();
      }
      
    }
    
  }
  
  
  
  
  
  void resetSize(){
    
    map.resetSize();
    
  }
  
  void controll(char k){
    
    if(k == 'r'){
      createAll();
    }else if(k == 'm'){
      showMap = !showMap;
    }else {
      player.controll(k);
    }
    
  }
  
  void uncontoll(char k){
    
    player.uncontroll(k);
    
  }
  
  void nextLevel(){
    
    level++;
    map = new Map(level);
    //map.show();
    
    view = new ViewPort(map.getCurrentRoom());
    
    if(player == null || !player.isAlive()){
      player = new Player(map.getCurrentRoom());
    }else {
      player.resetLevel(map.getCurrentRoom());
    }
    
    projectiles = new Projectiles();
    
    particles = new Particles();
    particles.addObservable(player.getParticleObservable());
    
    FiringObserver firingObserver = new FiringObserver(player, projectiles);
    player.setObserver(firingObserver);
    projectiles.setObservant(firingObserver);
    projectiles.setObserver(particles.getParticleObserver());
    
    map.setEnemiesObservables(particles.getParticleObserver());
    
    view.setPos(player.getFirePos());
    
    createLevel = false;
    
  }
  
  
  void createAll(){
    
    createLevel = true;
    level = -1;
    nextLevel();
    
    fader = new Fader();
    fader.startUp();
    
  }
  
  
}
