class Board
{
  int columns;
  int rows;
  int bombs;
  int hiddenBoxes;
  int flagsInBoard;
  Box[][] boxes;
  
  Board(int rows, int columns) {
    this.rows = rows;
    this.columns = columns;
    this.bombs = 10;
    this.hiddenBoxes = rows*columns;
    this.boxes = new Box[rows][columns];
    this.flagsInBoard = 0;
    for(int row = 0;row < rows; row++){
      for(int column = 0; column < columns; column++){
        boxes[row][column] = new Box(row, column);
      }
    }
  }
  
  void print() {
    for(int y = 0; y < rows; y++){
      for(int x = 0; x < columns; x++){
        if(this.getBox(y, x).isFlagged()) {
          //paint box
          fill(230);
          rect(70 + x*40,80 + y*40, 40, 40);
          //Draw the flag
          fill(0);
          rect(80 + x*40,110 + y*40, 22.5, 3);
          rect(85 + x*40,107 + y*40, 12.5, 3);
          rect(89 + x*40,88 + y*40 , 2, 22);
          fill(255, 0, 0);
          triangle(80 + x*40,95 + y*40, 91 + x*40, 100 + y*40, 91 + x*40, 85 + y*40);
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
  
  void generateBombs() {
    for(int i = 0; i < this.bombs; i++){
      int column = int(random(columns));
      int row = int(random(rows));
      Box box = this.getBox(row, column);
      if(box.hasBomb()){
        i--;
        continue;
      }
      box.setBomb(true);
    }
  }
  
  Box getBox(int row, int column){
    return boxes[row][column];
  }
  
  void checkNearBombs() {
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
  
  int minesAt(int y, int x) {
    if(x >= 0 && x < columns && y >= 0 && y < rows && this.getBox(y, x).hasBomb()){
      return 1;
    }
    return 0;
  }
  int nearBombsAt(int y, int x) {
    if(x >= 0 && x < columns && y >= 0 && y < rows){
      return this.getBox(y, x).getNearBombs();
    }
    return -1;
  }
  
  boolean checkVictory() {
    if(this.hiddenBoxes == this.bombs) {
      scoreTime = (millis() - startTime)/1000;
      return true;
    }
    return false;
  }
  
  boolean boxInBoard(int y, int x) {
    if(x >= 0 && x < columns && y >= 0 && y < rows){
      return true;
    }
    return false;
  }
  void showNearBoxes(Box box) {
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
          if(!w.hasBomb() && w.isHidden()){
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