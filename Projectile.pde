class Projectile extends GObject{
  
  int team;
  float rotation;
  
  boolean alive;
  
  
  FlyProjectileObserver flyObs;
  ParticleObservable partObs;
  
  Projectile(PVector npos, PVector ndir, int nteam){
    
    pos = new PVector(npos.x, npos.y);
    vel = new PVector(ndir.x, ndir.y);
    size = new PVector(width/PROJECTILE_SIZE_RATIO, width/PROJECTILE_SIZE_RATIO);
    acc = new PVector(0, 0);
    
    team = nteam;
    alive = true;
    
    flyObs = new FlyProjectileObserver();
    partObs = new ParticleObservable();
    
  }
  
  
  boolean isAlive(){return alive;}
  
  
  int getType(){return team;}
  
  
  ParticleObservable getParticleObservable(){return partObs;}
  void update(float deltaTime){}
  
  
  void update(float deltaTime, ViewPort view){
    
    vel.add(acc);
    pos.add(vel);
    pos.add(PVector.mult(vel, deltaTime/FRAME_DELTA));
    
    acc.mult(0);
    
    
    rotation += radians(3);
    
    boolean[] hitSide = view.getRoom().sideOnWall(pos, size);
    
    for(int i = 0; i < 4; i++){
    
      if(hitSide[i]){
        
        destroy();
        alive = false;
        
      }
      
    }
    
    
  }
  
  void collide(ArrayList<Enemy> enemies){
    
    for(Enemy part : enemies){
      
      if(collide(part.getCornerPos(), part.getSize())){
        part.notifyCollision();
        destroy();
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
  
  void show(){}
  
  void show(ViewPort view){
    
    int imageSizeX = ProjectileTileSet.getImageWidth();
    int imageSizeY = ProjectileTileSet.getImageHeight();
    
    pushMatrix();
    
    translate(-view.getPos().x, -view.getPos().y);
    translate(pos.x + size.x/2, pos.y + size.y/2, 4);
    
    rotate(rotation);
    
    beginShape();
    texture(ProjectileTileSet.getImage(team));
    
    vertex(-size.x/2, -size.y/2, 0, 0);
    vertex(size.x/2, -size.y/2, imageSizeX, 0);
    vertex(size.x/2, size.y/2, imageSizeX, imageSizeY);
    vertex(-size.x/2, size.y/2, 0, imageSizeY);
    
    endShape();
    
    
    popMatrix();
    
    
    
  }
  
  
  
  void destroy(){
    partObs.notifyObs();
    partObs.setParticleParams(pos, ParticleType.PAPER);
    alive = false;
  }
  
}
