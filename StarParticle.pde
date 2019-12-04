///
///Particle emmited when the Player gets hit
///
class StarParticle extends Particle{
  
  float rotation;
  
  StarParticle(){
    
    lifeTime = 0;
    maxLifeTime = 350;
    
    pos = new PVector();
    size = new PVector((width/VIEWPORT_GRID_WIDTH)/13, (height/VIEWPORT_GRID_HEIGHT)/13);
    
    float speed = TILE_SIZE_PIXELS/63;
    
    rotation = random(TWO_PI);
    
    vel = new PVector(random(-speed, speed), random(-speed, speed));
    
    acc = new PVector();
    
    alive = true;
    
  }
  
  ///
  ///Updates the calculations and the physics
  ///
  void update(float deltaTime){
    
    phys();
    
    timeGestion(deltaTime);
    
  }
  
  ///
  ///Default render method
  ///
  void show(){}
  
  ///
  ///Render method relative to the view port
  ///
  void show(ViewPort view){
    
    
    noFill();
    noStroke();
    
    
    pushMatrix();
    translate(-view.getPos().x, -view.getPos().y);
    translate(pos.x, pos.y, 1);
    
    pushMatrix();
    
    rotate(rotation);
    
    int imageSizeX = FlyTileSet.getImageWidth();
    int imageSizeY = FlyTileSet.getImageHeight();
    
    beginShape();
    texture(ParticleTileSet.getImage(ParticleType.STAR));
    
    vertex(-size.x/2, -size.y/2, 0, 0);
    vertex(size.x/2, -size.y/2, imageSizeX, 0);
    vertex(size.x/2, size.y/2, imageSizeX, imageSizeY);
    vertex(-size.x/2, size.y/2, 0, imageSizeY);
    
    endShape();
    
    popMatrix();
      
    popMatrix();
    
  }
  
}
