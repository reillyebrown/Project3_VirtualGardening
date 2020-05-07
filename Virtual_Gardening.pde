


//*****************************************sound file
import processing.sound.*;
SoundFile sound;

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
String [] data;
int switchValue = 0;    // index from data fields
int potValue = 1;

//data[0] = "1" or "0"
//data[1] =

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;

// potentiometer values

int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems
int volumeMax = 1;
int volumeMin = 0;


//ldr values

int ldrValue = 0;
int minLDRValue = 400;
int maxLDRValue = 1700;
int minAlphaValue = 0;
int maxAlphaValue = 255;



int beeX = 0;
int beeY = 50;
//***********************************************************************************************************


//***************************************animated pngs 

AnimatedPNG flower;
AnimatedPNG musicNoteOne;
AnimatedPNG musicNoteTwo;
AnimatedPNG musicNoteThree;
AnimatedPNG musicNoteFour;
AnimatedPNG wateringCan;
AnimatedPNG bee;


//***************************************pngs
PImage sun;
PImage bg;
PImage rays;
PImage wateringcan;
PImage words;
PImage thanks;
PFont displayFont;

//***************************************timer
Timer beeTimer;


int frameNum;    // we use this for determining when to release a projectile
int frameTimeMS = 300;



void setup  () {
  size (1000, 800);  
  beeTimer = new Timer(8000);
  beeTimer.start();
    displayFont = createFont("Georgia", 32);
  
  
  //***************************************load pngs
    bg = loadImage("data/sky.png");
    sun = loadImage("data/sun.png");
    rays = loadImage("data/rays.png");
    words = loadImage("data/words.png");
    thanks = loadImage("data/thanks.png");
    wateringcan = loadImage("data/wateringcan1.png");
 //************************************ Load a soundfile from the /data folder of the sketch and play it back
  
  sound = new SoundFile(this, "Music.mp3");
  
  sound.play();
  
 //************************************ serial port  
   
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, "/dev/tty.SLAB_USBtoUART",  115200); 
  imageMode(CENTER);
  
//********************************** Load animated PNG files 
  
  flower = new AnimatedPNG(); 
  musicNoteOne = new AnimatedPNG();
  musicNoteTwo = new AnimatedPNG();
  musicNoteThree = new AnimatedPNG();
  musicNoteFour = new AnimatedPNG();
  wateringCan = new AnimatedPNG();
  bee = new AnimatedPNG();
  
  
  
  //********************************animations
  
  flower.load("data/flower", frameTimeMS); 
  musicNoteOne.load("data/musicnoteone", frameTimeMS); 
  musicNoteTwo.load("data/musicnotetwo", frameTimeMS); 
  musicNoteThree.load("data/musicnotethree", frameTimeMS); 
  musicNoteFour.load("data/musicnotefour", frameTimeMS); 
  wateringCan.load("data/wateringcan", frameTimeMS); 
  bee.load("data/bee", frameTimeMS); 
  

  
  
} 

void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string AND casts it to an integer
    inBuffer = (trim(inBuffer));
    
    //build in data parsing element 
    data = split(inBuffer, ',');
    
 
 // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 3 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      ldrValue = int(data[2]);               // third index = LDR value
  }
  }
} 

void drawSong() {

 float amp  = map(potValue, minPotValue, maxPotValue, volumeMin, volumeMax);
 sound.amp(amp);
 
  
}



void drawAnimation() {
    tint(255,255);
    flower.draw(400,400);
     
       if(ldrValue<400) {
      
        image(words,700,600);
  
      
      
       }
  }
  
  
  void drawMusicNote(){
    
    if(potValue>0){
      
     musicNoteOne.draw(200,500); 
     musicNoteTwo.draw(700,400); 
     musicNoteThree.draw(100,300); 
     musicNoteFour.draw(800,600); 
      
    } 
  }
  

void drawBg() {
  
   image(bg,500,400, 1100,1100);
  
}

void drawSun(){
  tint(255,255);
  image(sun,70,70,300,300); 
  
}

void drawWateringCan() {
  
  if( switchValue == 1 )
    wateringCan.draw(800,150); 
 
  
  else  
    
   image(wateringcan,800,150); 
   
  
} 


void drawSunRays() {
  float alphaValue = map(ldrValue, minLDRValue, maxLDRValue, minAlphaValue, maxAlphaValue);
  tint(255,alphaValue);
  image(rays, 150,150, 300, 300);
  

}

void drawTimer(){
    if( beeTimer.expired() ) {
   
    bee.draw(beeX,beeY); 
    beeX++;
    
    if (beeX == 2000) {
      beeX--;
  
    }
  }
}
  


void draw () {  


  checkSerial();
  drawBg();
  drawSun();
  drawMusicNote();
  drawSunRays();
  drawSong();
  drawAnimation();
  drawWateringCan();
  drawTimer();
  
 
}
