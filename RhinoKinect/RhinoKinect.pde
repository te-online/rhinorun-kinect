import SimpleOpenNI.*;
SimpleOpenNI context; 

import processing.net.*; 

boolean userInFront = false;
boolean userChanged = false;
float userChangedBy = millis();
float tolerance = 5000;

void setup(){
  size(640, 480, P3D);
  frameRate(30);
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false) {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // disable mirror
  context.setMirror(true);
  
  // enable depthMap generation 
  context.enableDepth();
  
  // enable skeleton generation for all joints
  context.enableUser();
}

void draw() {
  context.update();
  
  int[] userlist = context.getUsers();
  
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
    String target = "http://127.0.0.1:1577/controller?kinect="+str(userInFront);
    String[] lines = loadStrings(target);
    println("SENT to target: "+target);
    userChanged = false; 
  }
}


// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  //println("onNewUser - userId: " + userId);
  //println("\tstart tracking skeleton");
  
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  //println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

