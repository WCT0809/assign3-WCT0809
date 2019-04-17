final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2,GAME_WIN = 3;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
  
PImage bg, cabbage, life, soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5; 
PImage stone1, stone2; 
PImage groundhogDown, groundhogIdle, groundhogLeft, groundhogRight;
PImage startHovered, startNormal, restartHovered, restartNormal, title, gameover;          //all image
int groundhogX, groundhogY;//about groundhog Location
final int groundhog_IDLE = 0;
final int groundhog_LEFT = 1;
final int groundhog_RIGHT = 2;
final int groundhog_DOWN = 3;
int groundhogState = groundhog_IDLE;

int nowframeCount;                                                                 //frameCount about groundhog*
boolean upPressed, downPressed, rightPressed, leftPressed, isActive=false;                //about groundhog control

int groundhogYLevel=0;
int soilStartX, soilStartY, soilEndX, soilEndY; 
int [][]soilMatrix=new int[24][8];
int [][]stoneMatrix=new int[24][8];
int soilLowBound;
// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480, P2D);
  frameRate(60);  
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
  life=loadImage("img/life.png");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");

  groundhogDown=loadImage("img/groundhogDown.png");
  groundhogIdle=loadImage("img/groundhogIdle.png");
  groundhogLeft=loadImage("img/groundhogLeft.png");
  groundhogRight=loadImage("img/groundhogRight.png");
  
  soil0=loadImage("img/soil0.png");
  soil1=loadImage("img/soil1.png");
  soil2=loadImage("img/soil2.png");
  soil3=loadImage("img/soil3.png");
  soil4=loadImage("img/soil4.png");
  soil5=loadImage("img/soil5.png");
  stone1=loadImage("img/stone1.png");
  stone2=loadImage("img/stone2.png");
  groundhogX = 320;
  groundhogY = 80;  
//	soil8x24 = loadImage("img/soil8x24.png"); //noshow this
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
  

}

void draw() {
  clear();
  /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;

		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
//		image(soil8x24, 0, 160);
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
		// Player
      if (groundhogYLevel==0) rect(0,145,640,15);
      if (groundhogYLevel==1) rect(0,65,640,15);
      
      if(groundhogYLevel>1) soilStartY=0;
      if(groundhogYLevel==1) soilStartY=80;
      if(groundhogYLevel==0) soilStartY=160;
      soilLowBound=groundhogYLevel;
      if(soilLowBound<2) soilLowBound=0;
      else soilLowBound=soilLowBound-2;
      if(soilLowBound>18) soilLowBound=18;
      
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
      
		// Health UI
      for(int i=0; i<playerHealth; i++)
        image(life,10+60*i,10,50,51);     
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
			}
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
	// Add your moving input code here
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
	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
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
