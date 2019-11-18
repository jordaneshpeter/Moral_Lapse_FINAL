/*
MORAL LAPSE
Final Project Part 2: Version 2
By Jordan Eshpeter (301403448)
11/10/2019
*/

// Moral Lapse is an interactive data visualization that demonstrates the increasing awareness and effect of ethical issues in the technology 
// industry. Tweets from verified Twitter users are filtered for recency and topical relevance, plotted as points by Retweet Count and Time, and sized
// according to their Favorite Count.

import grafica.*;
import java.util.*;
import controlP5.*;
// import java.text.SimpleDateFormat*;

ArrayList<String> points = new ArrayList();

GPlot plot;
ControlP5 cp5;

void setup() {
  // Set the size of the sketch
  size(1125, 625);
  smooth();
  queryTwitter("");
  
  cp5 = new ControlP5(this);
  cp5.setColorForeground(0xffaa0000);
  cp5.setColorBackground(0xff660000);
  cp5.setColorActive(0xffff0000);

  // create a new button with name 'facebook'
  cp5.addButton("facebook")
     .setPosition(1000,50)
     .setSize(100,49)
     ;
  // create a new button with name 'amazon'
  cp5.addButton("amazon")
     .setPosition(1000,100)
     .setSize(100,49)
     ;
  // create a new button with name 'apple'     
  cp5.addButton("apple")
     .setPosition(1000,150)
     .setSize(100,49)
     ;
  // create a new button with name 'netflix'
  cp5.addButton("netflix")
     .setPosition(1000,200)
     .setSize(100,49)
     ;
  // create a new button with name 'google'
  cp5.addButton("google")
     .setPosition(1000,250)
     .setSize(100,49)
     ;
  // create a new button with name 'RESET'
  cp5.addButton("reset")
     .setPosition(1000,325)
     .setSize(100,50)
     ;
}

void queryTwitter(String arg) {

// Make the Configuration Builder object to authenticate with Twitter
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("UQuhEpQesWYPS0qOXvfUxYR1X");
  cb.setOAuthConsumerSecret("NQGzCaCOSAWsWzwu2y5PdgBi5Pjb0vhm6xdWadJP6QPA86eLKy");
  cb.setOAuthAccessToken("20475832-vIXds5SamzWqDsPFacIw7wLqF36RGkeCqiWYm1xbd");
  cb.setOAuthAccessTokenSecret("aBJjR9LFbNgxjKja2C0OpJjifaqW5uWk4nxU3gpZ7Y8LA");

// Make the Twitter object and prepare the query
  Twitter twitter = new TwitterFactory(cb.build()).getInstance();
//Query query = new Query("");
  Query query = new Query("(tech OR technology) (ethics OR moral) filter:verified -filter:retweets -filter:quote -filter:replies lang:en");
  if(arg.equalsIgnoreCase("facebook")) {
  query = new Query("(facebook OR @facebook) (ethics OR moral) -filter:retweets -filter:quote -filter:replies lang:en");
  }
  if(arg.equalsIgnoreCase("amazon")) {
  query = new Query("(amazon OR @amazon) (ethics OR moral) -filter:retweets -filter:quote -filter:replies lang:en");
  }
  if(arg.equalsIgnoreCase("apple")) {
  query = new Query("(apple OR @apple) (ethics OR moral) -filter:retweets -filter:quote -filter:replies lang:en");
  }
  if(arg.equalsIgnoreCase("netflix")) {
  query = new Query("(netflix OR @netflix) (ethics OR moral) -filter:retweets -filter:quote -filter:replies lang:en");
  }
  if(arg.equalsIgnoreCase("google")) {
  query = new Query("(google OR @google) (ethics OR moral) -filter:retweets -filter:quote -filter:replies lang:en");
  }
  //if(arg.equalsIgnoreCase("reset")) {
  //query = new Query("(tech OR technology) (ethics OR moral) filter:verified -filter:retweets -filter:quote -filter:replies lang:en");
  //}
  
  query.setCount(100);
  query.setResultType(Query.MIXED);

  // Try making the query request and build the ArrayList
  try {
    QueryResult result = twitter.search(query);
    ArrayList tweets = (ArrayList) result.getTweets();

  // Save the data in one GPointsArray and calculate the point sizes
    GPointsArray points = new GPointsArray();
    int nbrOfTweets = tweets.size();
    float[] pointSizes = new float[nbrOfTweets];
    println("There are " + nbrOfTweets + " Tweets ");
  
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
    points.add(d.getTime(), rtc, msg);
    //SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");

    // The point area is proportional to the Favorite Count
    pointSizes[i] = 15 + (fc * .08);
    }

    // Create the plot
    plot = new GPlot(this);
    plot.setDim(900, 500);
    plot.setTitleText("Moral Lapse: A Timeline of Technology Ethics");
    plot.getXAxis().setAxisLabelText("Time (the most recent seven days)");
    plot.getYAxis().setAxisLabelText("Popularity (Retweet Count)");
    plot.setLogScale("x");
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

void controlEvent(ControlEvent theEvent) {
  if(theEvent.getController().getName()=="facebook") {
    queryTwitter("facebook");
  }    
  if(theEvent.getController().getName()=="amazon") {
    queryTwitter("amazon");
  }
  if(theEvent.getController().getName()=="apple") {
    queryTwitter("apple");
  }
  if(theEvent.getController().getName()=="netflix") {
    queryTwitter("netflix");
  }
  if(theEvent.getController().getName()=="google") {
    queryTwitter("google");
  }
  if(theEvent.getController().getName()=="reset") {
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
