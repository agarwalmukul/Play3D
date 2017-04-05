import controlP5.*;

import de.voidplus.leapmotion.*;
import damkjer.ocd.*;
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

LeapMotion leap;

//3D sketching variables
PVector firstP= new PVector(0,0,0);
PVector secondP= new PVector(0,0,0);
ArrayList <PVector> points = new ArrayList <PVector> ();
ArrayList <PVector> planeDrawingPoints = new ArrayList <PVector> ();
float snapValue = 150.0;

//General Variables
PVector cursorPosn= new PVector(0,0,0);
PVector tempCursorPosn = new PVector(0,0,0);//these coordinates are given to start at the origin
float cursorScalingFactor = 1.5f;

//finger variables
PVector indexPosn= new PVector(0,0,0);
PVector pindexPosn;
//PVector indexVel= new PVector(0,0,0);
PVector middlePosn= new PVector(0,0,0);
PVector thumbPosn= new PVector(0,0,0);

//Camera variables
float cameraIndexMiddleDist = 200.0f;
float cameraIndexThumbDist = 200.0f;
float panScalingFactor = -4.0f;
float tumbleScalingFactor = -0.8f;
float zoomScalingFactor = 1.0f;
float zAxisScalingFactor = -5.0f; //negative becuase we want to flip the axis

String  mode = "simple";
damkjer.ocd.Camera camera1;
PVector cameraUp;
PVector cameraForward;
PVector cameraRight;


boolean cursorFreeze = false;

int count=0;

//extrusion variables
Tube tube;
Bezier2D bn;
P_Bezier3D bez;
BezShape bezierShape;
BezTube btube;
Extrusion extrude;

// Array to simplify the selection of the 
Shape3D[] shapes; 
Shape3D temporaryShape;
Shape3D uninstantiated;
ArrayList <Shape3D> shapeArray = new ArrayList <Shape3D> ();
ArrayList <PVector> shapeWorldPosition = new ArrayList <PVector> ();

Path path;
Contour contour;
ContourScale conScale;

int shapeNo = 2;

String footer = "Press any key for next shape";
int footerX;

float angleX, angleY, angleZ;

String shapetag = "tube";
boolean shapeComplete = false;
ArrayList <PVector> tempExtrusionVectorArray = new ArrayList <PVector> ();

PVector orientExtrude;
boolean extrudeSketchComplete = false;




void setup() {
  size(1220, 700, OPENGL);
  background(255);
  textFont(createFont("dialog", 32));
  
  camera1 = new damkjer.ocd.Camera(this, 140, 120, 790, // eyeX, eyeY, eyeZ
            940, 620, 90, // centerX, centerY, centerZ
             0.0, 1.0, 0.0); //up direction vector

  fill(0,102);
  stroke(255);
  leap = new LeapMotion(this);
}

