
import SimpleOpenNI.*;
SimpleOpenNI  context ;

import ddf.minim.*;

PImage backgroundImage ;
PImage backgroundImage2 ;
AudioPlayer player;
Minim minim;

void setup()
{
  context = new SimpleOpenNI(this);
  //context.enableRGB();
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
 
  
  size(context.depthWidth(), context.depthHeight());//640 480
  backgroundImage =loadImage("ville.jpg");
  backgroundImage2 = loadImage("las_vegas.jpg");
  
  minim = new Minim(this);
  player = minim.loadFile("mario.mp3");
}

float x=360;
float y=-1;

float x2=360;
float y2=-1;
boolean rand_color = false;

boolean background_choice = false;

boolean music_on=false;

void background_change(float rect_x,float rect_y, float hand_x, float hand_y){
  
  if(hand_x>rect_x && hand_y<rect_y && background_choice==false){
  background_choice=true;
  }
  
}
  

void draw()
{
  // update the cam
  context.update();
  // draw  depthImageMap
  image(context.depthImage(),0,0);
  
  if(background_choice==false){
  background(backgroundImage);
  }
  else{
  background(backgroundImage2);
  }
  if(music_on==true){
    player.play();
  }
  if(music_on==false){
    player.pause();
  }
  
  fill(0,0,255);
  rect(0, 0, 50, 50);
  
  fill(150,170,0);
  rect(590,0,50,50);
  
  fill(255,0,0);
  rect(590,290,50,50);
  
  fill(55,20,100);
  rect(0,290,50,50);
  
  if(context.isTrackingSkeleton(1))
    drawSkeleton(1);
}



float[] changement_angle(float skel_y1, float skel_y2, float x1 , float x2, float y1, float y2){
  
  float x = 0;
  float y = 0;
  float[] tab= new float[2];
  
  if(skel_y1<skel_y2){//si le neck plus bas que l'avant bras ce calcul sinon l'autre
      x=x1;
      y=y1;
  }
  if(skel_y1>skel_y2){
    x=x2;
    y=y2;
  }
  tab[0]=x;
  tab[1]=y;
  return tab;
}

PVector creation_de_vecteur(float xa, float ya, float xb, float yb){
   
   float vx = xb - xa;
   float vy = yb - ya;
   PVector vecteur = new PVector(vx,vy);
   return vecteur;
  
}



void draw_rect(float translate_x, float translate_y, float decalage_en_x, float angle, int couleurR, int couleurG , int couleurB){
  
  pushMatrix();
  fill(couleurR,couleurG,couleurB);
  translate(translate_x + decalage_en_x,translate_y);//+40 pour ca ce mette bien sur l'epaule
  rotate(angle);
  rect(0, 0, 100, 20);
  
  popMatrix();
  
}

void draw_rect_torso(float translate_x, float translate_y,int couleurR, int couleurG , int couleurB){
  if(rand_color==false){
  pushMatrix();
  fill(couleurR,couleurG,couleurB);
  translate(translate_x + 50,translate_y - 30);//+40 pour ca ce mette bien sur l'epaule
  rect(0, 0, 100, 150);
  popMatrix();
  }
  if(rand_color==true){
  pushMatrix();
  fill(random(0,255),random(0,255),random(0,255));
  translate(translate_x + 50,translate_y - 30);//+40 pour ca ce mette bien sur l'epaule
  rect(0, 0, 100, 150);
  popMatrix();
  }
  
}

void music(float rect_x,float rect_y, float hand_x, float hand_y){
  
  if(hand_x>rect_x && hand_y>rect_y && hand_y<rect_y+50 && music_on==false){
    music_on=true;
  }
}

void kill_music(float rect_x,float rect_y, float hand_x, float hand_y){
  
  if(hand_x<rect_x+50 && hand_y>rect_y && hand_y<rect_y+50 && music_on==true){
    music_on=false;
  }
}

