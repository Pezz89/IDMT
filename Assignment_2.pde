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
// Store velocity of projectile
float velocity;  
// Store value for if projectile has collided with the ground or a tank
boolean contactMade = false;
// Store the diameter of the projectile
int projectileSize = 8;

// Current state of the game

int playerHasWon = 0; // 1 if player 1 wins, 2 if player 2 wins, 0 if game in progress
boolean player1Turn = true;  // true if it's player 1's turn; false otherwise
float tank1CannonAngle = PI/2, tank2CannonAngle = PI/2; // Direction the tank cannons are pointing
float tank1CannonStrength = 3, tank2CannonStrength = 3; // Strength of intended projectile launch

// Location of the projectile

// Store the state of the projectile
boolean projectileInMotion = false;
// Store projectile position and velocity values on screen
float projectilePositionX, projectilePositionY;
float projectileVelocityX, projectileVelocityY;

// Image object to encapsulate the background image
PImage bg;

// Terrain generation function adapted from: http://www.redblobgames.com/articles/noise/introduction.html
// Generate varying hills and valleys for terrain.
void GenerateTerain() {
    // Store amplitudes (randomly generated within arbritrary limits) for each
    // sine wave
    float amp[] = {random(1.5,2.5), random(0.8,1.4), random(0.1, 0.3), random(0.0001, 0.002), 0.01, 0.01};
    // Store frequencies (Hz) for each sine wave
    int frequency[] = {1, 2, 4, 8, 16, 32};
    // generate a random phase for sine waves
    float phase = random(0, 2*PI);
    
    // Initialize all values of groundLevel to 0
    for(int i = 0; i < width; i++) {
      groundLevel[i] = 0;
    }
    // for every ground level array element
    for(int i = 0; i < width; i++) {
      // for all sine components to be accumulated
      for(int j = 0; j < frequency.length; j++) {
        // generate the current sample value for the current sine wave
        groundLevel[i] += (sin(2*PI * frequency[j]*i/width + phase)*amp[j])*30;
      }  
    }
    // Apply an arbitrary offset to place terrain at appropriate level on
    // screen
    for(int i = 0; i < width; i++) {
      groundLevel[i] += height - (height / 3.5);
    }
}

void setup() {
  size(960, 480);  // Set the screen size
  // Background image taken from https://www.behance.net/gallery/31516629/CARTOON-BACKGROUNDS
  // Load the background image into object
  bg = loadImage("background.png");
  
  // Initialize the ground level
  groundLevel = new float[width];
  // Fill groundLevel array with values
  GenerateTerain();
  // set the height of the tanks relative to the generated ground level
  float player1Height = groundLevel[int(width*0.1)];
  float player2Height = groundLevel[int(width*0.9)];
  
  // Set the location of the two tanks so they rest on the ground at opposite
  // sides
  tank1X = width * 0.1;
  tank1Y = player1Height;
  tank2X = width * 0.9;
  tank2Y = player2Height;
}

void draw() {
  // Main draw loop. Farm out the individual tasks to other functions for
  // clarity (though it could be equivalently implemented entirely in this
  // function.)
  
  // Set the background to the picture provided
  background(bg);
  
  // run draw functions for respective elements of the game
  drawTanks();
  drawGround();
  drawProjectile();
  drawStatus();
  
  // draw projectiles at new positions and run collision detection for
  // projectiles 
  updateProjectilePositionAndCheckCollision();
}

// Draw the terrain under the tanks
void drawGround() {
  /* TO IMPLEMENT IN STEP 1 */
  strokeWeight(5);
  // Draw ground using a single custom shape using vertex functions
  beginShape();
  int idx;
  // for each groundLevel array element
  for(idx = 0; idx < groundLevel.length; idx++){
    // create a vertex point at the position on the screen determined by the
    // array index position at the height of the element in the array
    vertex(idx, groundLevel[idx]);
  }
  // Apply two final vertices to fill space below generated vertices
  vertex(idx, height);
  vertex(0, height);
  
  // Colour ground
  fill(250, 236, 157);
  endShape();
  
  // Set future shapes to not have a border
  noStroke();
  // create layered ground with different colour and dimensions for aesthetic
  // effect
  // Logic is essentially the same as above
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
  // Ground should be drawn in a dark grey

}

// Draw the two tanks (including cannons)
void drawTanks() {
  /* TO IMPLEMENT IN STEP 1 */
  
  // Draw the two tanks as semicircles using the positions and sizes at the top
  // of the file
  // Tanks should be different colours
  // Also be sure to draw the cannons, using the angles given at the top of the
  // file
  
  // Draw tank 1
  
  // Set size of border to 10 pixels
  strokeWeight(10);
  
  // set variable for placing tank 1 cannon at the centre of the tank
  tank1CannonX1 = tank1X;
  // set variable for placing the tip of the cannon at the angle and length
  // specified
  tank1CannonX2 = tank1X + (cannonLength * cos(tank1CannonAngle));
  // similar to above...
  tank1CannonY1 = tank1Y;
  tank1CannonY2 = tank1Y - (cannonLength * sin(tank1CannonAngle));
  
  // draw tank cannon at position specified
  line(tank1CannonX1, tank1CannonY1, tank1CannonX2, tank1CannonY2);
  // Make cannon square
  strokeCap(SQUARE);
  
  // Set global border size to 5 pixels
  strokeWeight(5);
  fill(255, 0, 0);
  // draw 1 tank body
  // arc was replaced with ellipse to account for more detailed varying ground
  // level
  ellipse(tank1X, tank1Y, tankDiameter, tankDiameter);
  
  // Draw tank 2
  // Exactly the same as tank 1
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
  // Don't draw anything if there's no projectile in motion and the projectile
  // isn't exploding
  if(!projectileInMotion && !contactMade)  
    return;
  // if projectile has exploded enough then stop
  else if(contactMade && projectileSize > 32) {
    // Set projectile state so that it no longer expands
    contactMade = false;
    // toggle to next player's turn
    nextPlayersTurn();
  }
  // Save the current global stroke colour
  // (Hacky workaround due to everything being in the global namespace)
  int strokeColourVar = g.strokeColor;
  noStroke();
  // Set projectile colour to yellow
  fill(255, 255, 0);
  // Set the position and size of projectile
  ellipse(projectilePositionX, projectilePositionY, projectileSize, projectileSize);
  // Recover previously set stroke colour
  stroke(strokeColourVar);
}

