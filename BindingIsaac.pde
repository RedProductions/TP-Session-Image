void setup(){
  
  generateTileSets();
  
  surface.setResizable(true);
  size(1120, 630, P3D);
  //fullScreen(P3D);
  screenSize = new PVector(width, height);
  
  registerMethod("pre", this);
  
  env = new Enveloppe();
  
  hint(ENABLE_DEPTH_SORT);
  
  frameRate(240);
  
}



void draw(){
  
  timeCalc();
  
  
  
  env.update(deltaTime);
  
  
  
  if(currentTime - lastRefresh >= FRAME_DELTA){
    
    env.show();
    
    lastRefresh = currentTime;
    
  }
  
}


void keyPressed(){
  
  env.controll(key);
  
}

void keyReleased(){
  
  env.uncontoll(key);
  
}



void pre() {
  
  if(width != screenSize.x || height !=  screenSize.y) {
    screenSize.x = width;
    screenSize.y = height;
    if(env != null){
      env.resetSize();
    }
  }
  
}
