///
///Program initiation
///
void setup(){
  
  surface.setResizable(true);
  size(1120, 630, P3D);
  //fullScreen(P3D);
  screenSize = new PVector(width, height);
  registerMethod("pre", this);
  hint(ENABLE_DEPTH_SORT);
  frameRate(240);
  
  generateTileSets();
  
  env = new Enveloppe(this);
  
  printToDoList();
  
}


///
///Main loop
///
void draw(){
  
  timeCalc();
  
  
  
  env.update(deltaTime);
  
  
  
  if(currentTime - lastRefresh >= FRAME_DELTA){
    
    env.show();
    
    lastRefresh = currentTime;
    
  }
  
}

///
///Trigger on keyboard press
///
void keyPressed(){
  
  env.controll(key);
  
}

///
///Trigger on keyboard release
///
void keyReleased(){
  
  env.uncontoll(key);
  
}


///
///Screen resize detection
///
void pre() {
  
  if(width != screenSize.x || height !=  screenSize.y) {
    screenSize.x = width;
    screenSize.y = height;
    if(env != null){
      env.resetSize();
    }
  }
  
}


///
///Personnal list of things to do
///
void printToDoList(){
  
  println("===========================");
  println("===========TO DO===========");
  println("===========04/12===========");
  println("===========================");
  println("=========IMPORTANT=========");
  println("-Fix cam glitch on edges    ->    fixes tiles unalignment with collisions                                      [?]");
  println("-Make image for level completed amount (bottom left GUI)    ->    fixes clamping of squares                    [X]");
  println("-Limit projectile sizes (down)    ->    PREVENTS projectiles form being too small too be seen                  [X]");
  println("===========================");
  println("=======WOULD BE NICE=======");
  println("-Make more items with more attributes                                                                          [ ]");
  println("===========================");
  println("==========DETAILS==========");
  println("-Make fly hurt sound                                                                                           [ ]");
  println("-Make ambiant fly sound                                                                                        [ ]");
  println("-Make more projectile images                                                                                   [ ]");
  println("===========================");
  
}
