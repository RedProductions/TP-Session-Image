/***************************************************************\
|                                                               |
|  Boids source:                                                |
|                                                               |
|  https://github.com/nbourre/demo_boids/blob/master/Mover.pde  |
|                                                               |
\***************************************************************/


///
///Flies that act as a boid
///
class Enemy extends GObject {
  
  float topSpeed = 0.30;
  float topSteer = 0.015;
  
  float theta = 0;
  float r;
  
  float radiusSeparation;
  float radiusAlignement;
  float radiusCohesion;
  
  
  float seperationWeight;
  
  int frame;
  
  float imageChangeRate;
  float lastImageChanged;
  
  
  FlyProjectileObservable projObs;
  ParticleObservable partObs;
  SoundObservable soundObs;
  
  int index;
  
  int life;
  boolean alive;
  boolean boss;
  
  Enemy () {
    pos = new PVector();
    vel = new PVector();
    acc = new PVector();
  }
  
  
  Enemy (PVector npos, int nindex) {
    
    
    r = height/50;
    
    float speedRange = TILE_SIZE_PIXELS/80;
    
    pos = new PVector(npos.x + random(-r*3, r*3), npos.y + random(-r*3, r*3));
    vel = new PVector(random(-speedRange, speedRange), random(-speedRange, speedRange));
    acc = new PVector (0 , 0);
    
    radiusSeparation = 15*r;
    radiusAlignement = 25*r;
    radiusCohesion = 30*r;
    
    seperationWeight = 1.5;
    
    frame = int(random(FlyTileSet.getFrameAmount()));
    imageChangeRate = round(random(25, 75));
    lastImageChanged = 0;
    
    index = nindex;
    projObs = new FlyProjectileObservable();
    projObs.setIndex(index);
    
    partObs = new ParticleObservable();
    
    soundObs = new SoundObservable();
    
    
    alive = true;
    life = 2;
    
  }
  
  ///
  ///Makes the enemy a boss enemy
  ///
  void setBoss(int level){
    r = height/15;
    life = 10 + floor(level*2);
    topSpeed = 0.30 * (float(level+1)/3);
    topSteer = 0.012 * (float(level+1)/2);
    boss = true;
  }
  
  boolean isAlive(){return alive;}
  
  PVector getPos(){return pos;}
  PVector getCornerPos(){return new PVector(pos.x - r, pos.y - r);}
  PVector getSize(){return new PVector(r, r);}
  PVector getScreenPos(ViewPort view){return new PVector(pos.x - view.getPos().x + r, pos.y - view.getPos().y + r);}
  
  int getIndex(){return index;}
  
  FlyProjectileObservable getProjectileObservable(){return projObs;}
  ParticleObservable getParticleObservable(){return partObs;}
  SoundObservable getSoundObservable(){return soundObs;}
  
  ///
  ///Notifies the projectile that it has hit
  ///
  void notifyCollision(){
    projObs.notifyObs();
  }
  
  ///
  ///Accelerates the entity
  ///
  void addAcc(PVector nacc){
    acc.add(nacc);
  }
  
  ///
  ///Updates calculations and physics 
  ///
  void update(float deltaTime) {
    
    if(projObs.isNotified()){
      life--;
      bleed();
      if(life <= 0){
        alive = false;
      }
      projObs.confirmNotification();
    }
    
    vel.add (acc);
    vel.limit(topSpeed * 1120 / width);
    pos.add (vel);

    acc.mult (0);    
    
    if(currentTime - lastImageChanged >= imageChangeRate){
      
      frame = (frame+1)%FlyTileSet.getFrameAmount();
      
      lastImageChanged = currentTime;
      
    }
    
  }
  
  
  
  ///
  ///Default render method
  ///
  void show(){}
  
