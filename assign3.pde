final float OFFSET_X = 80, OFFSET_Y = 80;
final int TWENTY_FLOOR = 1600;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = GAME_START;

final int BOTTON_NORMAL = 0;
final int BOTTON_DOWN = 1;
final int BOTTON_LEFT = 2;
final int BOTTON_RIGHT = 3;
int bottonState = BOTTON_NORMAL;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

final float LIFE_SPACE = 70;
final float LIFE_MAX = 5;
final float LIFE_Y = 10;
final float LIFE_X_START = 10;

final float SOLDIER_W = 80, SOLDIER_H = 80;
final float SOLDIER_SPEED = 5;

final float CABBAGE_W = 80, CABBAGE_H = 80;

final float GROUNDHOG_INIT_X = OFFSET_X*4;
final float GROUNDHOG_INIT_Y = OFFSET_Y;
final float GROUNDHOG_W = 80;
final float GROUNDHOG_H = 80;
final float GROUNDHOG_SPEED = round(80/15);

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;
PImage bg, life, cabbage, soldier, stone1, stone2;
PImage [] soil;

float cabbageX, cabbageY;

float soldierX, soldierY;

float groundhogX = OFFSET_X*4;
float groundhogY = OFFSET_Y;
float groundhog_count;

float screen_Y_Offset;
float screen_Y_Count;

int soils = 0;

int [] col;
int [] row;

int lifeX, lifeY;

boolean downPressed, leftPressed, rightPressed = false;