void touch_rect(float rect_x,float rect_y, float hand_x, float hand_y){
  
  if(hand_x<rect_x && hand_y<rect_y && rand_color==false){
    rand_color=true;
  }
  
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  
  
  PVector defaut =creation_de_vecteur(0,640,480,640);
  
  //mon code
  PVector tete = new PVector();
  PVector tete2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,tete);
  context.convertRealWorldToProjective(tete,tete2);
  float tete_x = (((context.depthWidth() - tete2.x)-600)*-1);
  float tete_y = tete2.y;
  
  fill(0,0,255);
  ellipse(tete_x+30, tete_y-10, 100, 100);
  
  /*
  fill(255,255,255);
  ellipse(tete_x+20,tete_y-10,15,15);//yeux blanc
  
  fill(0,0,0);
  ellipse(tete_x+20,tete_y-10,5,5);//noir dedans
  
  
  fill(0,0,0);
  ellipse(tete_x+50,tete_y-10,5,5);
  
  fill(255,255,255);
  ellipse(tete_x+50,tete_y-10,15,15);
  
  */
  
  PVector shoulder_R = new PVector();
  PVector shoulder_R2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,shoulder_R);
  context.convertRealWorldToProjective(shoulder_R,shoulder_R2);
  float shoulder_R_x = (((context.depthWidth() - shoulder_R2.x)-600)*-1);
  float shoulder_R_y= shoulder_R2.y;
  
  PVector shoulder_L = new PVector();
  PVector shoulder_L2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,shoulder_L);
  context.convertRealWorldToProjective(shoulder_L,shoulder_L2);
  float shoulder_L_x = (((context.depthWidth() - shoulder_L2.x)-600)*-1);
  float shoulder_L_y= shoulder_L2.y;
  
  PVector avant_bras_droit = new PVector();
  PVector avant_bras_droit2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,avant_bras_droit);
  context.convertRealWorldToProjective(avant_bras_droit,avant_bras_droit2);
  float avant_bras_droit_x = (((context.depthWidth() - avant_bras_droit2.x)-600)*-1);
  float avant_bras_droit_y = avant_bras_droit2.y;
  
  PVector avant_bras_gauche = new PVector();
  PVector avant_bras_gauche2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,avant_bras_gauche);
  context.convertRealWorldToProjective(avant_bras_gauche,avant_bras_gauche2);
  float avant_bras_gauche_x = (((context.depthWidth() - avant_bras_gauche2.x)-600)*-1);
  float avant_bras_gauche_y = avant_bras_gauche2.y;
  
  
  PVector neck = new PVector();
  PVector neck2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,neck);
  context.convertRealWorldToProjective(neck,neck2);
  float neck_x = (((context.depthWidth() - neck2.x)-600)*-1);
  float neck_y = neck2.y;
  
  PVector bras_R = new PVector();
  PVector bras_R2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,bras_R);
  context.convertRealWorldToProjective(bras_R,bras_R2);
  float bras_R_x = (((context.depthWidth() - bras_R2.x)-600)*-1);
  float bras_R_y = bras_R2.y;
  
  PVector bras_L = new PVector();
  PVector bras_L2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,bras_L);
  context.convertRealWorldToProjective(bras_L,bras_L2);
  float bras_L_x = (((context.depthWidth() - bras_L2.x)-600)*-1);
  float bras_L_y = bras_L2.y;
  
  PVector HIP_L = new PVector();
  PVector HIP_L2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,HIP_L);
  context.convertRealWorldToProjective(HIP_L,HIP_L2);
  float HIP_L_x = (((context.depthWidth() - HIP_L2.x)-600)*-1);
  float HIP_L_y = HIP_L2.y;
  
  PVector HIP_R = new PVector();
  PVector HIP_R2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,HIP_R);
  context.convertRealWorldToProjective(HIP_R,HIP_R2);
  float HIP_R_x = (((context.depthWidth() - HIP_R2.x)-600)*-1);
  float HIP_R_y = HIP_R2.y;
  
  PVector KNEE_L = new PVector();
  PVector KNEE_L2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_KNEE,KNEE_L);
  context.convertRealWorldToProjective(KNEE_L,KNEE_L2);
  float KNEE_L_x = (((context.depthWidth() - KNEE_L2.x)-600)*-1);
  float KNEE_L_y = KNEE_L2.y;
  
  
  PVector KNEE_R = new PVector();
  PVector KNEE_R2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_KNEE,KNEE_R);
  context.convertRealWorldToProjective(KNEE_R,KNEE_R2);
  float KNEE_R_x = (((context.depthWidth() - KNEE_R2.x)-600)*-1);
  float KNEE_R_y = KNEE_R2.y;
  
  PVector FOOT_R = new PVector();
  PVector FOOT_R2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_FOOT,FOOT_R);
  context.convertRealWorldToProjective(FOOT_R,FOOT_R2);
  float FOOT_R_x = (((context.depthWidth() - FOOT_R2.x)-600)*-1);
  float FOOT_R_y = FOOT_R2.y;
  
  PVector FOOT_L = new PVector();
  PVector FOOT_L2 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_FOOT,FOOT_L);
  context.convertRealWorldToProjective(FOOT_L,FOOT_L2);
  float FOOT_L_x = (((context.depthWidth() - FOOT_L2.x)-600)*-1);
  float FOOT_L_y = FOOT_R2.y;
  
  
  //Creation des vecteurs entre les differents points
  
  PVector vecteur_neck_shoulderL = creation_de_vecteur(neck_x,neck_y,shoulder_L_x,shoulder_L_y);
  
  PVector vecteur_neck_shoulderR = creation_de_vecteur(neck_x,neck_y,shoulder_R_x,shoulder_R_y);
  
  PVector vecteur_avant_bras_R = creation_de_vecteur(shoulder_R_x,shoulder_R_y,avant_bras_droit_x,avant_bras_droit_y);
  
  PVector vecteur_avant_bras_L = creation_de_vecteur(shoulder_L_x,shoulder_L_y,avant_bras_gauche_x,avant_bras_gauche_y);
  
  PVector vecteur_bras_R = creation_de_vecteur(avant_bras_droit_x,avant_bras_droit_y,bras_R_x,bras_R_y);
  
  PVector vecteur_bras_L = creation_de_vecteur(avant_bras_gauche_x,avant_bras_gauche_y,bras_L_x,bras_L_y);
  
  PVector vecteur_hip_R_to_L = creation_de_vecteur(HIP_R_x,HIP_R_y,HIP_L_x,HIP_L_y);// vecteur du bas du ventre
  
  PVector vecteur_hip_to_knee_L = creation_de_vecteur(HIP_L_x,HIP_L_y,KNEE_L_x,KNEE_L_y);
  
  PVector vecteur_hip_L_to_R = creation_de_vecteur(HIP_L_x,HIP_L_y,HIP_R_x,HIP_R_y);// vecteur du bas du ventre
  
  PVector vecteur_hip_to_knee_R = creation_de_vecteur(HIP_R_x,HIP_R_y,KNEE_R_x,KNEE_R_y);
  
  PVector vecteur_knee_to_foot_R = creation_de_vecteur(KNEE_R_x,KNEE_R_y,FOOT_R_x,FOOT_R_y);
  
  PVector vecteur_knee_to_foot_L = creation_de_vecteur(KNEE_L_x,KNEE_L_y,FOOT_L_x,FOOT_L_y);
  
  
  //ICI les Angles
  
  float angle_knee_to_foot_L = PVector.angleBetween(vecteur_hip_to_knee_L, vecteur_knee_to_foot_L);
  float ft2 = (int) degrees(angle_knee_to_foot_L);
  float angle_8;
  
  float angle_knee_to_foot_R = PVector.angleBetween(vecteur_hip_to_knee_R, vecteur_knee_to_foot_R);
  float ft = (int) degrees(angle_knee_to_foot_R);
  float angle_7;
  
  float angle_hip_to_knee_R = PVector.angleBetween(vecteur_hip_L_to_R, vecteur_hip_to_knee_R);
  float kn2 = (int) degrees(angle_hip_to_knee_R);
  float angle_6;
  
  float angle_hip_to_knee_L = PVector.angleBetween(vecteur_hip_R_to_L, vecteur_hip_to_knee_L);
  float kn = (int) degrees(angle_hip_to_knee_L);
  float angle_5;
  
  float angle_avant_bras_L_bras = PVector.angleBetween(vecteur_bras_L, vecteur_neck_shoulderL);
  float ag2 = (int) degrees(angle_avant_bras_L_bras);
  float angle_4;
  
  float angle_neck_avant_bras_L = PVector.angleBetween(vecteur_neck_shoulderL, vecteur_avant_bras_L);
  int ag = (int) degrees(angle_neck_avant_bras_L);
  float angle_3;
  
   // angle neck_shoulderR -> avant_bras_R
  float angle_neck_avant_bras_R = PVector.angleBetween(vecteur_neck_shoulderR, vecteur_avant_bras_R);
  int ad = (int) degrees(angle_neck_avant_bras_R);
  float angle_1;
  
  //angle bras_R -> neck_shoulderR
  float angle_avant_bras_R_bras = PVector.angleBetween(vecteur_bras_R, defaut);
  float ad2 = (int) degrees(angle_avant_bras_R_bras);
  //println("ad2 "+ad2);
  float angle_2;
  
  
  float[] tab= new float[2];// va recuperer les nouveau x et y de la fonction changement_angle()
  
  angle_8 = (radians((-1*(ft2/2)+90)));//-270 c'est pas mal
  
  draw_rect(KNEE_L_x, KNEE_L_y, 50, angle_8, 0,0, 255);
  
  
  angle_7 = (radians((ft/2)-270));//-270 c'est pas mal
  
  draw_rect(KNEE_R_x, KNEE_R_y, 50, angle_7, 0,0, 255);
  
  angle_6 = (radians(1*kn2));
  
  draw_rect(HIP_R_x, HIP_R_y, 50, angle_6,  248,5 , 5);
  
  
  angle_5 = (radians(-1*kn+180));
  
  draw_rect(HIP_L_x, HIP_L_y, 50, angle_5, 248,5 , 5);
  
  
  tab=changement_angle(avant_bras_gauche_y,bras_L_y,180,180,-1,1);
  
  angle_4 = (radians(tab[1]*ag2+tab[0]));
  
  draw_rect(avant_bras_gauche_x-10, avant_bras_gauche_y, 50, angle_4, 55, 208 , 63);
  
  
  tab=changement_angle(neck2.y,avant_bras_gauche_y,180,180,-1,1);
  
  angle_3 = (radians((tab[1])*(ag+tab[0])));//-1* +180 pour le bas et 1* +180 pour le haut
  
  draw_rect(shoulder_L_x, shoulder_L_y, 50, angle_3,  251,168 , 13);
  
  tab=changement_angle(avant_bras_droit_y,bras_R_y,0,360,1,-1);
  
  angle_2 = (radians(tab[1]*ad2));
  
  draw_rect(avant_bras_droit_x-10, avant_bras_droit_y, 50, angle_2, 55, 208 , 63);
  
  
  tab=changement_angle(neck2.y,avant_bras_droit_y,0,360,1,-1);

  angle_1 = (radians((tab[1])*(ad-tab[0])));//a le degres et r le radian, tab[0] c'est x et tab[1] c'est y
 
  draw_rect(shoulder_R_x,shoulder_R_y, 50, angle_1, 251, 168, 13);

  //les carrés en haut avec les changements qu'ils opperent
  
  touch_rect(50 ,50, bras_L_x, bras_L_y);
  touch_rect(50 ,50, bras_R_x, bras_R_y);
  
  
  background_change(590-40,50, bras_L_x, bras_L_y);
  background_change(590-40,50, bras_R_x, bras_R_y);
  
  music(590-40,290,bras_L_x, bras_L_y);
  music(590-40,290,bras_R_x, bras_R_y);
  
  kill_music(0,290,bras_L_x, bras_L_y);
  kill_music(0,290,bras_R_x, bras_R_y);
  
  //draw le carré du torse
  draw_rect_torso(shoulder_L_x+10,shoulder_L_y+10, 55, 208 , 63);
  
  //draw les mains
  fill(255,0,0);
  ellipse(bras_L_x+35,bras_L_y,50,50);
  
  fill(255,0,0);
  ellipse(bras_R_x+35,bras_R_y,50,50);
  
  //code skeleton
  /*PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  //println("SimpleOpenNI.SKEL_HEAD"+SimpleOpenNI.SKEL_HEAD);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  */
}


// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{     
  println("onNewUser - userId: " + userId);
  if(context.isTrackingSkeleton(1))
    return;

 println(" start pose detection");
  
  context.startPoseDetection("Psi",userId);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");
  
  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose,int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}
