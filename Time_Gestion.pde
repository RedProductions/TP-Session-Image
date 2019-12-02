float currentTime = 0;
float pastTime = 0;

float deltaTime = 0;


float lastRefresh = 0;

void timeCalc(){
  
  
  pastTime = currentTime;
  currentTime = millis();
  
  deltaTime = currentTime - pastTime;
  
}
