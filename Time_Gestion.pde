float currentTime = 0;
float pastTime = 0;

float deltaTime = 0;


float lastRefresh = 0;

///
///Handles the time related variables
///
void timeCalc(){
  
  
  pastTime = currentTime;
  currentTime = millis();
  
  deltaTime = currentTime - pastTime;
  
}
