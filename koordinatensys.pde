import java.util.Date;
import java.io.File;

PImage img;
PGraphics pg;

// Variables for Fonts
PFont pf;
PImage ci[];

// makes the size 2:1
int sizeX;
int sizeY;

// 
int scaleValue; //euclidKGT(sizeX, sizeY);
int arraySizeX;
int arraySizeY;

int positionX;
int positionY;
int arrowSize;

int[] numbersX;
int numbersXCounter;

int[] numbersY;
int numbersYCounter;

boolean showHelp;
int timer;

boolean showSaved;



void initialize() {
  // makes the size 2:1
sizeX = 2000;
sizeY = sizeX/2;

// 
scaleValue = 28; //euclidKGT(sizeX, sizeY);
arraySizeX = floor(sizeX/scaleValue);
arraySizeY = floor(sizeY/scaleValue);

positionX = sizeX/2/scaleValue-((sizeX/2/scaleValue)%scaleValue);
positionY = sizeY/2/scaleValue-((sizeY/2/scaleValue)%scaleValue);
arrowSize = 10;

numbersX = new int[arraySizeX];
numbersXCounter = floor(arraySizeX/2);

numbersY = new int[arraySizeY];
numbersYCounter = floor(arraySizeY/2);

showSaved=false;
}


void setup() {
  initialize();
  //delay(2500);
  size(sizeX, sizeY);
  pg = createGraphics(sizeX, sizeY);
  size(sizeX, sizeY);
  for (int i = 0; i<arraySizeX;i++)
    numbersX[i] = sizeX/arraySizeX*(i);
  for (int i = 0; i<arraySizeY;i++)
    numbersY[i] = sizeY/arraySizeY*(i);

  xAxisPos(-1);
  yAxisPos(-1);

  ci = new PImage[11];
  loadFonts();

  timer = second();
  showHelp = true;
}

/////////////////////////////////////////////////////////////////////////////
// Load Fonts into Program
/////////////////////////////////////////////////////////////////////////////
void loadFonts() {
  pf = loadFont("AbadiMT-CondensedExtraBold-20.vlw");
  textFont(pf, 10); 

  // load numbers from 0 - 9
  for (int k=0;k<10;k++) {
    background(255);
    stroke(0); 
    fill(0);
    textAlign(CENTER, CENTER);
    text((char)('0'+k), 8, 8);
    ci[k]=get(0, 0, 12, 12);
  }

  // load "-"
  background(255);
  stroke(0); 
  fill(0);
  textAlign(CENTER, CENTER);
  text((char)('-'), 8, 8);
  ci[10]=get(0, 0, 12, 12);
}

///////////////////////////////////////////////////////////////////////
// returns the smallest divisor of 2 from x-, y-Axis
///////////////////////////////////////////////////////////////////////
int euclidKGT(int a, int b) {
  while ( (a%2==0 || b%2==0) && min(a, b)>50) {
    a/=2;
    b/=2;
  }
  return max(a, b);
}

///////////////////////////////////////////////////////////////////////
// draws Lines on the Background
///////////////////////////////////////////////////////////////////////
void drawLines(int biggestCoord, int scaleN) {
  for (int i = 0; i<biggestCoord; i+=scaleN) {

    //except for middle position draw small grey lines
    if (i!=positionX) {
      stroke(200);
      strokeWeight(1);
    } 
    else {
      stroke(0);
      strokeWeight(2);

      //draw an arrow
      fill(0);
      beginShape(TRIANGLES);
      vertex(i-5, arrowSize);
      vertex(i+5, arrowSize);
      vertex(i, 0);
      endShape(CLOSE);
    }
    line(i, 0, i, sizeY);

    if (i<=sizeY) {
      if (i!=positionY) {
        stroke(200);
        strokeWeight(1);
      } 
      else {
        stroke(0);
        strokeWeight(2);
        fill(0);
        beginShape(TRIANGLES);
        vertex(sizeX-arrowSize, i-5);
        vertex(sizeX-arrowSize, i+5);
        vertex(sizeX, i);
        endShape(CLOSE);
      }
      line(0, i, sizeX, i);
    }


    // y-Achse
    int startingy = positionY/scaleN;
    int vary = startingy;

    for (int k=0; k<sizeX; k+=scaleN) {    

      if (abs(vary) > 9 && vary>0) {
        setImage(abs(vary), k, 0, false);
      } 
      else if (vary<0 && abs(vary) > 9) {
        setImage(abs(vary), k, 0, true);
      } 
      else if (abs(vary) <= 9 && vary>0) {
        image(ci[abs(vary)], positionX-20, k-10);
      } 
      else {
        if (vary!=0) {
          image(ci[abs(vary)], positionX-20, k-10);
          image(ci[10], positionX-27, k-10);
        }
      }
      vary--;
    }
    
    // x-Achse
    int startingx = positionX/scaleN;
    int varx = startingx;

    for (int k=0; k<sizeX; k+=scaleN) {      
      if (abs(varx) > 9 && varx>0) {
        setImage(abs(varx), k, 1, true);
      } 
      else if (varx<0 && abs(varx) > 9) {
        setImage(abs(varx), k, 1, false);
      } 
      else if (abs(varx) <= 9 && varx>0) {
        image(ci[abs(varx)], k-10, positionY+10);
        image(ci[10], k-17, positionY+10);
      } 
      else {
        if (varx!=0)
          image(ci[abs(varx)], k-10, positionY+10);
        else 
          image(ci[abs(varx)], k-20, positionY+2);
      }
      varx--;
    } 
    pg.endDraw();
    image(pg, sizeX, sizeY);
  }
}