// Draw the status text on the top of the screen
void drawStatus() {
  // Temporarily save global variables locally
  float strokeWeightVar = g.strokeWeight;
  int strokeColourVar = g.strokeColor;
  // Set shape border size to 2 pixels
  strokeWeight(2);
  // Set stroke colour RGB 
  stroke(230, 249, 211);
  // Set shape fill colour RGB
  fill(201, 246, 203);
  // Draw a background rectangular box to separate information bar from
  // background
  rect(0, 0, width, 45);
  // reset global values to their originals, avoiding unexpected behaviour in
  // other functions
  strokeWeight(strokeWeightVar);
  stroke(strokeColourVar);
  
  // Set text size and alignment parameters for info bar
  textSize(24);
  textAlign(LEFT);
  fill(0);
  
  // Based on current state of game, display relevant information in
  // information bar
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
  // If projectile has finished all actions (moving and exploding)
  if(!projectileInMotion && !contactMade) {
    projectileSize = 8;
    return;
  }
  // Check for player's turn
  // This implementation could be vastly improved by creating a generic
  // function that applies operations to either player 1 or 2 based on this
  // boolean. An object oriented approach or a way of passing variables by
  // reference to a generic function would achieve this.
  if(player1Turn) {
    /* TO IMPLEMENT IN STEP 3: UPDATE POSITION */
    
    // If the projectile is in motion...
    if(!contactMade) {
      // Tasks: increment the position according to the velocity
      // For later: the velocity according to gravity (and optionally wind)  
      projectilePositionX += tank1CannonStrength * cos(tank1CannonAngle);
      projectilePositionY += (velocity * -sin(tank1CannonAngle));
    }
    else {
      // If the projectile has collided with an object, increment it's size
      projectileSize += 1;
    }
    
    /* TO IMPLEMENT IN STEP 4: GRAVITY */
    // Update the velocity of the projectile according to the value of gravity
    // at the top of the file
    velocity -= gravity;
    
    /* TO IMPLEMENT IN STEP 5: COLLISION DETECTION */
    // Compare the location of the projectile to the ground and to the two
    // tanks
    // (Conditions ordered to avoid indexing error in final condition)
   
    // When the projectile hits the ground, it's the next player's turn
    if(round(projectilePositionX) >= width || round(projectilePositionX) <= 0) {
      // When the projectile hits something, it stops moving (change
      // projectileInMotion)
      // As projectile has finished moving and exploding, set all relevant
      // booleans to false, ready for next player's turn
      projectileInMotion = false;
      contactMade = false;
      nextPlayersTurn();

    }
    // If projectile has collided with an object but hasn't exploded...
    else if (projectilePositionY > groundLevel[round(projectilePositionX)]) {
      // Set boolean values accordingly
      projectileInMotion = false;
      contactMade = true;
    }

  }
  // Same as for player 1
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
    // Compare the location of the projectile to the ground and to the two
    // tanks
   
    // When the projectile hits the ground, it's the next player's turn
    if(projectilePositionX >= width || projectilePositionX <= 0) {
      // When the projectile hits something, it stops moving (change
      // projectileInMotion)
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
  if(dist(projectilePositionX, projectilePositionY, tank2X, tank2Y) < (tankDiameter/2.0) + (projectileSize / 2)) {
    projectileInMotion = false;
    contactMade = true;
    // If projectile shape comes into contact with player 2's tank, player 1
    // wins 
    playerHasWon = 1;
  }
  else if(dist(projectilePositionX, projectilePositionY, tank1X, tank1Y) < (tankDiameter/2.0) + (projectileSize / 2)) {
    projectileInMotion = false;
    contactMade = true;
    // Vice versa
    playerHasWon = 2;
  }
}

// Advance the turn to the next player
void nextPlayersTurn() {
  player1Turn = !player1Turn;
}

// Check angle is limited from 9 o'clock to 3 o'clock
float validateAngle(float angle) {
    if(angle > PI)
  {
    angle = PI;
  }
  else if(angle < 0)
  {
    angle = 0.0;
  }
  // return angle within limited range
  return angle;
}

// Limit strength to within reasonable values
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
  
  // Specify cases based on the key that has been pressed
  switch(key) {
    // If key is a special character
    case CODED: 
      if(player1Turn) {
        // Specify actions for up, down left and right
        switch(keyCode) {
          // Left and right increment/decrement cannon angle by 1 radian
          case LEFT: tank1CannonAngle += PI/180.0;
            break;
          case RIGHT: tank1CannonAngle -= PI/180.0;
            break;
          // Up and down increment/decrement cannon strength by 1.0
          case UP: tank1CannonStrength += 1;
            break;
          case DOWN: tank1CannonStrength -= 1;
            break;
        }
        // Ensure updated values are within preset ranges
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
      // Set boolean variables and projectile positions relative to the current
      // player's tank.
      if(player1Turn) {
        projectileInMotion = true;
        projectilePositionX = tank1CannonX2;
        projectilePositionY = tank1CannonY2;
        velocity = tank1CannonStrength;
        // Generate projectile based on global variables
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
