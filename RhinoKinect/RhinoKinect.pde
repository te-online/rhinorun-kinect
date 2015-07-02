import SimpleOpenNI.*;
SimpleOpenNI context; 

import processing.net.*; 

int[] userlist;

Client webClient;

boolean userInFront = false;
boolean userChanged = false;
float userChangedBy = millis();
float tolerance = 5000;

void setup(){
  size(640, 480, P3D);
  frameRate(30);
  
  webClient = new Client(this, "127.0.0.1/controller?kinect="+str(userInFront), 1577);
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false) {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // enable depthMap generation 
  context.enableDepth();
  
  // enable skeleton generation for all joints
  context.enableUser();
}

void draw() {
  if(userlist.length > 0) {
    if(!userInFront) {
      if(millis() - userChangedBy > tolerance) {
        userInFront = true;
        userChanged = true;
        userChangedBy = millis();
      }
    }
  } else {
    if(userInFront) {
      if(millis() - userChangedBy > tolerance) {
        userInFront = false;
        userChanged = true;
        userChangedBy = millis();
      }
    }
  }
  
  if(userChanged) {
    println("127.0.0.1/controller?kinect="+str(userInFront));
    //webClient = new Client(this, "127.0.0.1/controller?kinect="+str(userInFront), 1577);  // Connect to server on port 80
    userChanged = false; 
  }
}


// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

