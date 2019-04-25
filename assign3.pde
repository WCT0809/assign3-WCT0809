final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
final int SOILWIDTH = 80;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundHog , groundHogLeft , groundHogRight , groundHogDown ;
PImage bg, soil8x24 , soldier , cabbage ;
PImage [] soils ;
PImage heart , stone1 , stone2 ;

int groundHogX , groundHogY ;
int groundHogR , groundHogB ;
int groundHogSpeed = 80/16;

boolean down = false;
boolean left = false;
boolean right = false;
boolean idle = false;

//Special Down
float groundHogY2 = 80;
boolean down2 = false;
boolean idle2 = false;
boolean left2 = false;
boolean right2 = false;


// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	soil8x24 = loadImage("img/soil8x24.png");
  groundHog = loadImage("img/groundhogIdle.png");
  groundHogLeft = loadImage("img/groundhogLeft.png");
  groundHogRight = loadImage("img/groundhogRight.png");
  groundHogDown = loadImage("img/groundhogDown.png");

  soils = new PImage [6];
  for(int i = 0 ; i<6 ; i++ ){
    soils[i] = loadImage("img/soil"+i+".png");
  }
  
   heart = loadImage("img/life.png");
   stone1 = loadImage("img/stone1.png");
   stone2 = loadImage("img/stone2.png");
   
   playerHealth = 2 ;
   groundHogX = width/2;
   groundHogY = 80;
   idle = true;

}

