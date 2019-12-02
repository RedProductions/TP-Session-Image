class PaperParticle extends Particle{
  
  float rotation;
  
  PaperParticle(){
    
    lifeTime = 0;
    maxLifeTime = 350;
    
    pos = new PVector();
    size = new PVector((width/VIEWPORT_GRID_WIDTH)/13, (height/VIEWPORT_GRID_HEIGHT)/13);
    
    float speed = TILE_SIZE_PIXELS/85;
    
    vel = new PVector(random(-speed, speed), random(-speed, speed));
    
    acc = new PVector();
    
    rotation = random(TWO_PI);
    
    alive = true;
    
  }
  
  void update(float deltaTime){
    
    phys();
    
    timeGestion(deltaTime);
    
  }
  
  void show(){}
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
    texture(ParticleTileSet.getImage(ParticleType.PAPER));
    
    vertex(-size.x/2, -size.y/2, 0, 0);
    vertex(size.x/2, -size.y/2, imageSizeX, 0);
    vertex(size.x/2, size.y/2, imageSizeX, imageSizeY);
    vertex(-size.x/2, size.y/2, 0, imageSizeY);
    
    endShape();
    
    popMatrix();
      
    popMatrix();
    
  }
  
}
