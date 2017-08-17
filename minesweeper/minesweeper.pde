//Global variables
int scene = 0; // 0 -> menu, 1 -> game, 2 -> gameover, 3 -> victory
Board board = new Board(9, 9);
PImage menuBackground;
int startTime;
int scoreTime;


void setup() {
  size(500,450);
  menuBackground = loadImage("minesweeper-500x450.jpg");
  board.generateBombs();
  board.checkNearBombs();
}

void draw(){
  switch(scene){
    case 0:
      showMenu();
      break;
    case 1:
      showGameBoard();
      scene = (board.checkVictory()) ? 3 : scene;
      break;
    case 2:
      showGameOver();
      break;
    case 3:
      showScore();
      break;
  }
}

void showMenu() {
  tint(255, 30);
  image(menuBackground, 0, 0);
  fill(255,0,0);
  textSize(50);
  text("Minesweeper", 100, 150);
  fill(220);
  rect(150,200,200,80);
  fill(0);
  textSize(40);
  text("play", 200, 250);
}

void showGameBoard() {
  //Flags left
  fill(0);
  rect(70,20,120,50);
  fill(255, 0, 0);
  textSize(40);
  text(board.bombs - board.flagsInBoard, 100,60);
  //Time
  fill(0);
  rect(310,20,120,50);
  fill(255,0,0);
  textSize(40);
  text((millis()- startTime)/1000, 320, 60);
  board.print();
}

void showGameOver() {
  background(0);
  fill(255, 0, 0);
  textSize(80);
  text("Game Over", 30, 250);
}

void showScore() {
  background(100,100,150);
  fill(255, 255, 0);
  textSize(80);
  text("Congratz", 50,200);
  textSize(40);
  text("Total Time: " + scoreTime, 100,300);
}
void mouseClicked(){
  switch(scene){
    case 0:
      if(mouseX >= 150 && mouseX <= 350 && mouseY >= 200 && mouseY <= 280){
        scene = 1;
        startTime = millis();
      }
      break;
    case 1:
      if(mouseX >= 70 && mouseX <= 430 && mouseY >= 80 && mouseY <= 440){
        int x = (mouseX - 70)/40;
        int y = (mouseY - 80)/40;
        Box box = board.getBox(y, x);
        if(mouseButton == RIGHT){
          box.setFlagged(!box.isFlagged());
          break;
        }
        box.setHidden(false);
        if(box.hasBomb()){
          scene = 2;
        }
        board.showNearBoxes(box);
      }
      break;
  }
}