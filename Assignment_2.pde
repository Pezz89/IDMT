/*
 * IDMT Mini-Assignment 2
 *
 * Tank Wars: a simple game of throwing projectiles
 * This is a skeleton with a few basic pieces filled
 * in. You will need to fill in the rest to make the 
 * game work.
 */

// Basic information on the terrain and the tanks

float[] groundLevel;  // Y coordinate of the ground for each X coordinate
float tank1X, tank1Y, tank2X, tank2Y; // Positions of the two tanks
float tankDiameter = 30;  // Diameter of the tanks
float cannonLength = 25;  // How long the cannon on each tank extends
float tank1CannonX1, tank1CannonX2, tank1CannonY1, tank1CannonY2;
float tank2CannonX1, tank2CannonX2, tank2CannonY1, tank2CannonY2;
float gravity = 0.05;      // Strength of gravity
float velocity;
boolean contactMade = false;
int projectileSize = 8;

// Current state of the game

int playerHasWon = 0; // 1 if player 1 wins, 2 if player 2 wins, 0 if game in progress
boolean player1Turn = true;  // true if it's player 1's turn; false otherwise
float tank1CannonAngle = PI/2, tank2CannonAngle = PI/2; // Direction the tank cannons are pointing
float tank1CannonStrength = 3, tank2CannonStrength = 3; // Strength of intended projectile launch

// Location of the projectile

boolean projectileInMotion = false;
float projectilePositionX, projectilePositionY;
float projectileVelocityX, projectileVelocityY;

PImage bg;

// Terrain generation function adapted from: http://www.redblobgames.com/articles/noise/introduction.html
void GenerateTerain() {
    float amp[] = {random(1.5,2.5), random(0.8,1.4), random(0.1, 0.3), random(0.0001, 0.002), 0.01, 0.01};
    int frequency[] = {1, 2, 4, 8, 16, 32};
    float phase = random(0, 2*PI);
    
    for(int i = 0; i < width; i++) {
      groundLevel[i] = 0;
    }
    for(int i = 0; i < width; i++) {
      for(int j = 0; j < frequency.length; j++) {
        groundLevel[i] += (sin(2*PI * frequency[j]*i/width + phase)*amp[j])*30;
      }  
    }
    for(int i = 0; i < width; i++) {
      groundLevel[i] += height - (height / 3.5);
    }
}

void setup() {
  size(960, 480);  // Set the screen size
  // Background image taken from https://www.behance.net/gallery/31516629/CARTOON-BACKGROUNDS
  bg = loadImage("background.png");
  
  // Initialize the ground level
  groundLevel = new float[width];
  GenerateTerain();
  float player1Height = groundLevel[int(width*0.1)];
  float player2Height = groundLevel[int(width*0.9)];
  
  // Set the location of the two tanks so they rest on the ground at opposite sides
  tank1X = width * 0.1;
  tank1Y = player1Height;
  tank2X = width * 0.9;
  tank2Y = player2Height;
}

void draw() {
  // Main draw loop. Farm out the individual tasks to other functions
  // for clarity (though it could be equivalently implemented entirely in this function.)
  
  background(bg);
  
  drawTanks();
  drawGround();
  drawProjectile();
  drawStatus();
  
  updateProjectilePositionAndCheckCollision();
}

// Draw the terrain under the tanks
void drawGround() {
  /* TO IMPLEMENT IN STEP 1 */
  strokeWeight(5);
  beginShape();
  int idx;
  for(idx = 0; idx < groundLevel.length; idx++){
    vertex(idx, groundLevel[idx]);
  }
  vertex(idx, height);
  vertex(0, height);
  fill(250, 236, 157);
  endShape();
  
  strokeWeight(0);
  beginShape();
  for(idx = 0; idx < groundLevel.length; idx++){
    vertex(idx, (groundLevel[idx] * 0.85)+70);
  }
  vertex(idx, height);
  vertex(0, height);
  fill(235, 222, 137);
  endShape();
  strokeWeight(5);
  
  // See the groundLevel[] variable to know where to draw the ground
  // Ground should be drawn in a dark gray

}

