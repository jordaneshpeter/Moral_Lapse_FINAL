/*
MORAL LAPSE
Final Project Part 2: Version 2
By Jordan Eshpeter (301403448)
11/26/2019
 */
// Moral Lapse is an interactive data visualization that demonstrates the increasing awareness and effect of ethical issues in the technology 
// industry. Tweets from verified Twitter users are filtered for recency and topical relevance, plotted as points by Retweet Count and Time, and sized
// according to their Favorite Count.

// Import libraries for plotting, Twitter integration, and graphical user interface elements
import grafica.*;
import java.util.*;
import controlP5.*;

ArrayList<String> points = new ArrayList();
ArrayList<String> words = new ArrayList();

// Declare global classes and objects
GPlot plot;
ControlP5 cp5;
processing.data.JSONObject afinn = new processing.data.JSONObject();

// Setup the sketch
void setup() {
  size(1125, 625);
  smooth();
  // Declare queryTwitter function with a String argument
  queryTwitter("");
  //Initialize the cp5 object for buttons and set default colours
  cp5 = new ControlP5(this);
  cp5.setColorForeground(#a5a6a9);
  cp5.setColorBackground(#2f292b);
  cp5.setColorActive(#f45844);
  // Create a new button with name 'facebook'
  cp5.addButton("facebook")
    .setPosition(1000, 50)
    .setSize(100, 49)
    ;
  // Create a new button with name 'amazon'
  cp5.addButton("amazon")
    .setPosition(1000, 100)
    .setSize(100, 49)
    ;
  // Create a new button with name 'apple'     
  cp5.addButton("apple")
    .setPosition(1000, 150)
    .setSize(100, 49)
    ;
  // Create a new button with name 'netflix'
  cp5.addButton("netflix")
    .setPosition(1000, 200)
    .setSize(100, 49)
    ;
  // Create a new button with name 'google'
  cp5.addButton("google")
    .setPosition(1000, 250)
    .setSize(100, 49)
    ;
  // Create a new button with name 'RESET'
  cp5.addButton("reset")
    .setPosition(1000, 325)
    .setSize(100, 50)
    ;
}
// Introduce function and statements to query Twitter
void queryTwitter(String arg) {
  // Make the Configuration Builder object to authenticate with Twitter
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("UQuhEpQesWYPS0qOXvfUxYR1X");
  cb.setOAuthConsumerSecret("NQGzCaCOSAWsWzwu2y5PdgBi5Pjb0vhm6xdWadJP6QPA86eLKy");
  cb.setOAuthAccessToken("20475832-vIXds5SamzWqDsPFacIw7wLqF36RGkeCqiWYm1xbd");
  cb.setOAuthAccessTokenSecret("aBJjR9LFbNgxjKja2C0OpJjifaqW5uWk4nxU3gpZ7Y8LA");
  afinn = loadJSONObject("AFINN-111.json");
  
  // Make the Twitter object and prepare the query
  Twitter twitter = new TwitterFactory(cb.build()).getInstance();
  // Primary query for the most influential technology and ethics Tweets
  Query query = new Query("(tech OR technology) (ethics OR moral) filter:verified -filter:retweets -filter:quote -filter:replies lang:en");
  query.setResultType(Query.MIXED);
  
  // Compare queries with event listener and button name arguments (i.e., F.A.A.N.G.)
  if (arg.equalsIgnoreCase("facebook")) {
    query = new Query("(facebook OR @facebook) (ethics OR ethic) -filter:retweets -filter:quote -filter:replies lang:en");
    query.setResultType(Query.MIXED);
  }
  if (arg.equalsIgnoreCase("amazon")) {
    query = new Query("(amazon OR @amazon) (ethics OR ethic) -filter:retweets -filter:quote -filter:replies lang:en");
    query.setResultType(Query.MIXED);
  }
  if (arg.equalsIgnoreCase("apple")) {
    query = new Query("(apple OR @apple) (ethics OR ethic) -filter:retweets -filter:quote -filter:replies lang:en");
    query.setResultType(Query.MIXED);
  }
  if (arg.equalsIgnoreCase("netflix")) {
    query = new Query("(netflix OR @netflix) (ethics OR ethic) -filter:retweets -filter:quote -filter:replies lang:en");
    query.setResultType(Query.MIXED);
  }
  if (arg.equalsIgnoreCase("google")) {
    query = new Query("(google OR @google) (ethics OR ethic) -filter:retweets -filter:quote -filter:replies lang:en");
    query.setResultType(Query.MIXED);
  }
  query.setCount(100);
  
  // Try making the query request and build the ArrayList
  try {
    QueryResult result = twitter.search(query);
    ArrayList tweets = (ArrayList) result.getTweets();
    // Save the data in one GPointsArray and calculate the point sizes
    GPointsArray points = new GPointsArray();
    int nbrOfTweets = tweets.size();
    color[] pointColors = new color[nbrOfTweets];
    float[] pointSizes = new float[nbrOfTweets];
    //color[] pointColors = new color[nbrOfTweets];
    println("There are " + nbrOfTweets + " Tweets ");
    int[] scoredTweets = new int[100];
    // For each Tweet in the ArrayList, plot a point by Time and Retweet Count
    for (int i = 0; i < tweets.size(); i++) {
      Status t = (Status) tweets.get(i);
      User u = (User) t.getUser();
      String user = u.getName();
      String msg = t.getText();
      int rtc = t.getRetweetCount();
      int fc = t.getFavoriteCount();
      Date d = t.getCreatedAt();
      println("Tweet by " + user + " at " + d + " and Retweeted " + rtc + " times and Favourited " + fc + " times: ");

      //Break the tweet into an arrary of words
      String[] input = msg.replaceAll("[^a-zA-Z ]", "").toLowerCase().split("\\s+");
      // Initialize the aggregated score of one tweet;
      int score = 0; 
      for (int j = 0;  j < input.length; j++) {
        //Put each word into the words ArrayList
        try {
          String word = input[j];
          score += afinn.getInt(word.toLowerCase());
        }
        catch (Exception e) {
        }
      }
    
    scoredTweets[i] = score;
    color assignedColor;
    if(score > 0)
    {
      assignedColor = color(#f45844, 150);
    }
    else if(score == 0)
    {
      assignedColor = color(#2f292b, 150);
    }
    else 
    {
      assignedColor = color(#008cbc, 150);
    }
    pointColors[i] = assignedColor;
    
    // The point area is proportional to the Favorite Count
    points.add(d.getTime(), rtc, msg);
    pointSizes[i] = 15 + (fc * .015);
    //pointColors[i] = 
    
  }
    println(scoredTweets);
    
    // Initialize the plot object and methods
    plot = new GPlot(this);
    plot.setDim(900, 500);
    plot.setTitleText("Moral Lapse: A Timeline of Technology Ethics");
    plot.getXAxis().setAxisLabelText("Time");
    plot.getYAxis().setAxisLabelText("Popularity (Retweet Count)");
    plot.getXAxis().setNTicks(10);
    plot.setLogScale("x");
    plot.setPointColors(pointColors);
    plot.setPoints(points);
    plot.setPointSizes(pointSizes);
    plot.activatePointLabels();
    plot.activatePanning();
    plot.activateZooming(1.05, CENTER, CENTER);
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}

  // Listen for events per button by name and call the related queryTwitter function
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.getController().getName()=="facebook") {
      queryTwitter("facebook");
    }    
    if (theEvent.getController().getName()=="amazon") {
      queryTwitter("amazon");
    }
    if (theEvent.getController().getName()=="apple") {
      queryTwitter("apple");
    }
    if (theEvent.getController().getName()=="netflix") {
      queryTwitter("netflix");
    }
    if (theEvent.getController().getName()=="google") {
      queryTwitter("google");
    }
    if (theEvent.getController().getName()=="reset") {
      queryTwitter("reset");
    }
  }

void draw() {
  // Clean the screen
  background(255);
  // Draw the plot
  plot.beginDraw();
  plot.drawBox();
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTitle();
  plot.drawGridLines(GPlot.BOTH);
  plot.drawPoints();
  plot.drawLabels();
  plot.endDraw();
}
