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
//Query query;

//String textValue = "";

// 1. String flags = ""; FLAGS
// Array for FANG Facebook [0], Amazon [1]
// Text input to flags variable

void setup() {
  // Set the size of the sketch
  size(1000, 700);
  //  PFont font = createFont("arial",12);
  smooth();
  callTwitter();
  
  cp5 = new ControlP5(this);
  
  cp5.setColorForeground(0xffaa0000);
  cp5.setColorBackground(0xff660000);
  //controlP5.setFont(font);
  cp5.setColorActive(0xffff0000);

  // create a new button with name 'buttonA'
  cp5.addButton("facebook")
     .setValue(0)
     .setPosition(50,550)
     .setSize(100,19)
     ;
  
  // and add another 2 buttons
  cp5.addButton("amazon")
     .setValue(100)
     .setPosition(50,570)
     .setSize(100,19)
     ;
     
  cp5.addButton("apple")
     .setPosition(50,590)
     .setSize(100,19)
     .setValue(0)
     ;
  
  cp5.addButton("netflix")
     .setPosition(50,610)
     .setSize(100,19)
     .setValue(0)
     ;

  cp5.addButton("google")
     .setPosition(50,630)
     .setSize(100,19)
     .setValue(0)
     ;
  
//  cp5.addTextfield("textValue")
//     .setPosition(50,650)
//     .setSize(100,19)
////   .setFont(createFont("arial",12))
//     .setFocus(true)
//     .setColor(color(255))
//     //setColorActive(int) 
//     //setColorBackground(int) 
//     //setColorCaptionLabel(int) 
//     //setColorForeground(int) 
//     //setColorLabel(int) 
//     //setColorValue(int) 
//     //setColorValueLabel(int) 
//     .setAutoClear(false)
//     ;
     
//  cp5.addBang("clear")
//     .setPosition(160,650)
//     .setSize(40,19)
//     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
//     ;    
     
//  textFont(font);
}

void callTwitter() {
  // Make the Configuration Builder object to authenticate with Twitter
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("UQuhEpQesWYPS0qOXvfUxYR1X");
  cb.setOAuthConsumerSecret("NQGzCaCOSAWsWzwu2y5PdgBi5Pjb0vhm6xdWadJP6QPA86eLKy");
  cb.setOAuthAccessToken("20475832-vIXds5SamzWqDsPFacIw7wLqF36RGkeCqiWYm1xbd");
  cb.setOAuthAccessTokenSecret("aBJjR9LFbNgxjKja2C0OpJjifaqW5uWk4nxU3gpZ7Y8LA");

  // Make the Twitter object and prepare the query
  Twitter twitter = new TwitterFactory(cb.build()).getInstance();
  Query query = new Query("(tech OR technology) (ethics OR moral) filter:verified -filter:retweets -filter:quote -filter:replies lang:en");
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
  
  // For each Tweet in the ArrayList, plot a point by Date and Retweet Count
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
    pointSizes[i] = 15 + (fc * .15);
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

//void controlEvent(ControlEvent theEvent) {
//   if(theEvent.getController().getName()=="facebook") {
//   callTwitter();
//// colors[0] = colors[0] + color(40,40,0);
//// if(colors[0]>255) colors[0] = color(40,40,0); 
//}
//}

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

//public void controlEvent(ControlEvent theEvent) {
//  if(theEvent.isAssignableFrom(Textfield.class)) {
//    println("controlEvent: accessing a string from controller '"
//            +theEvent.getName()+"': "
//            +theEvent.getStringValue()
//            );
//  }
//}

//public void clear() {
//  cp5.get(Textfield.class,"textValue").clear();
//}

//public void input(String theText) {
//  // automatically receives results from controller input
//  println("a textfield event for controller 'input' : "+theText);
//}
