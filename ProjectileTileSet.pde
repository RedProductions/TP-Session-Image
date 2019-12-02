static class ProjectileTileSet{
  
  static PImage[] images;
  
  static int tileSizeX;
  static int tileSizeY;
  
  ProjectileTileSet(PApplet app){
    
    generate(app);
    
  }
  
  
  static void generate(PApplet app){
    
    images = new PImage[1];
    
    images[0] = app.loadImage("gfx/projectiles/collidables/paperball.png");
    
    
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
