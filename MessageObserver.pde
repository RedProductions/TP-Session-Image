///
///Observer that recieve a notification from an Observable that a Message has to be displayed
///
class MessageObserver extends Observer{
  
  ///
  ///Takes the first message available
  ///
  String getMessage(){
    
    for(Observable part : obs){
      
      if(part.isNotified()){
        part.confirmNotification();
        return ((MessageObservable)part).getMessage();
      }
      
    }
    
    return "";
    
  }
  
}
