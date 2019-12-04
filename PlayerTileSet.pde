///
///Images needed for the Player
///
static class PlayerTileSet{
  
  static PImage[] frontImages;
  static PImage[] backImages;
  static PImage[] shootImages;
  
  static PImage[] hurtImages;
  
  static PImage[] deadImages;
  
  static int tileSizeX;
  static int tileSizeY;
  
  
  static void generate(PApplet app){
    
    frontImages = new PImage[4];
    
    frontImages[0] = app.loadImage("gfx/player/default/defchar01.png");
    frontImages[1] = app.loadImage("gfx/player/default/defchar02.png");
    frontImages[2] = app.loadImage("gfx/player/default/defchar03.png");
    frontImages[3] = app.loadImage("gfx/player/default/defchar04.png");
    
    
    
    backImages = new PImage[4];
    
    backImages[0] = app.loadImage("gfx/player/default/defcharback01.png");
    backImages[1] = app.loadImage("gfx/player/default/defcharback02.png");
    backImages[2] = app.loadImage("gfx/player/default/defcharback03.png");
    backImages[3] = app.loadImage("gfx/player/default/defcharback04.png");
    
    
    
    shootImages = new PImage[4];
    
    shootImages[0] = app.loadImage("gfx/player/default/defcharthrow01.png");
    shootImages[1] = app.loadImage("gfx/player/default/defcharthrow02.png");
    shootImages[2] = app.loadImage("gfx/player/default/defcharthrow03.png");
    shootImages[3] = app.loadImage("gfx/player/default/defcharthrow04.png");
    
    
    hurtImages = new PImage[4];
    
    hurtImages[0] = app.loadImage("gfx/player/default/defcharhurt01.png");
    hurtImages[1] = app.loadImage("gfx/player/default/defcharhurt02.png");
    hurtImages[2] = app.loadImage("gfx/player/default/defcharhurt03.png");
    hurtImages[3] = app.loadImage("gfx/player/default/defcharhurt04.png");
    
    
    deadImages = new PImage[1];
    
    deadImages[0] = app.loadImage("gfx/player/default/defchardead01.png");
    
    
    tileSizeX = frontImages[0].width;
    tileSizeY = frontImages[0].height;
    
  }
  
  static int getFrameAmount(){return frontImages.length;}
  
  static PImage getFrontTile(int index){
    if(frontImages != null){
      if(index >= 0 && index < frontImages.length){
        return frontImages[index];
      }
    }
    return null;
  }
  
  static PImage getBackTile(int index){
    if(backImages != null){
      if(index >= 0 && index < backImages.length){
        return backImages[index];
      }
    }
    return null;
  }
  
  static PImage getShootTile(int index){
    if(shootImages != null){
      if(index >= 0 && index < shootImages.length){
        return shootImages[index];
      }
    }
    return null;
  }
  
  
  static PImage getHurtTile(int index){
    if(hurtImages != null){
      if(index >= 0 && index < hurtImages.length){
        return hurtImages[index];
      }
    }
    return null;
  }
  
  
  static PImage getDeadTile(int index){
    if(deadImages != null){
      if(index >= 0 && index < deadImages.length){
        return deadImages[index];
      }
    }
    return null;
  }
  
  static int getImageWidth(){return tileSizeX;}
  static int getImageHeight(){return tileSizeY;}
  
}