void draw() {
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

    down = false;
    left = false;
    right = false;

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
		rect(0, 240 - GRASS_HEIGHT - groundHogY , width, GRASS_HEIGHT);

		// Soil - REPLACE THIS PART WITH YOUR LOOP CODE!

    for(int i = 0 ; i < 24 ; i++ ){
      for( int j = 0 ; j < 8 ; j++ ){
        int x = j*80;
        int y = 240 + i*80 - groundHogY;
        if(i<24){
        image(soils[5],x,y);
          if( i < 20 ){
          image(soils[4],x,y);
            if( i < 16 ){
              image(soils[3],x,y);
              if(i<12){
                image(soils[2],x,y);
                if(i<8){
                  image(soils[1],x,y);
                  if(i<4){
                    image(soils[0],x,y);
                  }
                }
              }
            }
          }
        }
      }
    }
    
    // stone
    
      // floor1
      
    for(int i = 0 ; i<8 ; i++){
      int x = i*80;
      int y = i*80 + 240 - groundHogY ;
      image(stone1 , x , y );
    }
    
      // floor2
      
    for(int i = 0 ; i<8 ; i++){
      int x = width - 560 - i*80;
      int y = 880 + i*80 - groundHogY ; 
      image(stone1 , x , y );
      image(stone1 , x + 320 , y );
      image(stone1 , x + 640 , y );
      image(stone1 , x + 960 , y );
    }
    
    for(int i = 0 ; i<8 ; i++){
      int x =  160 + i*80;
      int y = 880 + i*80 - groundHogY ; 
      image(stone1 , x , y );
      image(stone1 , x + 320 , y );
      image(stone1 , x + 640 , y );
      image(stone1 , x - 320 , y );
      image(stone1 , x - 640 , y );
    }
      
      // floor3
    for(int i = 0 ; i < 8 ; i++){
      int x = width - 80 - i*80;
      int y = 1520 + i*80 - groundHogY ; 
      int x2 = width - i*80;
      int y2 = 1520 + i*80 - groundHogY ; 
      image(stone1 , x , y );
      image(stone1 , x-160 , y );
      image(stone1 , x-240 , y );
      image(stone1 , x-400 , y );
      image(stone1 , x-480 , y );
      image(stone1 , x+80 , y );
      image(stone1 , x+240 , y );
      image(stone1 , x+320 , y );
      image(stone1 , x+480 , y );
      image(stone1 , x+560 , y );

      image(stone2 , x2 , y2 );
      image(stone2 , x2-240 , y2 );
      image(stone2 , x2-480 , y2 );
      image(stone2 , x2+240 , y2 );
      image(stone2 , x2+480 , y2 );
      
    }
    
    
		// Player
    if(idle){
      image(groundHog,groundHogX,80);
    }
    
    if(down){
      
      image(groundHogDown,groundHogX,80);
      idle = false;
      left = false;
      right = false;
      groundHogY += groundHogSpeed;
      for(int i = 0 ; i < 24 ; i ++){
        if(groundHogY == 160+i*80){
          down = false;
          idle = true;
        }
      }
    }
    
    if(left){
      image(groundHogLeft,groundHogX,80);
      idle = false;
      right = false;
      down = false;
      groundHogX -= groundHogSpeed;
      if(groundHogX == 0||groundHogX == 80||groundHogX == 160||groundHogX == 240||groundHogX == 320||groundHogX == 400||groundHogX == 480||groundHogX == 560){
        left = false;
        idle = true;
      }
    }
    if(right){
      image(groundHogRight,groundHogX,80);
      idle = false;
      left = false;
      down = false;
      groundHogX += groundHogSpeed;
      if(groundHogX == 0||groundHogX == 80||groundHogX == 160||groundHogX == 240||groundHogX == 320||groundHogX == 400||groundHogX == 480||groundHogX == 560){
        right = false;
        idle = true;
      }
    }
    
		// Health UI
    
    for(int i = 0 ; i<playerHealth ; i++ ){
      float x = 10 + i*70;
      float y = 10;
      image(heart , x , y);
    }
    
    // SpecialDown
    
    if(down2){
      image(groundHogDown,groundHogX,groundHogY2);
      idle2 = false;
      left2 = false;
      right2 = false;
      groundHogY2 += groundHogSpeed;
      if(groundHogY2 == 160||groundHogY2 == 240||groundHogY2 == 320||groundHogY2 == 400){
        down2 = false;
        idle2 = true;
      }
    }
    if(idle2){
      image(groundHog,groundHogX,groundHogY2);
    }
    if(left2){
      image(groundHogLeft,groundHogX,groundHogY2);
      idle2 = false;
      right2 = false;
      down2 = false;
      groundHogX -= groundHogSpeed;
      if(groundHogX == 0||groundHogX == 80||groundHogX == 160||groundHogX == 240||groundHogX == 320||groundHogX == 400||groundHogX == 480||groundHogX == 560){
        left2 = false;
        idle2 = true;
      }
    }
    if(right2){
      image(groundHogRight,groundHogX,groundHogY2);
      idle2 = false;
      left2 = false;
      down2 = false;
      groundHogX += groundHogSpeed;
      if(groundHogX == 0||groundHogX == 80||groundHogX == 160||groundHogX == 240||groundHogX == 320||groundHogX == 400||groundHogX == 480||groundHogX == 560){
        right2 = false;
        idle2 = true;
      }
    }

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
    
    if(key == CODED){
    switch( keyCode ){
      
      case DOWN:
      down = true;
      if(groundHogY >= 1680 && groundHogY < 2000 ){down2 = true;down = false ;idle = false;}
      if(groundHogY2 >= 400){down2 = false;}
      if(left || left2 ){down = false;down2 = false;}  // Prevent bug
      if(right || right2 ){down = false;down2 = false;}  // Prevent bug
      break;
      
      case LEFT:
      left = true;
      if(groundHogY >= 1680 && groundHogY < 2000 ){left2 = true;left = false ;idle = false;}
      if(groundHogX <= 0){left = false;left2 = false;}  // Prevent bug
      if(down || down2 ){left = false;left2 = false;}  // Prevent bug
      if(right || right2 ){left = false;left2 = false;}  // Prevent bug
      break;
      
      case RIGHT:
      right = true;
      if(groundHogY >= 1680 && groundHogY < 2000 ){right2 = true;right = false ;idle = false;}
      if(groundHogX >= 560){right = false;right2 = false;}
      if(down || down2){right = false;right2 = false;}  // Prevent bug
      if(left || left2){right = false;right2 = false;}  // Prevent bug
      break;
        
    }
  }
}
