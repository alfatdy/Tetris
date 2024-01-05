class Piece{
  
 int[][] pos;
 color col;
 Board board;
 
 boolean isLeft, isRight, isDown, isRotate;
 
 Piece(int[][] pos_, color col_, Board board_){
  pos = pos_;
  col = col_;
  board = board_;
 }
 
 //Display the piece at its current position
 void display(){
  fill(col);
  for (int x = 0; x < pos.length; x++){
    int posX = pos[x][0];
    int posY = pos[x][1];
    rect(posX*TILE_SIZE, posY*TILE_SIZE, TILE_SIZE, TILE_SIZE);
  }
 }
 
 //k is the keycode sent to the function. b is the boolean value we're going to set the equivelant boolean to.
 boolean setMove(int k, boolean b){
   
   //Create a value of 1 or 0 depending on if k is pressed or not.
   switch(k){
    case 'A':
    case LEFT:
      isLeft = b;
      break;
    case 'D':
    case RIGHT:
      isRight = b;
      break;
    case 'S':
    case DOWN:
      isDown = b;
      break;
    case UP:
    case 'W':
    case ' '://Space
      isRotate = b;
      break;
   }
   //t tells the function whether or not to perform a move based on this. It's false when a key is released, rather than pressed.
   if (b){
     move();
   }
   return b;
   
 }
 
 //Move the piece according to input
 void move(){
   //Drop the piece 1 tile
   if (isDown){
    drop();
   }
   
   //Change the position of the piece horizontally
   if (isLeft || isRight){
     if (ghost(pos, int(isRight) - int(isLeft), 0)){
       move.trigger();
       pos = shift(pos, int(isRight) - int(isLeft), 0);
     }
   }
   //Rotate the piece clockwise
   if(isRotate){
    pos = rotatePiece(); 
   }
 }
 
 //Move the entire piece.
 int[][] shift(int[][] arr, int x, int y){
  for (int i = 0;  i < arr.length; i++){
    arr[i][0] += x;
    arr[i][1] += y;
  }
  return arr;
 }
 
 //If you can, drop the piece 1 tile
 void drop(){
  if (ghost(pos, 0, 1)){
    pos = shift(pos, 0, 1);
  }else{
    gm.makeNewPiece(this, board);
    return;
  }
 }
 
 //Rotate the piece clockwise.
 int[][] rotatePiece(){
   int[][] rotPos = convert();
   //Rotates the piece by swapping x and y and reversing the sign of x
   //Then it adds the origin point to the rotation
   for (int x = 1; x < rotPos.length; x++){
    int temp = rotPos[x][0];
    rotPos[x][0] = (rotPos[x][1] * -1) + pos[0][0];
    rotPos[x][1] = temp + pos[0][1];
   }
   
   //Check if the move is valid.
   if (ghost(rotPos, 0, 0)){
     rotate.trigger();
     return rotPos;
   }else{
    return pos; 
   }
 }
 
 //Turn the actual coordinates into relative coordinates, for use with rotation.
 int[][] convert(){
   int[][]arr = new int[pos.length][2];
   arr[0] = pos[0];
   for (int x = 1; x < pos.length; x++){
     int posX = pos[x][0] - pos[0][0];
     int posY = pos[x][1] - pos[0][1];
     arr[x] = new int[]{posX, posY};
   }
   return arr;
 }
 
 
 //This tests to see if a move is valid by "ghosting" the move ahead of time, so an error isn't made.
 boolean ghost(int[][] pos, int x, int y){
   
  //Copy the array to the new ghost array, and add the movement with it
  int[][] ghost = new int[pos.length][2];
  for (int i = 0; i < pos.length; i++){
   ghost[i][0] = pos[i][0]+x;
   ghost[i][1] = pos[i][1]+y;
  }
  
  //See if it fails any boundary checks
  //These include out of bounds left and right, below the screen, and inside a piece
  //If any of these fail or it causes an error, don't perform the move.
  for (int i = 0; i < ghost.length; i++){
    try{
      if (ghost[i][0] < 0 || ghost[i][0] >= BOARD_SIZE_X || ghost[i][1] >= BOARD_SIZE_Y || board.board[ghost[i][0]][ghost[i][1]] != 0){
       return false; 
      }
    }catch(ArrayIndexOutOfBoundsException e){
      return false;
    }
  }
  //OK the move if there are no errors.
  return true;
  
 }
 
}
