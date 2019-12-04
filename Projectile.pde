///
///Projectile fired by the Player
///
class Projectile extends GObject{
  
  
  float distanceTraveled;
  
  int imageIndex;
  float rotation;
  
  boolean alive;
  
  ArrayList<Integer> hitIndex;
  
  FlyProjectileObserver flyObs;
  ParticleObservable partObs;
  SoundObservable soundObs;
  
  Modifier currentMod;
  
  float hue;
  
  Projectile(PVector npos, PVector ndir, int nteam){
    
    pos = new PVector(npos.x, npos.y);
    vel = new PVector(ndir.x, ndir.y);
    size = new PVector(width/PROJECTILE_SIZE_RATIO, width/PROJECTILE_SIZE_RATIO);
    acc = new PVector(0, 0);
    
    distanceTraveled = 0;
    
    imageIndex = nteam;
    alive = true;
    
    flyObs = new FlyProjectileObserver();
    partObs = new ParticleObservable();
    soundObs = new SoundObservable();
    
    hitIndex = new ArrayList<Integer>();
    
    hue = 0;
    
    currentMod = new Modifier();
    
  }
  
  ///
  ///Combine the given modifier to its default modifier
  ///
  void combineModifiers(Modifier mod){
    currentMod.combine(mod);
    applyModifier();
  }
  
  ///
  ///Applies the attributes of its modifier
  ///
  void applyModifier(){
    
    float[] valuesMod = currentMod.getValueMods();
    
    int index = ValuesModifiers.SPEED.ordinal();
    vel.mult(valuesMod[index]);
    
    index = ValuesModifiers.SIZE.ordinal();
    size.mult(valuesMod[index]);
    if(size.x < 3){
      size.x = 3;
    }
    if(size.y < 3){
      size.y = 3;
    }
    
    if(currentMod.getAttributeMods()[AttributesModifiers.PIERCING.ordinal()] && currentMod.getAttributeMods()[AttributesModifiers.BOOMERANG.ordinal()]){
      imageIndex = 3;
    }else if(currentMod.getAttributeMods()[AttributesModifiers.PIERCING.ordinal()]){
      imageIndex = 1;
    }else if(currentMod.getAttributeMods()[AttributesModifiers.BOOMERANG.ordinal()]){
      imageIndex = 2;
    }else if(currentMod.getAttributeMods()[AttributesModifiers.BOUNCY.ordinal()]){
      imageIndex = 4;
    }
    
    if(currentMod.getAttributeMods()[AttributesModifiers.RANDOMHUE.ordinal()]){
      hue = random(255);
    }
    
  }
  
  
  boolean isAlive(){return alive;}
  
  
  int getType(){return imageIndex;}
  
  
  ParticleObservable getParticleObservable(){return partObs;}
  SoundObservable getSoundObservable(){return soundObs;}
  
  
  ///
  ///Default update method
  ///
  void update(float deltaTime){}
  
  ///
  ///Updates the calculations and physics
  ///
  void update(float deltaTime, ViewPort view){
    
    if(currentMod.getAttributeMods()[AttributesModifiers.BOOMERANG.ordinal()]){
      pos.add(vel.x * cos(distanceTraveled/(width/10)), vel.y * cos(distanceTraveled/(width/10)));
    }else if(currentMod.getAttributeMods()[AttributesModifiers.WAVE.ordinal()]){
      pos.add(vel.copy().rotate(cos(distanceTraveled/(width/10))));
    }else {
      pos.add(vel);
    }
    distanceTraveled += vel.magSq();
    pos.add(PVector.mult(vel, deltaTime/FRAME_DELTA));
    
    acc.mult(0);
    
    if(canRotate()){
      rotation += radians(3);
    }else {
      rotation = vel.heading();
    }
    
    boolean[] hitSide = view.getRoom().sideOnWall(pos, size);
    
    for(int i = 0; i < 4; i++){
    
      if(hitSide[i]){
        
        if(currentMod.getAttributeMods()[AttributesModifiers.BOUNCY.ordinal()]){
          if(i == DIR_UP || i == DIR_DOWN){
            vel.y *= -1;
          }else if(i == DIR_LEFT || i == DIR_RIGHT){
            vel.x *= -1;
          }
        }else {
          forceDestroy();
          alive = false;
        }
        
      }
      
    }
    
    limitWorld();
    
  }
  
