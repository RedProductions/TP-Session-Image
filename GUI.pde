///
///On screen information
///
class GUI{
  
  
  PImage fullHearth;
  PImage halfHearth;
  PImage emptyHearth;
  
  PImage room;
  
  int health;
  int maxHealth;
  
  PVector healthPos;
  PVector healthSize;
  
  int healthImageSizeX, healthImageSizeY;
  int levelImageSizeX, levelImageSizeY;
  
  int level;
  PVector levelPos;
  PVector levelSize;
  
  
  GUI(){
    
    healthPos = new PVector(height/100, height/100);
    healthSize = new PVector(height/10, height/10);
    
    levelSize = new PVector(height/30, height/30);
    levelPos = new PVector(height/100, height - levelSize.y - height/100);
    
    
    fullHearth = loadImage("gfx/GUI/fullhearth.png");
    halfHearth = loadImage("gfx/GUI/halfhearth.png");
    emptyHearth = loadImage("gfx/GUI/emptyhearth.png");
    
    room = loadImage("gfx/GUI/room.png");
    
    healthImageSizeX = fullHearth.width;
    healthImageSizeY = fullHearth.height;
    
    levelImageSizeX = room.width;
    levelImageSizeY = room.height;
    
  }
  
  void setHealth(int nhealth){health = nhealth;}
  void setMaxHealth(int nmax){maxHealth = nmax;}
  
  void setLevel(int nlevel){level = nlevel;}
  
  ///
  ///Renders the GUI
  ///
  void show(){
    
    noStroke();
    
    for(int i = 0; i < ceil((maxHealth + maxHealth%2)/2); i++){
      
      pushMatrix();
      
      translate(healthPos.x + (healthSize.x * i) + healthSize.x/2, healthPos.y + healthSize.y/2, 7);
      
      beginShape();
      
      if((i+1)*2 <= health){
        //full hearth
        texture(fullHearth);
      }else {
        if((i+1)*2 - 1 == health){
          //half hearth
          texture(halfHearth);
        }else {
          //full hearth
          texture(emptyHearth);
        }
      }
      
      
      vertex(-healthSize.x/2, -healthSize.y/2, 0, 0);
      vertex(healthSize.x/2, -healthSize.y/2, healthImageSizeX, 0);
      vertex(healthSize.x/2, healthSize.y/2, healthImageSizeX, healthImageSizeY);
      vertex(-healthSize.x/2, healthSize.y/2, 0, healthImageSizeY);
      
      endShape();
      
      popMatrix();
      
    }
    
    
    
    for(int i = 0; i <= level; i++){
            
      pushMatrix();
      
      translate(levelPos.x + levelSize.x*i + (height/100)*(i+1), levelPos.y, 7);
      
      beginShape();
      
      texture(room);
      
      vertex(0, 0, 0, 0);
      vertex(levelSize.x, 0, levelImageSizeX, 0);
      vertex(levelSize.x, levelSize.y, levelImageSizeX, levelImageSizeY);
      vertex(0, levelSize.y, 0, levelImageSizeY);
      
      endShape();
      
      popMatrix();
      
      
    }
    
  }
  
  
}