///////////////////////////////////////////////////////////////////////
// Zeichnet Koodinatensystem
///////////////////////////////////////////////////////////////////////
void draw() {
  background(255);
  //frameRate(2);

  // check which is tallest coordinate axis
  int biggestCoord = max(sizeX, sizeY);

  // check the scale
  //int scaleN = euclidKGT(sizeX, sizeY);
  drawLines(biggestCoord, scaleValue);

  // show first help
  if (showHelp) {
    showHelp();
    if (second() > timer+5)
      showHelp = false;
  }
}

///////////////////////////////////////////////////////////////////////
// zeigt Hilfe an
///////////////////////////////////////////////////////////////////////
void showHelp() {
  if (showHelp) {
    textFont(loadTheFont()); 
    textAlign(LEFT, LEFT);
    String s = "Press \"s\" to save!\nPress \"UP\", \"DOWN\", \"LEFT\", \"RIGHT\" to change x-, and y-axis!\nPress \"h\" to show help!\nPress \"q\" to quit application!";
    text(s, 15, 15, 600, 400);
  }
}

///////////////////////////////////////////////////////////////////////
// laedt gibt Font zurueck 
///////////////////////////////////////////////////////////////////////
PFont loadTheFont() {
  return loadFont("AbadiMT-CondensedExtraBold-20.vlw");
}

///////////////////////////////////////////////////////////////////////
// stellt Zahlen, die aus mehreren Ziffern bestehen dar
// wert: Zahl;   pos: Position auf x oder y Achse;   
// koord: x- , oder y-Achse;   minus: fuegt - hinzu 
///////////////////////////////////////////////////////////////////////
void setImage(int wert, int pos, int koord, boolean minus) {
  int zehner = wert%10;
  int einer = wert/10;
  pg.beginDraw();
  // koord : gibt an ob fuer x (0) oder y-Achse (1)
  if (koord==0) {
    image(ci[zehner], positionX-20, pos-10);
    image(ci[einer], positionX-27, pos-10);
    if (minus) {
      image(ci[10], positionX-33, pos-10);
    }
  } 
  else {
    image(ci[zehner], pos-6, positionY+10);
    image(ci[einer], pos-14, positionY+10);
    if (minus) {
      image(ci[10], pos-21, positionY+10);
    }
  }
  pg.endDraw();
}

///////////////////////////////////////////////////////////////////////
// gibt an, an welcher Position x-Achse ist
///////////////////////////////////////////////////////////////////////
void xAxisPos(int direction) {
  if (direction==1)
    numbersXCounter++;
  else if (direction==0)
    numbersXCounter--;
  if (numbersXCounter >= arraySizeX) 
    numbersXCounter = 0;
  if (numbersXCounter < 0)
    numbersXCounter = arraySizeX-1;
  positionX = numbersX[numbersXCounter];
}
///////////////////////////////////////////////////////////////////////
// gibt an, an welcher Position y-Achse ist
///////////////////////////////////////////////////////////////////////
void yAxisPos(int direction) {
  if (direction==1)
    numbersYCounter++;
  else if (direction==0)
    numbersYCounter--;
  if (numbersYCounter >= arraySizeY) 
    numbersYCounter = 0;
  if (numbersYCounter < 0)
    numbersYCounter = arraySizeY-1;
  positionY = numbersY[numbersYCounter];
}

///////////////////////////////////////////////////////////////////////
// Handelt input-events
///////////////////////////////////////////////////////////////////////
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) 
      xAxisPos(1);
    else if (keyCode == LEFT) 
      xAxisPos(0);
    else if (keyCode == DOWN) 
      yAxisPos(1);
    else if (keyCode == UP) 
      yAxisPos(0);
  }

  //shows the help
  else if (key=='h' || key=='H') {
    if (!showHelp) {
      timer = second();
      showHelp = true;
    } 
    else {
      showHelp = false;
    }
  }

  // Press "s" to save top picture
  else if (key=='s' || key=='S') { 
    noLoop(); 
    /*int fn = 1;
    File file = new File(".");
    String fileName = file.getName();
    println(fileName);
    
    while(fileName == "img"+fn+".jpg")
       fn++;*/
    //String path=
    selectOutput("Select a file to write to:", "fileSelected");
    //save(path);
    loop();
    println("picture saved!");
  }
  
  // increase the scale
  else if (key=='+') {
    scaleValue++;
  }
  
  // decrease the scale
  else if (key=='-') {
    if (scaleValue>27)
      scaleValue--;
  }
  
  // quit application
  else if (key=='q' || key=='Q') {
    exit();
  }
}
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
}
  
  

 
 