void draw() {
  int fps = leap.getFrameRate();
  background(255);
  
  // ======lines for xyz axes======
    strokeWeight(2);
    //x axis
    stroke(255,0,0);
    line(940, 620, 90, 140, 620, 90);
    //y axis
    stroke(0,255,0);
    line(940, 620, 90, 940, 120, 90);
    //z axis
    stroke(0,0,255);
    line(940, 620, 90, 940, 620, 790);
    
    fill(153);
    stroke(153);
    //rect(-11620,9000,11620,-9000);
    //rotateZ(PI);
    translate(11620,630,-9000);
    rotateX(PI/2);
    //rect(-22620,18000,11620,-9000);
    rect(-23000,-5000, 22000,40000);
    
    rotateX(-PI/2);
    translate(-11620,-630,9000);
    //rotateZ(-PI);
    fill(0,102);
    
    strokeWeight(0.1);
    stroke(50,50,50);
    for(int i=-11620; i<11620; i+=100){
       line(i,620,-9000, i, 620, 9000);
    }
    for(int i=-11620; i<11620; i+=100){
       line(-9000,620,i, 9000, 620, i);
    }
    pushMatrix();
    strokeWeight(1);
    stroke(0,0,0);
    translate(940, 620, 90);
    box(20);
    translate(-940, -620, -90);
    popMatrix();

  // ========= HANDS =========
  for (Hand hand : leap.getHands ()) {
    // ----- BASICS -----

    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    boolean hand_is_left     = hand.isLeft();
    boolean hand_is_right    = hand.isRight();
    float   hand_grab        = hand.getGrabStrength();
    float   hand_pinch       = hand.getPinchStrength();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();


    // ----- SPECIFIC FINGER -----

    Finger  finger_thumb     = hand.getThumb();
    // or                      hand.getFinger("thumb");
    // or                      hand.getFinger(0);

    Finger  finger_index     = hand.getIndexFinger();
    // or                      hand.getFinger("index");
    // or                      hand.getFinger(1);

    Finger  finger_middle    = hand.getMiddleFinger();
    // or                      hand.getFinger("middle");
    // or                      hand.getFinger(2);

    Finger  finger_ring      = hand.getRingFinger();
    // or                      hand.getFinger("ring");
    // or                      hand.getFinger(3);

    Finger  finger_pink      = hand.getPinkyFinger();
    // or                      hand.getFinger("pinky");
    // or                      hand.getFinger(4);        



    // ========= ARM =========

    if (hand.hasArm()) {
      Arm     arm               = hand.getArm();
      float   arm_width         = arm.getWidth();
      PVector arm_wrist_pos     = arm.getWristPosition();
      PVector arm_elbow_pos     = arm.getElbowPosition();
    }


    // ========= FINGERS =========

    for (Finger finger : hand.getFingers()) {
      // Alternatives:
      // hand.getOutstrechtedFingers();
      // hand.getOutstrechtedFingersByAngle();

      // ----- BASICS -----

      int     finger_id         = finger.getId();
      PVector finger_position   = finger.getPosition();
      PVector finger_stabilized = finger.getStabilizedPosition();
      PVector finger_velocity   = finger.getVelocity();
      PVector finger_direction  = finger.getDirection();
      float   finger_time       = finger.getTimeVisible();


      // ----- SPECIFIC FINGER -----
      float fingerScale = 3.0f;
      switch(finger.getType()) {
      case 0:
        // System.out.println("thumb");
        thumbPosn = finger_position;
        thumbPosn.mult(fingerScale);
        break;
      case 1:
        // System.out.println("index");
        indexPosn = finger_position;
        indexPosn.mult(fingerScale);
        //indexVel = PVector.mult(finger_velocity,0.01);
        break;
      case 2:
        // System.out.println("middle");
        middlePosn = finger_position;
        middlePosn.mult(fingerScale);
        break;
      case 3:
        // System.out.println("ring");
        break;
      case 4:
        // System.out.println("pinky");
        break;
      }


      // ----- SPECIFIC BONE -----

      Bone    bone_distal       = finger.getDistalBone();
      // or                       finger.get("distal");
      // or                       finger.getBone(0);

      Bone    bone_intermediate = finger.getIntermediateBone();
      // or                       finger.get("intermediate");
      // or                       finger.getBone(1);

      Bone    bone_proximal     = finger.getProximalBone();
      // or                       finger.get("proximal");
      // or                       finger.getBone(2);

      Bone    bone_metacarpal   = finger.getMetacarpalBone();
      // or                       finger.get("metacarpal");
      // or                       finger.getBone(3);


      // ----- DRAWING -----
      
      // finger_index.draw(); // = drawLines()+drawJoints()
      // finger.drawLines();
      // finger.drawJoints();


      // ----- TOUCH EMULATION -----

      int     touch_zone        = finger.getTouchZone();
      float   touch_distance    = finger.getTouchDistance();

      switch(touch_zone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#"+finger_id+"): "+touch_distance);
        break;
      case 1: // Touching
        // println("Touching (#"+finger_id+")");
        break;
      }
    }


    // ========= TOOLS =========

    for (Tool tool : hand.getTools ()) {


      // ----- BASICS -----

      int     tool_id           = tool.getId();
      PVector tool_position     = tool.getPosition();
      PVector tool_stabilized   = tool.getStabilizedPosition();
      PVector tool_velocity     = tool.getVelocity();
      PVector tool_direction    = tool.getDirection();
      float   tool_time         = tool.getTimeVisible();


      // ----- DRAWING -----

      // tool.draw();


      // ----- TOUCH EMULATION -----

      int     touch_zone        = tool.getTouchZone();
      float   touch_distance    = tool.getTouchDistance();

      switch(touch_zone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#"+tool_id+"): "+touch_distance);
        break;
      case 1: // Touching
        // println("Touching (#"+tool_id+")");
        break;
      }
    }
  }

  // ========= DEVICES =========
  for (Device device : leap.getDevices ()) {
    float device_horizontal_view_angle = device.getHorizontalViewAngle();
    float device_verical_view_angle = device.getVerticalViewAngle();
    float device_range = device.getRange();
  }

  // ========Camera movements and calculating cursor position=========
  {   
    // camera(mouseX, mouseY, 320.0, // eyeX, eyeY, eyeZ
    //         500.0, 350.0, 60.0, // centerX, centerY, centerZ
    //         0.0, 1.0, 0.0); // upX, upY, upZ

    lights();
    camera1.feed();
    if (mousePressed == true && mouseButton == RIGHT) {
      if(indexPosn.dist(middlePosn) < cameraIndexMiddleDist) {
        camera1.truck(panScalingFactor*(indexPosn.x - pindexPosn.x));
        camera1.boom(panScalingFactor*(indexPosn.y - pindexPosn.y));
        camera1.zoom(zoomScalingFactor*radians(indexPosn.z - pindexPosn.z));
      }
      else {
        camera1.tumble(radians(tumbleScalingFactor*(indexPosn.x - pindexPosn.x)), radians(tumbleScalingFactor*(indexPosn.y - pindexPosn.y)));
        //popMatrix();
        //pushMatrix();
        //text("word", 10, 30);
        //popMatrix();
        
      }
    }
    else {
      //==========Calculating 3D cursor position================
      if (pindexPosn == null){
        tempCursorPosn = new PVector(-1940, -1600, 1290);
        tempCursorPosn = PVector.sub(tempCursorPosn, new PVector(-1454,-299,4703));
        //tempCursorPosn = new PVector(940, 620, 90);
        System.out.println("first");
      }
      else {
        PVector difference = PVector.mult(PVector.sub(indexPosn,pindexPosn),cursorScalingFactor);
        difference.z = difference.z*zAxisScalingFactor;
        
        //checks if index and thumb are close together to freeze the 3D pointer
        if(indexPosn.dist(thumbPosn) < cameraIndexThumbDist) {
          //tempCursorPosn = PVector.sub(tempCursorPosn,difference);
          cursorFreeze = true;
        }
        else {
          cursorFreeze = false;
          PVector origin = new PVector(940, 620, 90);
          
          cameraUp = new PVector(camera1.up()[0],camera1.up()[1],camera1.up()[2]);
          cameraUp = PVector.div(cameraUp, cameraUp.mag());
          //float[] cameraForwardFloat = camera1.target()[0] - camera1.position()[0];
          cameraForward = new PVector(camera1.target()[0] - camera1.position()[0],camera1.target()[1] - camera1.position()[1],camera1.target()[2] - camera1.position()[2]);
          //PVector cameraForward = new PVector(origin.x - camera1.position()[0],origin.y - camera1.position()[1],origin.z - camera1.position()[2]);
          //System.out.println("for" + cameraForward);
          cameraForward = PVector.div(cameraForward, cameraForward.mag());
          //System.out.println("foru" + cameraForward);
          cameraRight = cameraForward.cross(cameraUp);
          tempCursorPosn = PVector.add(tempCursorPosn,PVector.mult(cameraRight,difference.x));
          tempCursorPosn = PVector.add(tempCursorPosn,PVector.mult(cameraUp,difference.y));
          tempCursorPosn = PVector.add(tempCursorPosn,PVector.mult(cameraForward,-1.0f*difference.z));
          //tempCursorPosn = PVector.add(tempCursorPosn, difference);
        
        }
      }
      cursorPosn = tempCursorPosn.get();
    }
  }
  
  stroke(0);
  pushMatrix();
  //=====Drawing 3D edges and snapping points to previous points====
  if(mode == "free run") {
    float snapDist = -1.0;
    int snapIndex = -1;

    //all the points stored in the array to create the 3D sketch
    for (int i = 1; i < points.size(); i++)  {
      PVector p1 = points.get(i-1);
      PVector p2 = points.get(i);
      stroke(0,0,0); // line color : no fill, green stroke
      line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);

      if(snapDist > p1.dist(tempCursorPosn) || snapDist == -1.0)
      {
        snapDist = p1.dist(tempCursorPosn);
        snapIndex = i-1;
      }
    }

    if(snapDist != -1.0 && snapDist < snapValue) {
      cursorPosn = points.get(snapIndex);
    }

    //variable line drawn from the last point
    if (points.size() > 0) {
      firstP = points.get(points.size() - 1);
      line(firstP.x, firstP.y, firstP.z, cursorPosn.x, cursorPosn.y, cursorPosn.z);            
    }
  }

  //Plane drawing mode
  if(mode == "plane drawing") {
    float snapDist = -1.0;
    int snapIndex = -1;

    //all the points stored in the array to create the 3D sketch
    for (int i = 1; i < planeDrawingPoints.size(); i++)  {
      PVector p1 = planeDrawingPoints.get(i-1);
      PVector p2 = planeDrawingPoints.get(i);
      stroke(0,0,0); // line color : no fill, green stroke
      line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
      //the point that has mnimum distance
      if(snapDist > p1.dist(tempCursorPosn) || snapDist == -1.0)
      {
        snapDist = p1.dist(tempCursorPosn);
        snapIndex = i-1;
      }
    }

    if(snapDist != -1.0 && snapDist < snapValue) {
      cursorPosn = planeDrawingPoints.get(snapIndex).get();
      System.out.println(snapDist);
      System.out.println(planeDrawingPoints.get(snapIndex));
    }

    //variable line drawn from the last point
    if (planeDrawingPoints.size() > 0) {

      PVector lastPoint = planeDrawingPoints.get(planeDrawingPoints.size()-1);  
      PVector diff = PVector.sub(lastPoint,tempCursorPosn);
      float diffx = abs(diff.x);
      float diffy = abs(diff.y);
      float diffz = abs(diff.z);
      float minValueNormalVec = min(diffx,diffy,diffz);
      if (diffx == minValueNormalVec ){
        cursorPosn.x = lastPoint.x;
      }
      else if (diffy == minValueNormalVec) {
        cursorPosn.y = lastPoint.y;
      }
      else {
        cursorPosn.z = lastPoint.z;
      }
      line(lastPoint.x, lastPoint.y, lastPoint.z, cursorPosn.x, cursorPosn.y, cursorPosn.z);     
    }
  }


  if (mode == "extrusion")  {  
    // Draw selected shape
    //shapes[0] = (Shape3D)shapeArray[shapeNo];
    shapes = shapeArray.toArray(new Shape3D[shapeArray.size()]);
    for (Shape3D shape : shapes) {
      shape.draw();
    }
    
    if (temporaryShape!= null){
      temporaryShape.draw();
    }

    if ( tempExtrusionVectorArray.size() > 0) {
      if (shapetag == "tube") {
        //constrains on the cursor posn
        PVector a = tempExtrusionVectorArray.get(0);
        PVector c = tempExtrusionVectorArray.get(0);
        float radius;
        PVector orientation;
        tube = new Tube(this, 4, 50);

        if (tempExtrusionVectorArray.size() == 1 ) {
          
          PVector diff = PVector.sub(a,tempCursorPosn);
          
          float camdiffx = abs(cameraForward.x);
          float camdiffy = abs(cameraForward.y);
          float camdiffz = abs(cameraForward.z);
          float maxValueNormalVec = max(camdiffx,camdiffy,camdiffz);
          if (camdiffx == maxValueNormalVec ){
            orientation = new PVector(1,0,0);
            cursorPosn.x = a.x;
          }
          else if (camdiffy == maxValueNormalVec) {
            orientation = new PVector(0,1,0);
            cursorPosn.y = a.y;
          }
          else {
            orientation = new PVector(0,0,1);
            cursorPosn.z = a.z;
          }
          
          radius = cursorPosn.dist(a);
          tube = new Tube(this, 4, 50, orientation, new PVector());
          System.out.println(a+":"+c+":"+radius);
        }

        else if (tempExtrusionVectorArray.size() == 2 ) {    
          orientation = PVector.sub(a,tempExtrusionVectorArray.get(1));        
          cursorPosn = a.get();
          if (orientation.x == 0){
            cursorPosn.x = tempCursorPosn.x;
            orientation = new PVector(1,0,0);
          }
          else if (orientation.y == 0){
            cursorPosn.y = tempCursorPosn.y;
            orientation = new PVector(0,1,0);
          }
          else if (orientation.z == 0){
            cursorPosn.z = tempCursorPosn.z;
            orientation = new PVector(0,0,1);
          }
          radius = a.dist(tempExtrusionVectorArray.get(1));
          c = cursorPosn.get();
          System.out.println(a+":"+c+":"+radius);
        }

        else { 
          c = tempExtrusionVectorArray.get(2);
          radius = a.dist(tempExtrusionVectorArray.get(1));        
          shapeComplete = true;
          System.out.println(a+":"+c+":"+radius);
        }

          tube.setSize(radius, radius, radius, radius);
          tube.setWorldPos(a, c);
          tube.fill(color(180,0,0));
          tube.fill(color(180,0,0),S3D.BOTH_CAP);
          tube.drawMode(S3D.SOLID);
          tube.drawMode(S3D.SOLID, S3D.BOTH_CAP);       
          temporaryShape = tube;
      }
    
      if (shapetag == "extrude") {
        PVector a = tempExtrusionVectorArray.get(0).get();
        PVector diff;
        float snapDist = -1.0;
        int snapIndex = -1;

        //all the points stored in the array to create the 3D sketch
        for (int i = 1; i < tempExtrusionVectorArray.size(); i++)  {
          PVector p1 = tempExtrusionVectorArray.get(i-1);
          PVector p2 = tempExtrusionVectorArray.get(i);
          stroke(0,0,0); // line color : no fill, green stroke
          line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
          //the point that has mnimum distance
          if(snapDist > p1.dist(tempCursorPosn) || snapDist == -1.0)
          {
            snapDist = p1.dist(tempCursorPosn);
            snapIndex = i-1;
          }
        }

        if(snapDist != -1.0 && snapDist < snapValue) {
          cursorPosn = tempExtrusionVectorArray.get(snapIndex).get();
        } 
        boolean condition = false;
        {
          PVector lastPointE = tempExtrusionVectorArray.get(tempExtrusionVectorArray.size()-1).get();
          PVector firstPointE = tempExtrusionVectorArray.get(0).get();
          if (lastPointE.x == firstPointE.x && lastPointE.y == firstPointE.y && lastPointE.z == firstPointE.z) {
            condition = true;
          }          
        }
        if (condition && tempExtrusionVectorArray.size()>2) {
          extrudeSketchComplete = true;
          System.out.println(extrudeSketchComplete); 
          tempExtrusionVectorArray.remove(tempExtrusionVectorArray.size()-1);//remove last element
        }

        if(tempExtrusionVectorArray.size()==1) {
          diff = PVector.sub(tempExtrusionVectorArray.get(0),tempCursorPosn.get());
        }
        else {
          diff = PVector.sub(tempExtrusionVectorArray.get(0),tempExtrusionVectorArray.get(1));
        }
        
        /*
        float diffx = abs(diff.x);
        float diffy = abs(diff.y);
        float diffz = abs(diff.z);
        float minValueNormalVec = min(diffx,diffy,diffz);
        */
        
        float camdiffx = abs(cameraForward.x);
        float camdiffy = abs(cameraForward.y);
        float camdiffz = abs(cameraForward.z);
        float maxValueNormalVec = max(camdiffx,camdiffy,camdiffz);

        if (extrudeSketchComplete == false) {
          PVector lastPoint = tempExtrusionVectorArray.get(tempExtrusionVectorArray.size()-1);       
           if (camdiffx == maxValueNormalVec ){
            orientExtrude = new PVector(1,0,0);
            cursorPosn.x = a.x;
          }
          else if (camdiffy == maxValueNormalVec) {
            orientExtrude = new PVector(0,1,0);
            cursorPosn.y = a.y;
          }
          else {
            orientExtrude = new PVector(0,0,1);
            cursorPosn.z = a.z;
          }
          /*
          if (diffx == minValueNormalVec ){
          orientExtrude = new PVector(1,0,0);
          cursorPosn.x = a.x;
          }
          else if (diffy == minValueNormalVec) {
            orientExtrude = new PVector(0,1,0);
            cursorPosn.y = a.y;
          }
          else {
            orientExtrude = new PVector(0,0,1);
            cursorPosn.z = a.z;
          }
          */
          line(lastPoint.x, lastPoint.y, lastPoint.z, cursorPosn.x, cursorPosn.y, cursorPosn.z);
        }
        else {          
          //path needs to be corrected
          PVector centroid = new PVector(0, 0, 0);
          
          for (PVector n : tempExtrusionVectorArray){
            centroid= PVector.add(n,centroid.get());
          }
          centroid = PVector.div(centroid.get(),tempExtrusionVectorArray.size());
          PVector normalVector = PVector.mult(orientExtrude.get(),10+PVector.dot(PVector.sub(cursorPosn.get(),centroid.get()),orientExtrude.get()));
          cursorPosn = PVector.add(normalVector.get(),centroid.get());
          path = new P_LinearPath(centroid.get(), cursorPosn.get());
          translate(centroid.x,centroid.y,centroid.z);
          sphere(50);
          //translate(-centroid.x,-centroid.y,-centroid.z);
          //translate(centroid.x,centroid.y,centroid.z);
          PVector[] er; 
          er = tempExtrusionVectorArray.toArray(new PVector[tempExtrusionVectorArray.size()]);
          //er = modify(er);
          contour = new Building(er);
          conScale = new CS_ConstantScale();
          extrude = new Extrusion(this, path, 1, contour, conScale);
          extrude.drawMode(S3D.SOLID );
          extrude.drawMode(S3D.SOLID, S3D.BOTH_CAP);
          extrude.fill(color(180,0,0));
          extrude.fill(color(180,0,0),S3D.BOTH_CAP);
          temporaryShape = extrude;
        }
      }
    }

    if (shapeComplete == true) {
      shapeArray.add(temporaryShape);
      shapeWorldPosition.add(tempExtrusionVectorArray.get(0));
      shapeComplete = false;
      temporaryShape = uninstantiated;
      tempExtrusionVectorArray = new ArrayList<PVector>();
    }
  }

  //========Draw the cursor===========
    pushMatrix();
    noFill();
    translate(cursorPosn.x, cursorPosn.y,cursorPosn.z);
    if(cursorFreeze){
      sphere(20);
    }
    else {
      sphere(10);
    }    
    translate(-cursorPosn.x, -cursorPosn.y,-cursorPosn.z);
    popMatrix();
 
    pindexPosn = indexPosn;
    
    
    //hint(DISABLE_DEPTH_TEST);
    //hint(ENABLE_DEPTH_TEST);
    popMatrix();
    
}

