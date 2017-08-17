import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class minesweeper extends PApplet {

//Global variables
int scene = 0; // 0 -> menu, 1 -> game, 2 -> ???
Board board = new Board(9, 9);


public void setup() {
  
  board.generateBombs();
  board.checkNearBombs();
}

public void draw(){
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

public void showMenu() {
  fill(255,0,0);
  textSize(40);
  text("Minesweeper", 130, 150);
  fill(220);
  rect(150,200,200,80);
  fill(0);
  text("play", 200, 250);
}

public void showGame() {
  board.print();
}

public void showGameOver() {
  background(0);
  fill(255, 0, 0);
  text("Game Over", 150, 250);
}

public void showScore() {
  background(100,100,150);
  fill(255, 255, 0);
  textSize(80);
  text("Congratz", 50,200);
  
}
public void mouseClicked(){
  switch(scene){
    case 0:
      if(mouseX >= 150 && mouseX <= 350 && mouseY >= 200 && mouseY <= 280){
        println("game " + mouseX);
        scene = 1;
      }
      break;
    case 1:
      if(mouseX >= 70 && mouseX <= 430 && mouseY >= 80 && mouseY <= 440){
        int x = (mouseX - 70)/40;
        int y = (mouseY - 80)/40;
        println(x + " " + y);
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
class Board
{
  int columns;
  int rows;
  int bombs;
  int hiddenBoxes;
  Box[][] boxes;
  
  Board(int rows, int columns) {
    this.rows = rows;
    this.columns = columns;
    this.bombs = 10;
    this.hiddenBoxes = rows*columns;
    this.boxes = new Box[rows][columns];
    for(int row = 0;row < rows; row++){
      for(int column = 0; column < columns; column++){
        boxes[row][column] = new Box(row, column);
      }
    }
  }
  
  public void print() {
    for(int y = 0; y < rows; y++){
      for(int x = 0; x < columns; x++){
        if(this.getBox(y, x).isFlagged()) {
          fill(230);
          rect(70 + x*40,80 + y*40, 40, 40);
          fill(255, 0, 0);
          triangle(80 + x*40,100 + y*40, 90 + x*40, 100 + y*40, 85 + x*40, 85 + y*40);
        }
        else if(this.getBox(y, x).isHidden()){
          fill(230);
          rect(70 + x*40,80 + y*40, 40, 40);
        }
        else {
          fill(200);
          rect(70 + x*40,80 + y*40, 40, 40);
          fill(255, 0, 0);
          textSize(12);
          text(this.getBox(y, x).getNearBombs(), 90 + x*40, 100 + y*40);
        }
      }
    }
  }
  
  public void generateBombs() {
    for(int i = 0; i < this.bombs; i++){
      int column = PApplet.parseInt(random(columns));
      int row = PApplet.parseInt(random(rows));
      Box box = this.getBox(row, column);
      if(box.hasBomb()){
        i--;
        continue;
      }
      box.setBomb(true);
    }
  }
  
  public Box getBox(int row, int column){
    return boxes[row][column];
  }
  
  public void checkNearBombs() {
    int mines;
    for(int y = 0; y < this.rows; y++){
      for(int x = 0; x < this.columns; x++){
        mines = 0;
        mines += this.minesAt(y-1, x-1); // NW
        mines += this.minesAt(y-1, x); // N
        mines += this.minesAt(y-1, x+1); // NE
        mines += this.minesAt(y, x-1); // W
        mines += this.minesAt(y, x+1); // E
        mines += this.minesAt(y+1, x-1); // SW
        mines += this.minesAt(y+1, x); // S
        mines += this.minesAt(y+1, x+1); // SE
        this.getBox(y, x).setNearMines(mines);
      }
    }
  }
  
  public int minesAt(int y, int x) {
    if(x >= 0 && x < columns && y >= 0 && y < rows && this.getBox(y, x).hasBomb()){
      return 1;
    }
    return 0;
  }
  public int nearBombsAt(int y, int x) {
    if(x >= 0 && x < columns && y >= 0 && y < rows){
      return this.getBox(y, x).getNearBombs();
    }
    return -1;
  }
  
  public boolean checkVictory() {
    if(this.hiddenBoxes == this.bombs) {
      return true;
    }
    return false;
  }
  
  public boolean boxInBoard(int y, int x) {
    if(x >= 0 && x < columns && y >= 0 && y < rows){
      return true;
    }
    return false;
  }
  public void showNearBoxes(Box box) {
    ArrayList<Box> boxList = new ArrayList<Box>();
    boxList.add(box);
    int row, column;
    while(!boxList.isEmpty()) {
      Box head = boxList.get(0);
      boxList.remove(0);

      row = head.getRow();
      column = head.getColumn();
      if(head.getNearBombs() == 0){
        // NW
        if(this.boxInBoard(row-1, column-1)) {
          Box nw = this.getBox(row-1, column-1);
          if(!nw.hasBomb() && nw.isHidden()){  
            nw.setHidden(false);
            if(nw.getNearBombs() == 0){
              boxList.add(nw);
            }
          }
        }
        // N
        if(this.boxInBoard(row-1, column)) {
          Box n = this.getBox(row-1, column);
          if(!n.hasBomb() && n.isHidden()){ 
            n.setHidden(false);
            if(n.getNearBombs() == 0){
              boxList.add(n);
            }
          }
        }
        //NE
        if(this.boxInBoard(row-1, column+1)) {
          Box ne = this.getBox(row-1, column+1);
          if(!ne.hasBomb()  && ne.isHidden()){ 
            ne.setHidden(false);
            if(ne.getNearBombs() == 0){
              boxList.add(ne);
            }
          }
        }
        //W
        if(this.boxInBoard(row, column-1)) {
          Box w = this.getBox(row, column-1);
          if(w.hasBomb() &&w.isHidden()){ 
            w.setHidden(false);
            if(w.getNearBombs() == 0){
              boxList.add(w);
            }
          }
        }
        //E
        if(this.boxInBoard(row, column+1)) {
          Box e = this.getBox(row, column+1);
          if(!e.hasBomb() && e.isHidden()){ 
            e.setHidden(false);
            if(e.getNearBombs() == 0){
              boxList.add(e);
            }
          }
        }
        //SW
        if(this.boxInBoard(row+1, column-1)) {
          Box sw = this.getBox(row+1, column-1);
          if(!sw.hasBomb() && sw.isHidden()){ 
            sw.setHidden(false);
            if(sw.getNearBombs() == 0){
              boxList.add(sw);
            }
          }
        }
        //S
        if(this.boxInBoard(row+1, column)) {
          Box s = this.getBox(row+1, column);
          if(!s.hasBomb() && s.isHidden()){ 
            s.setHidden(false);
            if(s.getNearBombs() == 0){
              boxList.add(s);
            }
          }
        }
        //SE
        if(this.boxInBoard(row+1, column+1)) {
          Box se = this.getBox(row+1, column+1);
          if(!se.hasBomb() && se.isHidden()){ 
            se.setHidden(false);
            if(se.getNearBombs() == 0){
              boxList.add(se);
            }
          }
        }
      }
    }
  }
}
class Box
{
  int row;
  int column;
  int nearBombs;
  boolean hasBomb;
  boolean hidden;
  boolean flagged;
  
  Box (int row, int column) {
    this.row = row;
    this.column = column;
    this.nearBombs = 0;
    this.hasBomb = false;
    this.hidden = true;
    this.flagged = false;
  }
  Box (int row, int column, int nearBombs, boolean hasBomb, boolean hidden) {
    this.row = row;
    this.column = column;
    this.nearBombs = nearBombs;
    this.hasBomb = hasBomb;
    this.hidden = hidden;
    this.flagged= false;
  }
  public void setFlagged(boolean value) {
    this.flagged = value;
    println(value);
  }
  public boolean isFlagged() {
    return this.flagged;
  }
  public void setBomb(boolean value){
    this.hasBomb = value;
  }
  
  public boolean hasBomb() {
    return hasBomb;
  }
  
  public void setHidden(boolean value) {
    this.hidden = value;
    if(!value) {
      board.hiddenBoxes--;
    }
  }
  
  public boolean isHidden() {
    return hidden;
  }
  
  public void setNearMines(int bombs) {
    this.nearBombs = bombs;
  }
  
  public int getNearBombs() {
    return this.nearBombs;
  }
  
  public int getRow() {
    return this.row;
  }
  public int getColumn() {
    return this.column;
  }
  
}
  public void settings() {  size(500,450); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "minesweeper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
