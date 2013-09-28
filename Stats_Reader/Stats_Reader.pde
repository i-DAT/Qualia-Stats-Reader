/* Processing-Qualia-Stats-Reader */

//create the new receiver object with your API key and username 
qualiaReceiver receiver = new qualiaReceiver("YOUR_QUALIA_API_KEY", "YOUR_QUALIA_USERNAME");

void setup(){
  
  //all variables public, so easy to access
  println(receiver.avg_Mood);
  
  /* 
    Use this (while uncommented) to update the local data with Data from the Qualia-Web-Engine
    NOTE: This all gets calculated serverside each time this is called. 
    So *absoultely* don't make an update every frame. Updating every 5-15 mins should be enough. 
  */
  // receiver.update()
  
}

class qualiaReceiver{
  float avg_Mood, avg_Sentiment;
  int num_Visitors, num_Points, num_Attendances, num_Feedbacks, num_SocialMedia, num_Hotspots;
  String API_KEY, USER, request;
  
  qualiaReceiver(String api_key, String user){
    /*
     Sets up Receiver Object: takes the Qualia API key and Username and builds the request string
    */
    API_KEY = api_key;
    USER = user;
    request = "http://qualia.org.uk/api/v1/stats/1/?format=json&api_key=" + API_KEY + "&username=" + USER;
    
    //runs an update - we want data right away
    update();

  }
  
  void update() {
    /*
      Loads JSON from the Qualia API and saves to variables.
    
    */
    String result = join( loadStrings( request ), "");
    JSONObject json = new JSONObject().parse(result);
    
    avg_Mood = json.getFloat("avg_Mood");
    avg_Sentiment = json.getFloat("avg_Sentiment");
    num_Visitors = json.getInt("num_Visitors");
    num_Points = json.getInt("num_Points");
    num_Attendances = json.getInt("num_Attendances");
    num_Feedbacks = json.getInt("num_Feedbacks");
    num_SocialMedia = json.getInt("num_SocialMedia");
    num_Hotspots = json.getInt("num_Hotspots");
  }
  
}
