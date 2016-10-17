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
float cannonLength = 20;  // How long the cannon on each tank extends
float gravity = 0.05;      // Strength of gravity

// Current state of the game

int playerHasWon = 0; // 1 if player 1 wins, 2 if player 2 wins, 0 if game in progress
boolean player1Turn = true;  // true if it's player 1's turn; false otherwise
float tank1CannonAngle = PI/2, tank2CannonAngle = PI/2; // Direction the tank cannons are pointing
float tank1CannonStrength = 3, tank2CannonStrength = 3; // Strength of intended projectile launch

// Location of the projectile

boolean projectileInMotion = false;
float projectilePositionX, projectilePositionY;
float projectileVelocityX, projectileVelocityY;

void setup() {
  size(960, 480);  // Set the screen size
  
  // Initialize the ground level
  groundLevel = new float[width];
  float player1Height = random(height/2, height-5);
  float player2Height = random(height/2, height-5);
  for(float i = 0; i < width * 0.2; i++) {
    groundLevel[(int)i] = player1Height;
  }
  for(float i = width * 0.2; i < width * 0.8; i++) {
    groundLevel[(int)i] = player1Height + (player2Height - player1Height) * (i - width*0.2)/(width*0.6);
  }
  for(float i = width * 0.8; i < width; i++) {
    groundLevel[(int)i] = player2Height;    
  }
  
  // Set the location of the two tanks so they rest on the ground at opposite sides
  tank1X = width * 0.1;
  tank1Y = player1Height;
  tank2X = width * 0.9;
  tank2Y = player2Height;
}

void draw() {
  // Main draw loop. Farm out the individual tasks to other functions
  // for clarity (though it could be equivalently implemented entirely in this function.)
  
  background(200);
  
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
  fill(100);
  endShape();
  
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
  line(tank1X, tank1Y, tank1X + (cannonLength * cos(tank1CannonAngle)), tank1Y - (cannonLength * sin(tank1CannonAngle)));
  strokeWeight(5);
  fill(0, 0, 255);
  arc(tank1X, tank1Y, tankDiameter, tankDiameter, PI, 2*PI);
  
    // Draw tank 2
  fill(255, 0, 0);
  arc(tank2X, tank2Y, tankDiameter, tankDiameter, PI, 2*PI);
  

  
}

// Draw the projectile, if one is currently in motion
void drawProjectile() {
  if(!projectileInMotion)  // Don't draw anything if there's no projectile in motion
    return;
  noStroke();
  fill(255, 255, 0);
  ellipse(projectilePositionX, projectilePositionY, 8, 8);
}

// Draw the status text on the top of the screen
void drawStatus() {
  textSize(24);
  textAlign(LEFT);
  fill(0);
  
  if(playerHasWon == 1)
    text("Player 1 Wins!", 10, 30);
  else if(playerHasWon == 2)
    text("Player 2 Wins!", 10, 30);
  else if(player1Turn) { // player1Turn == true means it's player 1's turn
    text("Player 1's turn", 10, 30);
     textAlign(RIGHT);   
    text("Angle: " + tank1CannonAngle + " Strength: " + tank1CannonStrength, width - 10, 30);
  }
  else {                 // player1Turn == false
    text("Player 2's turn", 10, 30);
    textAlign(RIGHT);
    text("Angle: " + tank2CannonAngle + " Strength: " + tank2CannonStrength, width - 10, 30);
  }
}

// Move the projectile and check for a collision
void updateProjectilePositionAndCheckCollision() {
  if(!projectileInMotion)
    return;
    
  /* TO IMPLEMENT IN STEP 3: UPDATE POSITION */
  // Tasks: increment the position according to the velocity
  // For later: the velocity according to gravity (and optionally wind)    

  /* TO IMPLEMENT IN STEP 4: GRAVITY */
  // Update the velocity of the projectile according to the value of gravity at the top of the file
  
  /* TO IMPLEMENT IN STEP 5: COLLISION DETECTION */
  // Compare the location of the projectile to the ground and to the two tanks
  // When the projectile hits something, it stops moving (change projectileInMotion)
  // When the projectile hits the ground, it's the next player's turn
  // When the projectile hits a tank, the other player wins
}

// Advance the turn to the next player
void nextPlayersTurn() {
  player1Turn = !player1Turn;
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
  
  // Space bar fires the projectile. Initially in step 2, just have it switch
  // to the next player.
}