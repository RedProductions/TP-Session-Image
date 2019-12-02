class Flock{
  
  ArrayList<Enemy> flock;
  
  
  Flock(int amount, PVector origin){
    
    flock = new ArrayList<Enemy>();
    
    createFlock(amount, origin);
    
  }
  
  
  void addBoss(PVector origin, int level){
    Enemy boss = new Enemy(origin, 1000);
    boss.setBoss(level);
    flock.add(boss);
  }
  
  boolean isEmpty(){return flock.isEmpty();}
  
  ArrayList<Enemy> getEnemies(){return flock;}
  
  void update(float delta, PVector playerPos){
    
    for(int i = flock.size() - 1; i >= 0; i--){
      
      Enemy part = flock.get(i);
      
      if(part.isAlive()){
        part.addAcc(part.seek(playerPos).mult(0.5));
        part.addAcc(part.align(flock));
        part.addAcc(part.cohesion(flock));
        part.addAcc(part.separate(flock));
        part.update(delta);
      }else {
        flock.remove(i);
      }
      
    }
    
  }
  
  
  void show(ViewPort view){
    
    for(Enemy part : flock){
      part.show(view);
    }
    
  }
  
  
  void createFlock(int amount, PVector origin){
    
    for(int i = 0; i < amount; i++){
      
      flock.add(new Enemy(origin, i));
      
    }
    
  }
  
}
