///
///Images needed for the Projectile
///
static class ProjectileTileSet{
  
  static PImage[] images;
  
  static int tileSizeX;
  static int tileSizeY;
  
  
  static void generate(PApplet app){
    
    images = new PImage[5];
    
    images[0] = app.loadImage("gfx/projectiles/collidables/paperball.png");
    images[1] = app.loadImage("gfx/projectiles/collidables/pencil.png");
    images[2] = app.loadImage("gfx/projectiles/collidables/boomerang.png");
    images[3] = app.loadImage("gfx/projectiles/collidables/boomerpencil.png");
    images[4] = app.loadImage("gfx/projectiles/collidables/ball.png");
    
    
    tileSizeX = images[0].width;
    tileSizeY = images[0].height;
    
  }
  
  static int getFrameAmount(){return images.length;}
  
  static PImage getImage(int index){
    if(images != null){
      if(index >= 0 && index < images.length){
        return images[index];
      }
    }
    return null;
  }
  
  static int getImageWidth(){return tileSizeX;}
  static int getImageHeight(){return tileSizeY;}
  
}
