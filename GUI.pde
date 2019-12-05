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
  
  ArrayList<String> modifiers;
  
  
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
    
    modifiers = new ArrayList<String>();
    
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
    
    
    textSize(height/40);
    
    float currentPosX = height/100;
    float currentPosY = healthPos.y + healthSize.y + height/50;
    for(String part : modifiers){
      
      fill(0, 0);
      rect(currentPosX-1, currentPosY-1, textWidth(part)+1, height/50 + 1);
      
      fill(200);
      text(part, currentPosX + 1, currentPosY);
      text(part, currentPosX - 1, currentPosY);
      text(part, currentPosX, currentPosY + 1);
      text(part, currentPosX, currentPosY - 1);
      
      pushMatrix();
      translate(0, 0, 1);
      
      fill(0);
      text(part, currentPosX, currentPosY);
      
      popMatrix();
      
      currentPosY += textAscent();
      
    }
    
    
    if(frameRate < 60){
      
      stroke(200, 0, 0);
      noFill();
      
      if(frameRate < 30){
        fill(200, 0, 0);
      }
      
      
      rect(width - width/50, height - height/60, width/100, height/120);
      
    }
    
  }
  
  void addModifierName(String name){
    modifiers.add(name);
  }
  
}
