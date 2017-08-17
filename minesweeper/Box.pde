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
  void setFlagged(boolean value) {
    this.flagged = value;
    board.flagsInBoard += (value) ? 1 : -1;
  }
  boolean isFlagged() {
    return this.flagged;
  }
  void setBomb(boolean value){
    this.hasBomb = value;
  }
  
  boolean hasBomb() {
    return hasBomb;
  }
  
  void setHidden(boolean value) {
    this.hidden = value;
    if(!value) {
      board.hiddenBoxes--;
    }
  }
  
  boolean isHidden() {
    return hidden;
  }
  
  void setNearMines(int bombs) {
    this.nearBombs = bombs;
  }
  
  int getNearBombs() {
    return this.nearBombs;
  }
  
  int getRow() {
    return this.row;
  }
  int getColumn() {
    return this.column;
  }
  
}