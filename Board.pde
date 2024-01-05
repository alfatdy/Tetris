//------------The Board Class
class Board{
 int[][] board;
 color[][] colors;
 
 Board(int[][] board_, color[][] colors_){
   board = board_;
   colors = colors_;
 }
 
 //Display the blocks on the board.
 void display(){
   //Loop through the board and draw a tile where the board data says there is a piece.
   for (int x = 0; x < board.length; x++){
     for (int y = 0; y < board[x].length; y++){
       if (board[x][y] != 0){
         fill(colors[x][y]);
         rect(x*TILE_SIZE, y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
       }
     }
   }
 }
 
 //Add the current piece to the board.
 void addPiece(Piece piece){
   for (int x = 0; x < piece.pos.length; x++){
     int xPos = piece.pos[x][0];
     int yPos = piece.pos[x][1];
     board[xPos][yPos] = 1;
     colors[xPos][yPos] = piece.col;
   }
 }
 
 //This function will see if a whole line has been used and clear the line, then collapse the ones above it.
 void checkRow(){
  int rowsThisTurn = 0;
  //Look through the whole board and see if the row has any empty squares
  for (int x = 0; x < board[0].length; x++){
    boolean fullRow = true;
    
   for (int y = 0; y < board.length; y++){
    if (board[y][x] == 0){
     fullRow = false;
     break;
    }
   }
   
   //If there are no empty squares
   if (fullRow){
     rowsThisTurn++;
     gm.rows++;
     gm.score += BOARD_SIZE_X * (rowsThisTurn * 1.5);
     row.trigger();
     
     //Clear the line
     for (int y = 0; y < board.length; y++){
      board[y][x] = 0;
      colors[y][x] = (0);
     }
     
     //Move all of the lines above it down 1 tile
     for (int x2 = 0; x2 < board.length; x2++){
      for (int y = x-1; y >=0 ; y--){
        //If the current tile has a blank tile under it, move it down
        if (board[x2][y] == 1 && board[x2][y+1] == 0){
         board[x2][y] = 0;
         color temp = colors[x2][y];
         colors[x2][y] = (0);
         
         board[x2][y+1] = 1;
         colors[x2][y+1] = temp;
        }
        
      }
     }
     
    }
    
   }
 }//End of checkRow()
 
 void empty(){
   for (int x = 0; x < board.length; x++){
    for (int y = 0; y < board[x].length; y++){
     board[x][y] = 0;
     colors[x][y] = (0);
    }
   }
 }
 
}

class GM{
 int score;
 int rows;
 int level;
 int interval;
 int timer;
 boolean game;
 boolean paused;
 
 int nextPiece;
 int[][] piecePreview;
 color nextPieceCol;
 
 GM(int level_){
   score = 0;
   rows = 0;
   level = level_;
   interval = 600 - (level * 50);
   game = true;
   paused = false;
   
   nextPiece = int(random(0,7));
   piecePreview = new int[][]{{4, 1}, {2, 1}, {3, 1}, {5, 1}};
   nextPieceCol = BLUE;
 }
 
void display(){
  // Warna untuk bagian atas
  fill(#4B4FB2);
  rect(BOARD_SIZE_X * TILE_SIZE, 0, width, topHeight);
  
  // Warna untuk bagian tengah
  fill(#4BB288);
  rect(BOARD_SIZE_X * TILE_SIZE, topHeight, width, bottomHeight - topHeight);
  
  // Warna untuk bagian bawah
  fill(#B24BB0);
  rect(BOARD_SIZE_X * TILE_SIZE, bottomHeight, width, height - bottomHeight);
  
  textSize(width/25);
  fill(255);
  
  textAlign(LEFT);
  text("Score: " + score, BOARD_SIZE_X * TILE_SIZE + 15, 60);
  text("Rows: " + rows, BOARD_SIZE_X * TILE_SIZE + 15, 100);
  
  if (!game){
    text("Game over!\nEnter untuk Mengulangi", BOARD_SIZE_X * TILE_SIZE + 15, 250);
  }
  if (paused){
    text("Game Paused.\nEnter untuk Melanjutkan.", BOARD_SIZE_X * TILE_SIZE + 15, 250);
  }
  
  // Display Next Piece Preview
  int previewSize = int(TILE_SIZE);
  text("Next", BOARD_SIZE_X * TILE_SIZE + 15, 480);
  for (int i = 0; i < piecePreview.length; i++){
    fill(nextPieceCol);
    rect(width - 45 - piecePreview[i][0] * previewSize, height - 150 - piecePreview[i][1] * previewSize, previewSize, previewSize);
  }
}


 
 //Automatically drop the piece once the interval is exceeded
int autoDrop(Piece piece){
  if (millis() > timer){
   piece.drop();
   if (rows > (level + 1) * 15){
    level++;
    interval = 600 - (level * 50);
   }
   return timer + interval;
  }
  return timer;
}

void lose(){
  game = false;
  //music.stop();
}

//Make a new piece and put it at the top
void makeNewPiece(Piece piece, Board board){
  //Add the current piece to the board
  board.addPiece(piece);
  //Increase the score and play the landing sound
  gm.score += piece.pos.length;
  land.trigger();
  
  //Set the piece to the one stored from last time
  piece.col = nextPieceCol;
  piece.pos = piecePreview;
  
  int seed = int(random(0,7));
  //Create a new random piece and store it
  switch (nextPiece){
  case 0:
   nextPieceCol = BLUE;
   piecePreview = new int[][]{{3, 0}, {2, 0}, {4, 0}, {5, 0}};
   break;
  case 1:
   nextPieceCol = GREEN;
   piecePreview = new int[][]{{4, 0}, {3, 0}, {5, 0}, {4, 1}};
   break;
  case 2:
   nextPieceCol = YELLOW;
   piecePreview = new int[][]{{4,0}, {3, 0}, {5, 0}, {5, 1}};
   break;
  case 3:
   nextPieceCol = ORANGE;
   piecePreview = new int[][]{{4,0}, {3, 0}, {5, 0}, {3, 1}};
   break;
  case 4:
   nextPieceCol = PURPLE;
   piecePreview = new int[][]{{4, 0}, {5, 0}, {4, 1}, {5, 1}};
   break;
  case 5:
   nextPieceCol = RED;
   piecePreview = new int[][]{{4, 0}, {3, 0}, {4, 1}, {5, 1}};
   break;
  default:
   nextPieceCol = MIDORI;
   piecePreview = new int[][]{{4, 0}, {5, 0}, {3, 1}, {4, 1}};
  }
  
  if (board.board[piece.pos[0][0]][piece.pos[0][1]] != 0){
    lose();
  }
  nextPiece = seed;
  
  //See if any rows have been filled
  board.checkRow();
}

void reset(){
  level = 0;
  interval = 600 - (level * 50);
  rows = 0;
  score = 0;
  //music.loop();
  theBoard.empty();
  timer = millis() + interval;
  game = true;
}

 
}
