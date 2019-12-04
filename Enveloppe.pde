///
///Main class that holds and handles everything
///
class Enveloppe{
  
  Map map;
  ViewPort view;
  
  Player player;
  
  Particles particles;
  
  Fader fader;
  SoundPlayer soundPlayer;
  Message message;
  
  int level;
  boolean showMap;
  
  boolean createLevel;
  
  PApplet app;
  
  Enveloppe(PApplet napp){
    
    app = napp;
    
    createAll();
    
  }
  
  
  ///
  ///Updates all calculations and all physics
  ///
  void update(float deltaTime){
    
    
    if(fader.isDone()){
      
      if(player.getNextLevel() || !player.isAlive()){
        fader = new Fader();
        createLevel = true;
      }else {
        view.setPos(player.getFirePos());
        view.update(deltaTime, player.getFirePos());
        
        
        
        
        particles.update(deltaTime);
        
        player.update(deltaTime, view);
        player.checkEnemyCollisions(view.getRoom().getFlock());
        
        player.getProjectiles().checkEnemyCollisions(view.getRoom().getFlock());
        
        
      }
      
      message.update(deltaTime);
      
    }else {
      
      fader.update();
      if(fader.isFadingIn() && createLevel){
        nextLevel();
      }
      
      view.setPos(player.getFirePos());
      view.update(deltaTime, player.getFirePos());
    }
    
    soundPlayer.update();
    
  }
  
  
  ///
  ///Renders everything
  ///
  void show(){
    
    if(showMap){
      map.showFull();
    }else {
      view.show();//SCREEN RESET
      
      particles.show(view);
      
  
      player.show(view);
      
      map.update();
      map.show();
      
      message.show();
      
      if(!fader.isDone()){
        fader.show();
      }
    }
    
  }
  
  
  
  
  ///
  ///Resets the map size if the screen dimensions change (WIP)
  ///
  void resetSize(){
    
    map.resetSize();
    
  }
  
  ///
  ///Handles the key presses
  ///
  void controll(char k){
    
    if(k == 'r'){
      player.kill();
      createAll();
    }else if(k == 'm'){
      soundPlayer.toggleMusic();
    }else if(k == ENTER){
      if(SV_CHEAT){
        showMap = !showMap;
      }
    }else {
      player.controll(k);
    }
    
  }
  
  ///
  ///Handles the key releases
  ///
  void uncontoll(char k){
    
    player.uncontroll(k);
    
  }
  
  ///
  ///Generate everything for a new level
  ///
  void nextLevel(){
    
    level++;
    map = new Map(level);
    
    message = new Message();
    map.setMessageObservables(message);
    
    if(soundPlayer == null){
      soundPlayer = new SoundPlayer(app);
    }else {
      soundPlayer.clearObservables();
    }
    
    view = new ViewPort(map.getCurrentRoom());
    soundPlayer.addObservable(view.getSoundObservable());
    
    if(player == null || !player.isAlive()){
      if(player != null){
        soundPlayer.resetMusic();
      }
      player = new Player(map.getCurrentRoom());
    }else {
      player.resetLevel(map.getCurrentRoom(), level);
    }
    soundPlayer.addObservable(player.getSoundObservable());
    
    player.getProjectiles().setSoundObserver(soundPlayer.getObserver());
    
    particles = new Particles();
    particles.addObservable(player.getParticleObservable());
    
    FiringObserver firingObserver = new FiringObserver(player, player.getProjectiles());
    player.setObserver(firingObserver);
    player.getProjectiles().setObservant(firingObserver);
    player.getProjectiles().setParticleObserver(particles.getParticleObserver());
    
    map.setEnemiesObservables(particles.getParticleObserver(), soundPlayer.getObserver());
    
    view.setPos(player.getFirePos());
    
    createLevel = false;
    
  }
  
  ///
  ///Restarts the entire game
  ///
  void createAll(){
    
    createLevel = true;
    level = -1;
    nextLevel();
    
    fader = new Fader();
    fader.startUp();
    
  }
  
  
}
