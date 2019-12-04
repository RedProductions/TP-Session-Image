///
///Images of the Enemy
///
static class FlyTileSet{
  
  static PImage[] images;
  
  static int tileSizeX;
  static int tileSizeY;
  
  
  static void generate(PApplet app){
    
    images = new PImage[4];
    
    images[0] = app.loadImage("gfx/enemies/fly/fly1.png");
    images[1] = app.loadImage("gfx/enemies/fly/fly2.png");
    images[2] = app.loadImage("gfx/enemies/fly/fly3.png");
    images[3] = app.loadImage("gfx/enemies/fly/fly4.png");
    
    
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