// For debug function; DO NOT edit or remove this!
int playerHealth = 2;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() { //480
  size(640, 480, P2D);
  // Enter your setup code here (please put loadImage() here or your game will lag like crazy)
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  
  soil = new PImage[6];
  for(int i = 0; i < 6; i++){
     soil[i] = loadImage("img/soil"+i+".png");
  }
  
  col = new int [8];
  for(int x = 0; x < 8; x++){
    col[x] = x*80;
  }
  
  row = new int [24];
  for(int y = 0; y < 24; y++){
    row[y] = 160 + y*80;
  }
  
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");
  
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  
  soldierX = -80;
  soldierY = row[floor(random(4))];
  
  cabbageX = col[floor(random(8))];
  cabbageY = row[floor(random(4))];
  
  groundhogX = GROUNDHOG_INIT_X;
  groundhogY = GROUNDHOG_INIT_Y;
  groundhog_count = 0;
  
  screen_Y_Count = 0;
  screen_Y_Offset = 0; 
  
  bottonState = BOTTON_NORMAL;
  
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
    break;

    case GAME_RUN: // In-Game

    // Background
    image(bg, 0, 0);

    // Sun
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(width - 50, 50, 120, 120);
    
    
    // Screen Scroll 
    if(screen_Y_Offset <= TWENTY_FLOOR){
      if(screen_Y_Count < screen_Y_Offset){
        
        screen_Y_Count += GROUNDHOG_SPEED;
        cabbageY -= GROUNDHOG_SPEED;
        soldierY -= GROUNDHOG_SPEED;
        
        for(int y = 0; y < 24; y++){
           row[y] -= GROUNDHOG_SPEED;
        }
      }
    }
    
    // Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
    for(int x = 0; x < 8; x++){
      soils = 0;
      for(int y = 0; y < 24; y++){
        if(y%4 == 0 && soils < 5 && y >= 4){
          soils ++;
        }
        image(soil[soils], col[x], row[y]);
      }
    } 
    
    // Grass
    fill(124, 204, 25);
    noStroke();
    rect(0, row[0] - GRASS_HEIGHT, width, GRASS_HEIGHT);
    
    // Stone 1-16
    for(int y = 0; y < 16; y++){
      if(y < 8){ // Stone 1-8
        image(stone1, y * 80, row[y]); 
        
      }else if(y < 16){ // Stone 9-16
        for(int x = 0; x < 8; x++){
          if(y == 8 || y == 11 || y == 12 || y == 15){ 
            
            if(x == 1 || x == 2 || x == 5 || x == 6){
              image(stone1, x * 80, row[y]);
            }
          }else{
            if(x == 0 || x == 3 || x == 4 || x == 7 ){
              image(stone1, x * 80, row[y]);
            }
          }
        }
      }
    }
    
    // Stone 17-24
    for(int x = 0; x < 15; x++){ 
      if(x%3 != 0){                    
         int colX = 0;
         
        for(int y = 16; y < 24; y++){  
            image(stone1, colX + x*80, row[y]);
            
            if(x == 2 || x == 5 || x == 8|| x== 11 || x == 14){
            image(stone2, colX + x*80, row[y]);
            }
            colX -= 80;
        }
      }
    }  
    
    // Cabbage
    if(groundhogX < cabbageX + CABBAGE_W    // hit detection
    && groundhogX + GROUNDHOG_W > cabbageX
    && groundhogY < cabbageY + CABBAGE_H
    && groundhogY + GROUNDHOG_H > cabbageY){
      cabbageY = - 80;
      if(playerHealth < 5) playerHealth ++;
    }else{
      image(cabbage, cabbageX, cabbageY);
    }
    
    // Life
    for(int i = 0; i < playerHealth ; i++){
      image(life, LIFE_X_START + i * LIFE_SPACE, LIFE_Y);
    }
    
    // Soldier
    image(soldier, soldierX, soldierY);
    
    soldierX += SOLDIER_SPEED; // Soldier Move
    
    if(soldierX > SOLDIER_W + width ){ // Soldier Loop
      soldierX = -80;
    }
    
    // Groundhog Move
    if(bottonState == BOTTON_NORMAL){
      
      groundhog_count = 0;
      image(groundhogIdle, groundhogX, groundhogY);
      
    }else{
      
      if(groundhog_count < 80){
        
        groundhog_count += GROUNDHOG_SPEED;
        
        if(bottonState == BOTTON_DOWN){
            
          if(screen_Y_Offset > TWENTY_FLOOR){
            groundhogY += GROUNDHOG_SPEED;
            // Border Range
            if(groundhogY + GROUNDHOG_H > height){
              groundhogY = height - GROUNDHOG_H;
            }
          }
          
          image(groundhogDown, groundhogX, groundhogY);
          
          }else if(bottonState == BOTTON_LEFT){
            
            groundhogX -= GROUNDHOG_SPEED;
            // Border Range
            if(groundhogX < 0){
                groundhogX = 0;
              }
            image(groundhogLeft, groundhogX, groundhogY);
            
          }else if(bottonState == BOTTON_RIGHT){
            
            groundhogX += GROUNDHOG_SPEED;
            // Border Range
            if(groundhogX + GROUNDHOG_W > width){
              groundhogX = width - GROUNDHOG_W;
            }
            image(groundhogRight, groundhogX, groundhogY);
          }  
          
        }else{
          
          if(downPressed || leftPressed || rightPressed){
            
            downPressed = false;
            leftPressed = false;
            rightPressed = false;
            
            image(groundhogIdle, groundhogX, groundhogY);
            
          }else{
            
            groundhog_count = 0;
            image(groundhogIdle, groundhogX, groundhogY);
            bottonState = BOTTON_NORMAL;
            
          }
        }
    }
     
    // Soldier Hit 
    if(groundhogX < soldierX + SOLDIER_W   
       && groundhogX + GROUNDHOG_W > soldierX
       && groundhogY < soldierY + SOLDIER_H
       && groundhogY + GROUNDHOG_H > soldierY){
    
      playerHealth --;
      if(playerHealth == 0){
        gameState = GAME_OVER;
      }
      setup();
      //image(groundhogIdle, groundhogX, groundhogY);
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
        // Initialize Game
        playerHealth = 2;
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
    // Moving 
    if(key == CODED){
      if(bottonState == BOTTON_NORMAL
      && gameState == GAME_RUN){  
        switch(keyCode){
          case DOWN:
            bottonState = BOTTON_DOWN;
            downPressed = true;
            
            if(screen_Y_Offset < TWENTY_FLOOR + OFFSET_Y*2){
              screen_Y_Offset += 80;
            }
            
            break;
          case LEFT:
            bottonState = BOTTON_LEFT;
            leftPressed = true;
            break;
          case RIGHT:
            bottonState = BOTTON_RIGHT;
            rightPressed = true;
            break;   
        }
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
  if(key == CODED){
      switch(keyCode){
        case DOWN:
          downPressed = false;
          break;
        case LEFT:
          leftPressed = false;
          break;
        case RIGHT:
          rightPressed = false;
          break; 
      }
  }
}
