double[] offset = {0,0};
double zoom = 0.005;

int maxIterations=50;

void setup(){
  size(720,480);
}
double[] screenToWorld(double sposX,double sposY){
  double wposX=(sposX+offset[0])*zoom;
  double wposY=(sposY+offset[1])*zoom;
  double[] list={wposX,wposY};
  return list;
}
void draw(){
  loadPixels();
  for (int y=0;y<height;y++){
    for (int x=0;x<width;x++){
      double[] worldPos=screenToWorld(x,y);

      double a=worldPos[0];
      double b=worldPos[1];

      double ca=a;
      double cb=b;

      int n=0;

      while (n<maxIterations){
        double aa=a*a-b*b;
        double bb=2*a*b;
        a=aa+ca;
        b=bb+cb;
        if (abs((float)(a+b))>16){
          break;
        }
        n++;
      }

      pixels[y*width+x]=color(map(n,0,maxIterations,0,255));
    }
  }
  updatePixels();

  // display current pan/zoom
  fill(0,200);
  noStroke();
  rect(0,0,width,65);
  fill(255);
  textSize(15);
  textAlign(LEFT,TOP);
  text("Camera : x="+offset[0]+" y="+offset[1]+" zoom="+zoom,0,0);

  double[] mousePos=screenToWorld(mouseX,mouseY);
  text("Mouse : x="+mousePos[0]+" y="+mousePos[1],0,15);
  text("FPS :"+frameRate,0,30);
  text("Fractal maximum Iterations (detail level) :"+maxIterations,0,45);

  if (keyPressed){
    if (keyCode==UP){
      maxIterations+=int(60/frameRate);
    }else if (keyCode==DOWN){
      maxIterations-=int(60/frameRate);
    }
    maxIterations=constrain(maxIterations,1,1000);
  }
}

void mouseDragged(){
  // panning

  double[] ppan=screenToWorld(pmouseX,pmouseY);
  double[] pan=screenToWorld(mouseX,mouseY);

  offset[0]+=(ppan[0]-pan[0])/zoom;
  offset[1]+=(ppan[1]-pan[1])/zoom;

}

void mouseWheel(MouseEvent event) {
  double[] beforeZoom=screenToWorld(mouseX,mouseY);
  float e = map(event.getCount(),-1,1,0.9,1.1);
  zoom*=e;
  double[] AfterZoom=screenToWorld(mouseX,mouseY);
  offset[0]+=(beforeZoom[0]-AfterZoom[0])/zoom;
  offset[1]+=(beforeZoom[1]-AfterZoom[1])/zoom;
}
