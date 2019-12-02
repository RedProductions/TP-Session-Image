static class ParticleTileSet{
  
  static PImage[] images;
  
  static int tileSizeX;
  static int tileSizeY;
  
  static void generate(PApplet app){
    
    images = new PImage[3];
    
    images[0] = app.loadImage("gfx/particles/Blood.png");
    images[1] = app.loadImage("gfx/particles/Paper.png");
    images[2] = app.loadImage("gfx/particles/Star.png");
    
    
    tileSizeX = images[0].width;
    tileSizeY = images[0].height;
    
  }
  
  
  static int getFrameAmount(){return images.length;}
  
  static PImage getTile(int index){return getImage(index);}
  
  static PImage getImage(int index){
    if(images != null){
      if(index >= 0 && index < images.length){
        return images[index];
      }
    }
    return null;
  }
  
  static PImage getImage(ParticleType type){
    
    switch(type){
      
      case BLOOD:
        return getImage(0);
      case PAPER:
        return getImage(1);
      case STAR:
        return getImage(2);
      default:
        return null;
      
    }
    
  }
  
  static int getImageWidth(){return tileSizeX;}
  static int getImageHeight(){return tileSizeY;}
  
  
}
