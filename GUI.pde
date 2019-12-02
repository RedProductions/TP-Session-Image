class GUI{
  
  
  PImage fullHearth;
  PImage halfHearth;
  PImage emptyHearth;
  
  
  int health;
  int maxHealth;
  
  PVector healthPos;
  PVector healthSize;
  
  int healthImageSizeX, healthImageSizeY;
  
  GUI(){
    
    healthPos = new PVector(height/100, height/100);
    healthSize = new PVector(height/10, height/10);
    
    
    fullHearth = loadImage("gfx/GUI/fullhearth.png");
    halfHearth = loadImage("gfx/GUI/halfhearth.png");
    emptyHearth = loadImage("gfx/GUI/emptyhearth.png");
    
    healthImageSizeX = fullHearth.width;
    healthImageSizeY = fullHearth.height;
    
  }
  
  void setHealth(int nhealth){health = nhealth;}
  void setMaxHealth(int nmax){maxHealth = nmax;}
  
  void show(){
    
    for(int i = 0; i < ceil((maxHealth + maxHealth%2)/2); i++){
      
      pushMatrix();
      
      translate(healthPos.x + (healthSize.x * i) + healthSize.x/2, healthPos.y + healthSize.y/2, 6);
      
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
    
  }
  
  
}
