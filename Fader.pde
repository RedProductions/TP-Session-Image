///
///Fade In/Out at the beginning/end of a level
///
class Fader{
  
  float alpha;
  
  float alphaChangeRate;
  float lastAlphaChanged;
  
  boolean up;
  boolean done;
  
  Fader(){
    
    alpha = 0;
    
    alphaChangeRate = FADER_SPEED;
    lastAlphaChanged = currentTime;
    
    up = true;
    done = false;
    
  }
  
  ///
  //Makes the fader start already black
  ///
  void startUp(){
    up = false;
    alpha = 255;
    alphaChangeRate = FADER_STOP;
  }
  
  boolean isDone(){return done;}
  boolean isFadingIn(){return !up;}
  
  ///
  ///Updates the fade amount
  ///
  void update(){
    
    if(up){
      
      if(currentTime - lastAlphaChanged >= alphaChangeRate){
        alpha++;
        if(alpha == 255){
          up = false;
          alphaChangeRate = FADER_STOP;
        }
        lastAlphaChanged = currentTime;
      }
      
    }else {
      
      if(currentTime - lastAlphaChanged >= alphaChangeRate){
        alpha--;
        if(alpha == 0){
          done = true;
        }
        lastAlphaChanged = currentTime;
        alphaChangeRate = FADER_SPEED;
      }
      
    }
    
  }
  
  ///
  ///Renders the fade
  ///
  void show(){
    
    noStroke();
    fill(0, alpha);
    
    pushMatrix();
    translate(0, 0, 50);
    
    rect(-50, -100, width + 100, height + 200);
    
    popMatrix();
    
  }
  
}