// Draw the two tanks (including cannons)
void drawTanks() {
  /* TO IMPLEMENT IN STEP 1 */
  
  // Draw the two tanks as semicircles using the positions and sizes at the top of the file
  // Tanks should be different colours
  // Also be sure to draw the cannons, using the angles given at the top of the file
  
  // Draw tank 1
  strokeWeight(10);
  
  tank1CannonX1 = tank1X;
  tank1CannonX2 = tank1X + (cannonLength * cos(tank1CannonAngle));
  tank1CannonY1 = tank1Y;
  tank1CannonY2 = tank1Y - (cannonLength * sin(tank1CannonAngle));
  line(tank1CannonX1, tank1CannonY1, tank1CannonX2, tank1CannonY2);
  strokeCap(SQUARE);
  
  strokeWeight(5);
  fill(255, 0, 0);
  ellipse(tank1X, tank1Y, tankDiameter, tankDiameter);
  
  // Draw tank 2
  strokeWeight(10);
  tank2CannonX1 = tank2X;
  tank2CannonX2 = tank2X + (cannonLength * cos(tank2CannonAngle));
  tank2CannonY1 = tank2Y;
  tank2CannonY2 = tank2Y - (cannonLength * sin(tank2CannonAngle));
  line(tank2CannonX1, tank2CannonY1, tank2CannonX2, tank2CannonY2);
  strokeWeight(5);
  fill(0, 0, 255);
  ellipse(tank2X, tank2Y, tankDiameter, tankDiameter);
}

// Draw the projectile, if one is currently in motion
void drawProjectile() {
  if(!projectileInMotion && !contactMade)  // Don't draw anything if there's no projectile in motion
    return;
  else if(contactMade && projectileSize > 32) {
    contactMade = false;
    nextPlayersTurn();
  }
  // Save the current global stroke colour
  // (Hacky workaround due to everything being in the global namespace)
  int strokeColourVar = g.strokeColor;
  noStroke();
  fill(255, 255, 0);
  ellipse(projectilePositionX, projectilePositionY, projectileSize, projectileSize);
  // Recover previously set stroke colour
  stroke(strokeColourVar);
}

// Draw the status text on the top of the screen
void drawStatus() {
  float strokeWeightVar = g.strokeWeight;
  int strokeColourVar = g.strokeColor;
  strokeWeight(2);
  stroke(230, 249, 211);
  fill(201, 246, 203);
  rect(0, 0, width, 45);
  strokeWeight(strokeWeightVar);
  stroke(strokeColourVar);
  
  textSize(24);
  textAlign(LEFT);
  fill(0);
  
  if(playerHasWon == 1)
    text("Player 1 Wins!", 10, 30);
  else if(playerHasWon == 2)
    text("Player 2 Wins!", 10, 30);
  else if(player1Turn) { // player1Turn == true means it's player 1's turn
    text("Player 1's turn |", 10, 30);
     textAlign(RIGHT);   
    text("| Angle: " + tank1CannonAngle + " | Strength: " + tank1CannonStrength, width - 10, 30);
  }
  else {                 // player1Turn == false
    text("Player 2's turn |", 10, 30);
    textAlign(RIGHT);
    text("| Angle: " + tank2CannonAngle + " | Strength: " + tank2CannonStrength, width - 10, 30);
  }
}

