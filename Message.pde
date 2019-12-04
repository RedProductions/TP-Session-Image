///
///Displays a given text on the screen
///
class Message extends MessageObserver{
  
  private String message;
  
  private PVector messagePos, messageSize;
  
  private float messageTime;
  private float messageHoldTime;
  private float messageFadeTime;
  
  private float fade;
  private boolean hasMessage;
  
  private PGraphics messageImage;
  
  Message(){
    super();
    
    messageSize = new PVector(width, height/10);
    messagePos = new PVector(width/2 - messageSize.x/2, height/4 - messageSize.y/2);
    
    resetMessage("");
    
  }
  
  ///
  ///Sets a new message
  ///
  void resetMessage(String nmessage){
    
    message = nmessage;
    
    messageImage = createGraphics(floor(messageSize.x), floor(messageSize.y));
    
    generateMessage();
    
    
    fade = 255;
    
    messageTime = 0;
    
    messageHoldTime = 1000;
    messageFadeTime = 1500;
    
    
    
  }
  
  ///
  ///Render the message on the image
  ///
  void generateMessage(){
    
    if(message.length() > 0){
      
      hasMessage = true;
      
      //BLACK TEXT WITH WHITE OUTLINE
      float messagePosX = messageImage.width/2;
      float messagePosY = messageImage.height/2;
      
      messageImage.beginDraw();
      
      messageImage.textAlign(CENTER, CENTER);
      messageImage.textSize(messageSize.y*0.8);
      
      messageImage.fill(255);
      messageImage.text(message, messagePosX - 1, messagePosY);
      messageImage.text(message, messagePosX + 1, messagePosY);
      messageImage.text(message, messagePosX, messagePosY - 1);
      messageImage.text(message, messagePosX, messagePosY + 1);
      
      messageImage.fill(0);
      messageImage.text(message, messagePosX, messagePosY);
      
      messageImage.endDraw();
      
    }
    
  }
  
  
  ///
  ///Updates the fade time of the message
  ///
  void update(float deltaTime){
    
    if(!hasMessage){
      if(isNotified()){
        resetMessage(getMessage());
      }
    }else {
      
      if(messageTime > messageHoldTime){
        
        fade = 255 - ((messageTime - messageHoldTime) * 255 / messageFadeTime);
        
        if(fade <= 0){
          hasMessage = false;
        }
        
      }else {
        fade = 255;
      }
      
      messageTime += deltaTime;
      
    }
    
  }
  
  ///
  ///Display the pre-rendered message
  ///
  void show(){
    
    if(hasMessage){
      
      pushMatrix();
      
      translate(messagePos.x, messagePos.y, 7);
      
      beginShape();
      texture(messageImage);
      tint(255, fade);
      
        vertex(0, 0, 0, 0);
        vertex(messageSize.x, 0, messageImage.width, 0);
        vertex(messageSize.x, messageSize.y, messageImage.width, messageImage.height);
        vertex(0, messageSize.y, 0, messageImage.height);
        
      endShape();
      
      popMatrix();
      
      noTint();
      
    }
    
  }
  
  
}
