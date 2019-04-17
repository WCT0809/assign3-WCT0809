PImage bg, cabbage, life, soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5; 
PImage stone1, stone2; 
PImage groundhogDown, groundhogIdle, groundhogLeft, groundhogRight;
PImage startHovered, startNormal, restartHovered, restartNormal, title, gameover;          //all image

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
final int GAME_WIN = 3;                                                                   //all game status
 
int gameState = GAME_START;                                                               //First game status

final int BUTTON_TOP = 360;
final int BUTTON_BOTTOM = 420;
final int BUTTON_LEFT = 248;
final int BUTTON_RIGHT = 392;                                                             //BUTTON status

int sunX;
int sunY;                                                                                 //about sun Location
int soldierX, soldierY, soldierSpeedX;
int soldierLocationX = floor(random(8));
int soldierLocationY = floor(random(1,5));                                                //about soldier Location
boolean soldierCollision=false;                                                           //soldier Collision switch

int cabbageX, cabbageY;
int cabbageLocationX = floor(random(8));
int cabbageLocationY = floor(random(1,5));                                                //about cabbage Location
boolean drawCabbage=true;                                                                 //cabbage Collision switch

int groundhogX, groundhogY;//about groundhog Location
final int groundhog_IDLE = 0;
final int groundhog_LEFT = 1;
final int groundhog_RIGHT = 2;
final int groundhog_DOWN = 3;
int groundhogState = groundhog_IDLE;

int HP=2,nowframeCount;                                                                 //frameCount about groundhog*
boolean upPressed, downPressed, rightPressed, leftPressed, isActive=false;                //about groundhog control

int groundhogYLevel=0;
int soilStartX, soilStartY, soilEndX, soilEndY; 
int [][]soilMatrix=new int[24][8];
int [][]stoneMatrix=new int[24][8];
int soilLowBound;

void setup() {
	size(640, 480, P2D);
  frameRate(60);                                                                          //frameRate*

	// Enter Your Setup Code Here
  bg=loadImage("img/bg.jpg");
  cabbage=loadImage("img/cabbage.png");
  life=loadImage("img/life.png");
  soldier=loadImage("img/soldier.png");

  groundhogDown=loadImage("img/groundhogDown.png");
  groundhogIdle=loadImage("img/groundhogIdle.png");
  groundhogLeft=loadImage("img/groundhogLeft.png");
  groundhogRight=loadImage("img/groundhogRight.png");

  startHovered=loadImage("img/startHovered.png");
  startNormal=loadImage("img/startNormal.png");
  restartHovered=loadImage("img/restartHovered.png");
  restartNormal=loadImage("img/restartNormal.png");  
  title=loadImage("img/title.jpg");
  gameover=loadImage("img/gameover.jpg");

  soldierX=soldierLocationX * 80;
  soldierY=80+soldierLocationY * 80;                                                    //soldier real Location
  soldierSpeedX = 3;                                                                    //soldier move
  cabbageX=cabbageLocationX * 80;                                                       //cabbage real Location
  cabbageY=80+cabbageLocationY * 80;                                                    //cabbage move
  groundhogX = 320;
  groundhogY = 80;                                                                      //groundhog First Location
  sunX = 590;
  sunY= 50;                                                                             //about x,y for sun

  soil0=loadImage("img/soil0.png");
  soil1=loadImage("img/soil1.png");
  soil2=loadImage("img/soil2.png");
  soil3=loadImage("img/soil3.png");
  soil4=loadImage("img/soil4.png");
  soil5=loadImage("img/soil5.png");
  stone1=loadImage("img/stone1.png");
  stone2=loadImage("img/stone2.png");
  //soilMatrix
  for(int i=0; i<24; i++) {
    for (int j=0; j<8; j++) {
      if (i<4) soilMatrix[i][j]=0;
      if(i<8 && i>=4) soilMatrix[i][j]=1;
      if(i<12 && i>=8) soilMatrix[i][j]=2;
      if(i<16 && i>=12) soilMatrix[i][j]=3;  
      if(i<20 && i>=16) soilMatrix[i][j]=4;
      if(i<24 && i>=20) soilMatrix[i][j]=5;
    }
  }
  //stone Matrix 0-7
  for(int i=0; i<8; i++) {
    for (int j=0; j<8; j++) {
      if (i==j) stoneMatrix[i][j]=1;
    }
  }
  //stone Matrix 8-15
  for(int i=8; i<16; i++) {
    for (int j=0; j<8; j++) {
      if (i%4==1 || i%4==2) {
        if (j%4==0 || j%4==3) stoneMatrix[i][j]=1;
      }
      else {
        if (j%4==1 || j%4==2) stoneMatrix[i][j]=1;
      }
    }
  }
  //stone Matrix 16-23
  for(int i=16; i<24; i++) {
    for (int j=0; j<8; j++) {
      if (((i-16)+j)%3==1) stoneMatrix[i][j]=1;
      if (((i-16)+j)%3==2) stoneMatrix[i][j]=2;

    }
  }
  
  //print stoneMatrix
  /*
  for(int i=16; i<24; i++) {
    for (int j=0; j<8; j++) {
      print(stoneMatrix[i][j]);
    }
    println();
  }
  */

}