// Move the projectile and check for a collision
void updateProjectilePositionAndCheckCollision() {
  if(!projectileInMotion && !contactMade) {
    projectileSize = 8;
    return;
  }
  if(player1Turn) {
    /* TO IMPLEMENT IN STEP 3: UPDATE POSITION */
    
    if(!contactMade) {
      // Tasks: increment the position according to the velocity
      // For later: the velocity according to gravity (and optionally wind)  
      projectilePositionX += tank1CannonStrength * cos(tank1CannonAngle);
      projectilePositionY += (velocity * -sin(tank1CannonAngle));
    }
    else {
      projectileSize += 1;
    }
    
    /* TO IMPLEMENT IN STEP 4: GRAVITY */
    // Update the velocity of the projectile according to the value of gravity at the top of the file
    velocity -= gravity;
    
    /* TO IMPLEMENT IN STEP 5: COLLISION DETECTION */
    // Compare the location of the projectile to the ground and to the two tanks
    // (Conditions ordered to avoid indexing error in final condition)
   
    // When the projectile hits the ground, it's the next player's turn
    if(round(projectilePositionX) >= width || round(projectilePositionX) <= 0) {
      // When the projectile hits something, it stops moving (change projectileInMotion)
      projectileInMotion = false;
      contactMade = false;
      nextPlayersTurn();

    }
    else if (projectilePositionY > groundLevel[round(projectilePositionX)]) {
      projectileInMotion = false;
      contactMade = true;
    }

  }
  else {
    /* TO IMPLEMENT IN STEP 3: UPDATE POSITION */
    
    // Tasks: increment the position according to the velocity
    // For later: the velocity according to gravity (and optionally wind)  
    if(!contactMade) {
      // Tasks: increment the position according to the velocity
      // For later: the velocity according to gravity (and optionally wind)  
      projectilePositionX += tank2CannonStrength * cos(tank2CannonAngle);
      projectilePositionY += (velocity * -sin(tank2CannonAngle));
    }
    else {
      projectileSize += 1;
    }
    velocity -= gravity;
    
    /* TO IMPLEMENT IN STEP 5: COLLISION DETECTION */
    // Compare the location of the projectile to the ground and to the two tanks
    // (Conditions ordered to avoid indexing error in final condition)
   
    // When the projectile hits the ground, it's the next player's turn
    if(projectilePositionX >= width || projectilePositionX <= 0) {
      // When the projectile hits something, it stops moving (change projectileInMotion)
      projectileInMotion = false;
      contactMade = false;
      nextPlayersTurn();
      
    }
    else if (projectilePositionY > groundLevel[round(projectilePositionX)]) {
      projectileInMotion = false;
      contactMade = true;
    }
  }  
  // When the projectile hits a tank, the other player wins
  // Collision detection for full circle implemented as extra computation for semi-circle is unnecessary
  if(dist(projectilePositionX, projectilePositionY, tank2X, tank2Y) < (tankDiameter/2.0) + (projectileSize / 2)) {
    projectileInMotion = false;
    contactMade = true;
    playerHasWon = 1;
  }
  else if(dist(projectilePositionX, projectilePositionY, tank1X, tank1Y) < (tankDiameter/2.0) + (projectileSize / 2)) {
    projectileInMotion = false;
    contactMade = true;
    playerHasWon = 2;
  }
}

// Advance the turn to the next player
void nextPlayersTurn() {
  player1Turn = !player1Turn;
}
float validateAngle(float angle) {
    if(angle > PI)
  {
    angle = PI;
  }
  else if(angle < 0)
  {
    angle = 0.0;
  }
  return angle;
}
float validateStrength(float strength) {
    if(strength > 10.0)
  {
    strength = 10.0;
  }
  else if(strength < 1.0)
  {
    strength = 1.0;
  }
  return strength;
}
// Handle a key press: update the status of the current player's tank
void keyPressed() {
  if(playerHasWon != 0)  // Stop the game when someone has won
    return;
  if(projectileInMotion) // No keys respond while the projectile is firing
    return;
  

  /* TO IMPLEMENT IN STEP 2 */  
    
  // Use the key variable to check which key was pressed.
  // Arrow keys don't have a printable character, so they show up as CODED
  // Use the left and right arrows to adjust the angle, the up and down arrows
  // to adjust strength.
  switch(key) {
    case CODED: 
      if(player1Turn) {
        switch(keyCode) {
          case LEFT: tank1CannonAngle += PI/180.0;
            break;
          case RIGHT: tank1CannonAngle -= PI/180.0;
            break;
          case UP: tank1CannonStrength += 1;
            break;
          case DOWN: tank1CannonStrength -= 1;
            break;
        }
        tank1CannonAngle = validateAngle(tank1CannonAngle);
        tank1CannonStrength = validateStrength(tank1CannonStrength);
      }
      else
      {
        switch(keyCode) {
          case LEFT: tank2CannonAngle += PI/180.0;
            break;
          case RIGHT: tank2CannonAngle -= PI/180.0;
            break;
          case UP: tank2CannonStrength += 1;
            break;
          case DOWN: tank2CannonStrength -= 1;
            break;
        }
        tank2CannonAngle = validateAngle(tank2CannonAngle);
        tank2CannonStrength = validateStrength(tank2CannonStrength);
      }
      break;
      
    // Space bar fires the projectile. Initially in step 2, just have it switch
    // to the next player.
    case ' ':
      if(player1Turn) {
        projectileInMotion = true;
        projectilePositionX = tank1CannonX2;
        projectilePositionY = tank1CannonY2;
        velocity = tank1CannonStrength;
        drawProjectile();
      }
      else {
        projectileInMotion = true;
        projectilePositionX = tank2CannonX2;
        projectilePositionY = tank2CannonY2;
        velocity = tank2CannonStrength;
        drawProjectile();
      }
      
      break;
  }
}