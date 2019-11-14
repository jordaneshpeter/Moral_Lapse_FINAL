/*
MORAL LAPSE
Final Project Part 2: Version 1
By Jordan Eshpeter (301403448)
11/10/2019
*/

// Moral Lapse is an interactive data visualization that demonstrates the increasing awareness and effect of ethical issues in the technology 
// industry. Tweets from verified Twitter users are filtered for recency and topical relevance, plotted as points by Retweet Count and Time, and sized
// according to their Favorite Count.

import grafica.*;
import java.util.*;
// import java.text.SimpleDateFormat;
//test
ArrayList<String> points = new ArrayList();

GPlot plot;
// String flags = "" FLAGS
// Array for FANG Facebook [0], Amazon [1]
// Text input to flags variable

void setup() {
  // Set the size of the sketch
  size(1000, 600);
  smooth();

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
    // SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");

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
  };
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
