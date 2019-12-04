///
///Group of fly Enemy in a room
///
class Flock{
  
  ArrayList<Enemy> flock;
  
  
  Flock(int amount, PVector origin){
    
    flock = new ArrayList<Enemy>();
    
    createFlock(amount, origin);
    
  }
  
  ///
  ///Adds a boss enemy to the flock
  ///
  void addBoss(PVector origin, int level){
    Enemy boss = new Enemy(origin, 1000);
    boss.setBoss(level);
    flock.add(boss);
  }
  
  boolean isEmpty(){return flock.isEmpty();}
  
  ArrayList<Enemy> getEnemies(){return flock;}
  
  ///
  ///Updates the calculations and physics
  ///
  void update(float delta, PVector playerPos){
    
    for(int i = flock.size() - 1; i >= 0; i--){
      
      Enemy part = flock.get(i);
      
      if(part.isAlive()){
        part.addAcc(part.seek(playerPos).mult(0.5));
        if(flock.size() > 3){
          part.addAcc(part.align(flock));
          part.addAcc(part.cohesion(flock));
          part.addAcc(part.separate(flock));
        }
        part.update(delta);
      }else {
        flock.remove(i);
      }
      
    }
    
  }
  
  ///
  ///Renders every boid
  ///
  void show(ViewPort view){
    
    for(Enemy part : flock){
      part.show(view);
    }
    
  }
  
  ///
  ///Generates a flock with its given parameters
  ///
  void createFlock(int amount, PVector origin){
    
    for(int i = 0; i < amount; i++){
      
      flock.add(new Enemy(origin, i));
      
    }
    
  }
  
}
