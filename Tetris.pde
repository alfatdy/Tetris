import processing.sound.SoundFile; //<>//
import ddf.minim.*;

static final int BOARD_SIZE_Y = 20, BOARD_SIZE_X = 10, TILE_SIZE = 35 ;
static final color BG = (0), RED = (#FF0A0A), GREEN = (#50FF50), BLUE = (#4040FF), 
                             YELLOW = (#EEEE22), ORANGE = (#FFA010), PURPLE = (#CC3399), 
                             MIDORI = (#66FFFF), PINK = (#880000);

int[][] board;
color[][] colors;
Board theBoard;
Piece thePiece;
GM gm;

SoundFile music;
Minim minim;
AudioSample rotate, move, row, land;
AudioPlayer theme;
AudioPlayer pause;

int timer = 400;
int score = 0;

float topHeight = height * 2;
float bottomHeight = height * 4.3;

PImage img;
PImage imgBoard;
boolean stateGame=true,buttonIsPressed;


void setup(){
 size(650,700);
 img = loadImage("background.PNG");
 imgBoard = loadImage("board.PNG");
 image(img, 0, 0);
}

void draw() {
  if (buttonIsPressed) {
    image(imgBoard,0,0);
    // Do these things if the game is still running
    if (gm.game) {
      if (!gm.paused) {
        gm.timer = gm.autoDrop(thePiece);
      }
      thePiece.display();
    }
    gm.display();
    theBoard.display();
  } else {
    startScreenDisplay();
  }
}


void initGame() {
  // Set up the board and piece
  board = new int[BOARD_SIZE_X][BOARD_SIZE_Y];
  colors = new color[BOARD_SIZE_X][BOARD_SIZE_Y];
  int[][] placeHolderPiece = new int[][]{{4, 0}, {3, 0}, {5, 0}, {4, 1}};

  // Set up the sounds and music
  minim = new Minim(this);
  rotate = minim.loadSample("rotate.wav");
  move = minim.loadSample("move.wav");
  row = minim.loadSample("row.wav");
  land = minim.loadSample("land.wav");
  theme = minim.loadFile("themeA.mp3", 2048);
  AudioOutput out = minim.getLineOut();
  out.setGain(0.1);
  theme.loop();
  theme.play();

  // Create the board and piece
  theBoard = new Board(board, colors);
  thePiece = new Piece(placeHolderPiece, GREEN, theBoard);
  gm = new GM(0);

  // Initialize the timer here
  gm.timer = millis() + gm.interval;
}

//Function to display game initial screen
void startScreenDisplay(){
    image(img,0,0);
    fill(255);
    buttonDisplay(width/2,height/2-40);
    textSize(80);
    textAlign(CENTER);
    //Tetris logo
    pushStyle();
    fill(#72E3A6);
    text("T",width/2-100,250);
    fill(#D072E3);
    text("E",width/2-60,250);
    fill(#728BE3);
    text("T",width/2-20,250);
    fill(#E3DA72);
    text("R",width/2+20,250);
    fill(#E39E72);
    text("I",width/2+55,250);
    fill(#E38372);
    text("S",width/2+85,250);
}

void keyPressed(){
 if (gm.game){
   thePiece.setMove(keyCode, true);
   //Pause/unpause the game when enter is pressed.
   if (keyCode == ENTER){
    gm.paused = !gm.paused;
    gm.timer = millis() + gm.interval;
   }
 //Reset the game if the game has been lost and the player presses enter
 }else{
  if (keyCode == ENTER){
   gm.reset();
  }
 }
}

void keyReleased(){
 thePiece.setMove(keyCode, false); 
}

//Function to display the button and know if it is pressed
void buttonDisplay(int x,int y){
    pushStyle();
    fill(#81ED92);
    rect(x-60,y-20,100,40,7);
    popStyle();
    textSize(24);
    textAlign(CENTER);
    text("Play",x-10,y+10);
    if(mousePressed & (mouseX >= (x-60)) & (mouseX<=(x-60+100) & (mouseY>=(y-20)) & (mouseY<=(y-20+40)))){
        buttonIsPressed = true;
        initGame();
    }else{
        buttonIsPressed = false;
    }
}
