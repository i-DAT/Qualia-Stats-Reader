/* Processing-Qualia-Stats-Reader */

/*
  Create the new receiver object with your API key, username and time(in milliseconds). 
  The class now handles updating, so you don't need to call the update function directly.
  When you use the class.start() function, it will update the local data with Data from the Qualia-Web-Engine, 
  repeating for each lenght of time specified.
  NOTE: This all gets calculated serverside each time this is called. 
  So *absoultely* don't make an update every frame. Updating every 5-15 mins should be enough, example below is every 30 seconds. 
*/
qualiaReceiver receiver = new qualiaReceiver("YOUR_QUALIA_API_KEY", "YOUR_QUALIA_USERNAME", 30000);


void setup(){
  
  /* 
    Gets the reciever running. It will run in the background, not locking up the visuals while you wait for an update.
    It will update the qualia data immediately, so always kick it off in the setup
  */
  receiver.start();
  
}

void draw(){
  //quick example how to use it in visuals:
  
  //check if the data set has been updated
  if (receiver.been_updated()){
      //all qualia data variables public, so easy to access 
      println(receiver.avg_Mood);
  } 
}

public class qualiaReceiver extends Thread{
  public float avg_Mood, avg_Sentiment;
  public int num_Visitors, num_Points, num_Attendances, num_Feedbacks, num_SocialMedia, num_Hotspots;
  private String API_KEY, USER, request;
  private Boolean updated;
  
  private boolean running;
  private int wait;
  
  qualiaReceiver(String api_key, String user, int time){
    /*
     Sets up Receiver Object: takes the Qualia API key and Username, builds the request string and sets the wait time between updates 
    */
    API_KEY = api_key;
    USER = user;
    request = "http://qualia.org.uk/api/v1/stats/1/?format=json&api_key=" + API_KEY + "&username=" + USER;
    
    updated = false;
    wait = time;

  }
  
  private void update() {
    /*
      Loads JSON from the Qualia API and saves to variables.
    
    */
    String result = processing.core.PApplet.join( loadStrings( request ), ""); //Using the thread class overides the join function.
    JSONObject json = new JSONObject().parse(result);
    
    avg_Mood = json.getFloat("avg_Mood");
    avg_Sentiment = json.getFloat("avg_Sentiment");
    num_Visitors = json.getInt("num_Visitors");
    num_Points = json.getInt("num_Points");
    num_Attendances = json.getInt("num_Attendances");
    num_Feedbacks = json.getInt("num_Feedbacks");
    num_SocialMedia = json.getInt("num_SocialMedia");
    num_Hotspots = json.getInt("num_Hotspots");
    
    updated = true;
  }
  
  public Boolean been_updated(){
    /*
      Provides an active check if the data has been updated in the thread. Will reset to false after a true callback
    */
    if (updated == true){
      updated = false;
      return true;
    } else{
      return false;
    }
    
  }
  
  public void start (){
    /*
      Starts the thread
    */ 
    running = true;
    System.out.println("Starting thread (will execute every " + wait + " milliseconds.)");
    super.start();
  }


  public void run (){
    /*
      Runs the update script periodically, based on what we put in the constructor.
      Will run one update immediately.
    */
    while (running){
      try {
          update();
          sleep((long)(wait));
      } catch (Exception e) {
        //Catches the exception, just incase it breaks. So we can carry on.
        System.out.println(e);
      }
    }
  }
  
  public void quit(){
    /*
      Stops the thread.
    */
    System.out.println("Quitting.");
    running = false;
    interrupt();
  }
  
}
