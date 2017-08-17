//Global variables
int scene = 0; // 0 -> menu, 1 -> game, 2 -> ???
Board board = new Board(9, 9);


void setup() {
  size(500,450);
  board.generateBombs();
  board.checkNearBombs();
}

void draw(){
  switch(scene){
    case 0:
      showMenu();
      break;
    case 1:
      showGame();
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
  fill(255,0,0);
  textSize(40);
  text("Minesweeper", 130, 150);
  fill(220);
  rect(150,200,200,80);
  fill(0);
  text("play", 200, 250);
}

void showGame() {
  board.print();
}

void showGameOver() {
  background(0);
  fill(255, 0, 0);
  text("Game Over", 150, 250);
}

void showScore() {
  background(100,100,150);
  fill(255, 255, 0);
  textSize(80);
  text("Congratz", 50,200);
  
}
void mouseClicked(){
  switch(scene){
    case 0:
      if(mouseX >= 150 && mouseX <= 350 && mouseY >= 200 && mouseY <= 280){
        scene = 1;
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