  ///
  ///Render method relative to the view port
  ///
  void show(ViewPort view) {
    
    noFill();
    if(DEBUG){
      stroke(255, 0, 0);
    }else {
      noStroke();
    }
    
    theta = vel.heading() + radians(90);
    
    pushMatrix();
    translate(-view.getPos().x, -view.getPos().y);
    translate(pos.x, pos.y, 3);
    
    pushMatrix();
    //rotate (theta);
    
    
    
    int imageSizeX = FlyTileSet.getImageWidth();
    int imageSizeY = FlyTileSet.getImageHeight();
    
    beginShape();
    texture(FlyTileSet.getImage(frame));
    
    vertex(-r, -r, 0, 0);
    vertex(r, -r, imageSizeX, 0);
    vertex(r, r, imageSizeX, imageSizeY);
    vertex(-r, r, 0, imageSizeY);
    
    endShape();
    
    popMatrix();
    
      
    popMatrix();
    
    //limitScreen(view);
    
  }
  
  ///
  ///Flock separation
  ///
  PVector separate (ArrayList<Enemy> Enemys) {
    PVector steer = new PVector(0, 0, 0);
    
    int count = 0;
    
    for (Enemy other : Enemys) {
      float d = PVector.dist(pos, other.pos);
      
      if (d > 0 && d < radiusSeparation) {
        PVector diff = PVector.sub(pos, other.pos);
        
        diff.normalize();
        diff.div(d);
        
        steer.add(diff);
        
        count++;
      }
    }
    
    if (count > 0) {
      steer.div(count);
    }
    
    if (steer.mag() > 0) {
      steer.setMag(topSpeed);
      steer.sub(vel);
      steer.limit(topSteer);
    }
    
    return steer.mult(seperationWeight);
  }
  
  ///
  ///Flock alignment
  ///
  PVector align (ArrayList<Enemy> Enemys) {
    PVector sum = new PVector(0, 0);
    
    int count = 0;
    
    for (Enemy other : Enemys) {
      float d = PVector.dist (this.pos, other.pos);
      
      if (d > 0 && d < radiusAlignement) {
        sum.add (other.vel);
        count++;
      }
    }
    
    if (count > 0) {
      sum.div((float)count);
      sum.setMag(topSpeed);
      
      PVector steer = PVector.sub (sum, this.vel);
      steer.limit (topSteer);
      
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }
  
  ///
  ///Flock attraction
  ///
  PVector cohesion(ArrayList<Enemy> Enemys) {
    PVector sum = new PVector(0, 0);
    
    int count = 0;
    
    for (Enemy other : Enemys) {
      float d = PVector.dist(this.pos, other.pos);
      if (d > 0 && d < radiusCohesion) {
        sum.add(other.pos);
        count++;
      }
    }
    
    if (count > 0) {
      sum.div(count);
      return seek(sum);
    
    }
    else {
      return new PVector(0, 0);
    }
  }
  
  ///
  ///Sets the boid a directionnal goal
  ///
  PVector seek (PVector target) {
    // Vecteur différentiel vers la cible
    PVector desired = PVector.sub (target, this.pos);
    
    // VITESSE MAXIMALE VERS LA CIBLE
    desired.setMag(topSpeed);
    
    // Braquage
    PVector steer = PVector.sub (desired, vel);
    steer.limit(topSteer);
    
    return steer;    
  }
  
  
  
  ///
  ///Damage the enemy
  ///
  void bleed(){
    partObs.notifyObs();
    if(boss){
      partObs.setParticleParams(pos, ParticleType.MEGABLOOD);
    }else {
      partObs.setParticleParams(pos, ParticleType.BLOOD);
    }
    
    soundObs.notifyObs();
    if(boss){
      if(life <= 0){
        soundObs.setSound(Sounds.BIG_FLY_DIE);
      }else {
        soundObs.setSound(Sounds.BIG_FLY_HURT);
      }
    }else {
      soundObs.setSound(Sounds.FLY_DIE);
    }
    
    
  }
  
  
  
}