// ========= CALLBACKS =========

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}


void mouseClicked() {
  if(mouseButton == LEFT && mode == "free run") {
    fill(0,102);
    stroke(255);
    points.add(cursorPosn);
  }

  if(mouseButton == LEFT && mode == "plane drawing") {
    fill(0,102);
    stroke(255);
    planeDrawingPoints.add(cursorPosn);
    System.out.println(cursorPosn);
  }

  if(mouseButton == LEFT && mode == "extrusion"){
    tempExtrusionVectorArray.add(cursorPosn);
    System.out.println(mode + ":" + cursorPosn);
    System.out.println(tempExtrusionVectorArray.get(tempExtrusionVectorArray.size()-1) +":"+ tempExtrusionVectorArray.get(0) + ":" + tempExtrusionVectorArray.size());
    if (shapetag == "extrude" && extrudeSketchComplete) {
      extrudeSketchComplete = false;
      shapeComplete = true;
    }
  }
}

void keyPressed() {
 switch (key) {
    case 'a':
      mode = "plane drawing";
      break;
    case 's':
      mode = "extrusion";
      break;
    case 'd':
      mode = "free run";
      break;
    case 'f':
      mode = "general";
      break;
 }

 if (mode == "extrusion")  {
    switch (key){
      case '1':
        shapetag = "revolve";
        break;
      case '2':
        shapetag = "tube";
        break;
      case '3':
        shapetag = "bezTube";
        break;
      case '4':
        shapetag = "extrude";
        break;
    }
  System.out.println(shapetag);
  }
 System.out.println(mode);
}


public class Building extends Contour {
  public Building(PVector[] c) {    
    this.contour = c;
  }
}

PVector[] modify(PVector[] c){
  ArrayList <PVector> points = new ArrayList <PVector> ();
  PVector origin = new PVector(940, 620, 90);
  if(orientExtrude.y == 1){
    for ( PVector e : c){
      e= PVector.sub(e,origin); 
      points.add(new PVector(e.x,e.z));
    }
  }
  else if(orientExtrude.x == 1){
    for ( PVector e : c){
      e= PVector.sub(e,origin);
      points.add(new PVector(e.z,e.y));
    }
  }
  else {
    for ( PVector e : c){
      e= PVector.sub(e,origin);
      points.add(new PVector(e.x,e.y));
    }
  }
 PVector[] result = points.toArray(new PVector[points.size()]);
 return result;
}

