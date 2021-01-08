import processing.net.*;
Server myServer;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
boolean mt=true;
boolean ppm=false;
boolean secondClick;
boolean ykey;
int row1, col1, row2, col2, moves;

char back;
char last;
char New='p';

char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

void setup() {
  size(800, 800);
  moves=0;
  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
  
  myServer=new Server(this,1234);
}

void draw() {
  drawBoard();
  drawPieces();
  receiveMove();
  if(ppm) pawnpromotion();
  
}

void receiveMove(){
  Client myclient=myServer.available();
  if(myclient!=null){
    String incoming=myclient.readString();
    int r1=int(incoming.substring(0,1));
    int c1=int(incoming.substring(2,3));
    int r2=int(incoming.substring(4,5));
    int c2=int(incoming.substring(6,7));
    int m=int(incoming.substring(8,9));
    char neww=incoming.charAt(10);
    char bk=incoming.charAt(12);
    if(m==0){
    grid[r2][c2]=grid[r1][c1];
    grid[r1][c1]=' ';
    mt=true;
    }
    if(m==1){
      grid[r1][c1]=grid[r2][c2];
      grid[r2][c2]=bk;
      m=0;
      mt=false;
    }
    if(m==2){
      
        grid[r2][c2] =neww;
       mt = true;
       ppm=false;
    }
  }
}

void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}

void pawnpromotion(){
  fill(#5D3811);
  rect(200,200,400,400);
  fill(#FFBF5F);
  rect(215,215,370,370);
  fill(0);
  textAlign(CENTER);
  text("Place your mouse and press 'y' to choose",400,230);
  image (wrook,240,250,100,100);
  image (wbishop,425,250,100,100);
  image (wknight,240,435,100,100);
  image (wqueen,425,435,100,100);
  if (dist(mouseX,mouseY,290,300)<50){
    fill(255,85);
    ellipse(290,300,100,100);
  }
  if (dist(mouseX,mouseY,475,310)<50){
    fill(255,85);
    ellipse(475,305,100,100);
  }
  if (dist(mouseX,mouseY,290,490)<50){
    fill(255,85);
    ellipse(290,490,100,100);
  }
  if (dist(mouseX,mouseY,475,500)<50){
    fill(255,85);
    ellipse(475,490,100,100);
  }
  if (dist(mouseX,mouseY,290,300)<50 &&ppm&&ykey){
    moves=2;
    grid[row2][col2]='r';
    ppm=false;
    New='r';
    myServer.write(row1 + ","+col1+","+row2+","+col2+","+moves+","+New+","+back+",");
    moves=0;
  }
  if (dist(mouseX,mouseY,475,310)<50&&ppm&&ykey){
    moves=2;
    grid[row2][col2]='b';
    ppm=false;
    New='b';
    myServer.write(row1 + ","+col1+","+row2+","+col2+","+moves+","+New+","+back+",");
    moves=0;
  }
  if (dist(mouseX,mouseY,290,490)<50&&ppm&&ykey){
    moves=2;
    grid[row2][col2]='n';
    ppm=false;
    New='n';
    myServer.write(row1 + ","+col1+","+row2+","+col2+","+moves+","+New+","+back+",");
    moves=0;
  }
  if (dist(mouseX,mouseY,475,500)<50&&ppm&&ykey){
    moves=2;
    grid[row2][col2]='q';
    ppm=false;
    New='q';
    myServer.write(row1 + ","+col1+","+row2+","+col2+","+moves+","+New+","+back+",");
    moves=0;
  }
}


void mouseReleased() {
  if (firstClick&&mt) {
    row1 = mouseY/100;
    col1 = mouseX/100;
    firstClick = false;
    secondClick=true;
  } else {
    row2 = mouseY/100;
    col2 = mouseX/100;
    back=grid[row2][col2];
    if (secondClick==true&&mt==true&&!(row2 == row1 && col2 == col1)) {
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      myServer.write(row1 + ","+col1+","+row2+","+col2+","+moves+","+New+","+back+",");
      firstClick = true;
      mt=false;
      secondClick=false;
    }
  }
   if(grid[row2][col2]=='p'&&row2==0){
    ppm=true;
  }
}

void keyReleased(){
  if(key=='x'||key=='X'){
    grid[row1][col1]=grid[row2][col2];
      grid[row2][col2]=back;
    moves=1;
    myServer.write(row1 + ","+col1+","+row2+","+col2+","+moves+","+New+","+back+",");
    mt=true;
    moves=0;
  } 
  if(key=='y'||key=='Y'){
    ykey=true;
  }else{ykey=false;
  }
  
}