void draw() {
  clear();
  switch(gameState){
    case GAME_START:
      image(title,0,0,640,480);
      image(startNormal,BUTTON_LEFT,BUTTON_TOP);
      if(mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT  && mouseY > BUTTON_TOP && mouseY < BUTTON_BOTTOM){ 
        image(startHovered,BUTTON_LEFT,BUTTON_TOP);                                                         //BUTTON status
        if(mousePressed) gameState=GAME_RUN;                                                                //BUTTON Click gameState to GAME_RUN
     }
    break;
    case GAME_RUN:
      image(bg,0,0,640,480);

      //draw SUN
      fill(253,184,19);
      stroke(255,255,0);
      strokeWeight(5);
      ellipse(sunX,sunY,120,120);
      //draw grass
      colorMode(RGB);
      fill(124,204,25);
      noStroke();
      if (groundhogYLevel==0) rect(0,145,640,15);
      if (groundhogYLevel==1) rect(0,65,640,15);
      
      if(groundhogYLevel>1) soilStartY=0;
      if(groundhogYLevel==1) soilStartY=80;
      if(groundhogYLevel==0) soilStartY=160;
      soilLowBound=groundhogYLevel;
      if(soilLowBound<2) soilLowBound=0;
      else soilLowBound=soilLowBound-2;
      if(soilLowBound>18) soilLowBound=18;

      //draw soil
      for(int i=soilLowBound, m=0; i<soilLowBound+6; i++, m++) {
        for (int j=0; j<8; j++) {
          switch(soilMatrix[i][j]) {
            case 0:            image(soil0,80*j,soilStartY+m*80,80,80);
            break;
            case 1:            image(soil1,80*j,soilStartY+m*80,80,80);
            break;
            case 2:            image(soil2,80*j,soilStartY+m*80,80,80);
            break;
            case 3:            image(soil3,80*j,soilStartY+m*80,80,80);
            break;
            case 4:            image(soil4,80*j,soilStartY+m*80,80,80);
            break;
            case 5:            image(soil5,80*j,soilStartY+m*80,80,80);
            break;
          }
          switch(stoneMatrix[i][j]) {
            case 1:            image(stone1,80*j,soilStartY+m*80,80,80);
            break;
            case 2:            image(stone2,80*j,soilStartY+m*80,80,80);
            break;
          }
        }
      }

      //image(soldier, soldierX, soldierY);

      if (isActive==false) groundhogState=groundhog_IDLE;
      
      switch(groundhogState) {
        case groundhog_IDLE:
          image(groundhogIdle, groundhogX, groundhogY); 
        break;
        case groundhog_LEFT:
            if((frameCount-nowframeCount)<=15) {
              if ((frameCount-nowframeCount)%3==0)
                groundhogX-=16;
              image(groundhogLeft, groundhogX, groundhogY);                                                  //groundhogLeft status
            }
            else {
              isActive=false;
            }
        break;
        case groundhog_RIGHT:
            if((frameCount-nowframeCount)<=15) {
              if ((frameCount-nowframeCount)%3==0)
                groundhogX+=16;
              image(groundhogRight, groundhogX, groundhogY);                                                //groundhogRight status
            }
            else {
              isActive=false;
            }
        break;
        case groundhog_DOWN:
            if((frameCount-nowframeCount)<=15) {
              if (groundhogYLevel<18)
                image(groundhogDown, groundhogX, groundhogY);                                                   //groundhogDown status
              else {
                   if ((frameCount-nowframeCount)%3==0) {
                     groundhogY+=16;
                     image(groundhogDown, groundhogX, groundhogY); 
                   }
                }
            }
            else {
              groundhogYLevel++;
              println(groundhogYLevel);
            isActive=false;
            }
        break;
      }
      
      //if(drawCabbage) image(cabbage, cabbageX, cabbageY);                                                 //cabbage status
      
      for(int i=0; i<HP; i++)
        image(life,10+60*i,10,50,51);                                                                     //life status
      
      //soldierX+=soldierSpeedX;                                                                            //soldier move
      //soldierX %= 640;                                                                                    //soldier move cycle

      //Cabbage collision detect
      /*
      if(drawCabbage) {                                                                                                 //Cabbage collision condition
        if(groundhogX<cabbageX+80 && groundhogX+80>cabbageX && groundhogY<cabbageY+80 && groundhogY+80>cabbageY) {
          drawCabbage=false;                                                                                            //Cabbage status
          HP++;                                                                                                         //add life
        }
      }
      */
        
      //soldier collision detect
      /*
      if(groundhogX<soldierX+80 && groundhogX+80>soldierX && groundhogY<soldierY+80 && groundhogY+80>soldierY) {        //soldier collision condition
        soldierCollision=true;
        groundhogState = groundhog_IDLE;
        isActive=false;
        groundhogX = 320;
        groundhogY = 80;
        HP--;                                                                                                            //cut life
      }
      */
      if(HP<1) gameState = GAME_OVER;                                                                                      //GAME_OVER condition
    break;
    case GAME_OVER:                                                                                                      //GAME_OVER status
      image(gameover, 0, 0);
      image(restartNormal,BUTTON_LEFT,BUTTON_TOP);
      if(mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT  && mouseY > BUTTON_TOP && mouseY < BUTTON_BOTTOM){
        image(restartHovered,BUTTON_LEFT,BUTTON_TOP);
        if(mousePressed) { HP=2; drawCabbage=true; gameState=GAME_RUN;}                                                  //GAME_RUN reset life
      }
    break;
  }
}

void keyPressed(){  //path control
    if (!isActive) {
      switch(keyCode){
        case DOWN:
        if (groundhogY < height-80) {
          isActive = true;
          groundhogState = groundhog_DOWN;
          nowframeCount=frameCount;
        }
        else groundhogState = groundhog_IDLE;
        break;
        case RIGHT:
        if (groundhogX < width-80) {
          isActive = true;
          groundhogState = groundhog_RIGHT;
          nowframeCount=frameCount;
        }
        else groundhogState = groundhog_IDLE;
        break;
        case LEFT:
        if (groundhogX > 0) {
          isActive = true;
          groundhogState = groundhog_LEFT;
          nowframeCount=frameCount;
        }
        else groundhogState = groundhog_IDLE;
        break;
      }
    }
}

void keyReleased(){
  switch(keyCode){
    case DOWN:
    downPressed = false;
    break;
    case RIGHT:
    rightPressed = false;
    break;
    case LEFT:
    leftPressed = false;
    break;
  }
}