  ///
  ///Checks collisions with multiple enemies
  ///
  void collide(ArrayList<Enemy> enemies){
    
    for(Enemy part : enemies){
      
      if(collide(part.getPos(), part.getSize())){
        if(!hitIndex.contains(part.getIndex())){
          part.getProjectileObservable().notifyObs();
          destroy();
          hitIndex.add(new Integer(part.getIndex()));
        }
      }else {
        hitIndex.remove(new Integer(part.getIndex()));
      }
      
    }
    
  }
  
  ///
  ///Tells if there is a collision with its hitbox and another
  ///
  boolean collide(PVector pos2, PVector size2){
    
    if(pos.x <= pos2.x + size2.x/2 && pos.x + size.x >= pos2.x - size2.x/2){
      if(pos.y <= pos2.y + size2.y/2 && pos.y + size.y >= pos2.y - size2.y/2){
        return true;
      }
    }
    
    return false;
    
  }
  
  ///
  ///Tells if the modifier prohibids the projectile's image
  ///
  boolean canRotate(){
    return !currentMod.getAttributeMods()[AttributesModifiers.PIERCING.ordinal()] || currentMod.getAttributeMods()[AttributesModifiers.BOOMERANG.ordinal()];
  }
  
  ///
  ///Destroy the projectile if it goes out of the world
  ///
  void limitWorld(){
    
    if(pos.x + size.x/2 < 0 || pos.x - size.x/2 > (width/GRID_RATIO) * width/VIEWPORT_GRID_RATIO){
      alive = false;
    }
    if(pos.y + size.y/2 < 0 || pos.y - size.y/2 > (height/GRID_RATIO) * width/VIEWPORT_GRID_RATIO){
      alive = false;
    }
    
  }
  
  ///
  ///Default render method
  ///
  void show(){}
  
  ///
  ///Render method relative to the view port
  ///
  void show(ViewPort view){
    
    int imageSizeX = ProjectileTileSet.getImageWidth();
    int imageSizeY = ProjectileTileSet.getImageHeight();
    
    if(DEBUG){
      stroke(0, 0, 255);
    }else {
      noStroke();
    }
    
    pushMatrix();
    
    translate(-view.getPos().x, -view.getPos().y);
    translate(pos.x + size.x/2, pos.y + size.y/2, 4);
    
    rotate(rotation);
    
    beginShape();
    
    texture(ProjectileTileSet.getImage(imageIndex));
    if(currentMod.getAttributeMods()[AttributesModifiers.RANDOMHUE.ordinal()]){
      colorMode(HSB);
      tint(hue, 255, 255);
      colorMode(RGB);
    }
    
    vertex(-size.x/2, -size.y/2, 0, 0);
    vertex(size.x/2, -size.y/2, imageSizeX, 0);
    vertex(size.x/2, size.y/2, imageSizeX, imageSizeY);
    vertex(-size.x/2, size.y/2, 0, imageSizeY);
    
    endShape();
    
    
    popMatrix();
    
    noTint();
    
  }
  
  
  ///
  ///Destroys the projectile when hit depending on the modifier
  ///
  void destroy(){
    
    if(!currentMod.getAttributeMods()[AttributesModifiers.PIERCING.ordinal()]){
      forceDestroy();
    }
    
  }
  
  ///
  ///Destroys the projectile without any restrictions
  ///
  void forceDestroy(){
    partObs.notifyObs();
    partObs.setParticleParams(pos, ParticleType.PAPER);
    
    soundObs.notifyObs();
    soundObs.setSound(Sounds.PROJECTILE_IMPACT);
    
    alive = false;
  }
  
}
