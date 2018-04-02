//http://www.wblut.com/constructs/voronoiFractal/voronoiFractal.pde
int NUMPOINTS;
int MAXORDER;
ArrayList voronoiGraphs;
ArrayList borders;
boolean DRAWING;

void setup(){
  size(800,800);
  background(255);
  smooth();
  NUMPOINTS=10;
  MAXORDER=1;
  generateBorders();
  voronoiGraphs=new ArrayList();
  Voronoi mainVoronoi=new Voronoi(NUMPOINTS,borders,0,color(120,120,120));
  VoronoiGraph mainGraph = new VoronoiGraph(mainVoronoi,MAXORDER);
  voronoiGraphs.add(mainGraph);
  divide(mainGraph);
  DRAWING=true;

}

void draw(){
  if(DRAWING){
    background(0);
    Iterator graphItr = voronoiGraphs.iterator();
    while(graphItr.hasNext()){
      ((VoronoiGraph)graphItr.next()).drawFill();
    }
    graphItr = voronoiGraphs.iterator();
    while(graphItr.hasNext()){
      ((VoronoiGraph)graphItr.next()).drawStroke();
    }
  }
  DRAWING=false;
}


void generateBorders(){
  borders = new ArrayList();

  ArrayList borderPoints = new ArrayList();
Segment2D border=new Segment2D();
 /* float a = TWO_PI/128.0f;
  for(int i=0;i<128;i++){
    Point2D borderPoint = new Point2D(width/2+width/2*cos(a*i),height/2+height/2*sin(a*i));
    borderPoints.add(borderPoint);
  }
  

  for(int i=0;i<128;i++){
    int nexti=(i==127)?0:i+1; 
    border=new Segment2D((Point2D)borderPoints.get(i),(Point2D)borderPoints.get(nexti),i);
    borders.add(border);
  }*/

  border=new Segment2D(0,0,width-1,0,0);
   borders.add(border);
   border=new Segment2D(0,height-1,0,0,1);
   borders.add(border);
   border=new Segment2D(width-1,0,width-1,height-1,2);
   borders.add(border);
   border=new Segment2D(width-1,height-1,0,height-1,3);
   borders.add(border);
}

void generateBorders(ArrayList periphery){
  borders = new ArrayList();
  for(int i=0;i<periphery.size();i++){
    Point2D pointi =(Point2D)periphery.get(i);
    int nexti=i+1;
    if(nexti>periphery.size()-1)nexti=0;
    Point2D pointj=(Point2D)periphery.get(nexti);    
    borders.add(new Segment2D(pointi,pointj));
  }
}

void divide(final VoronoiGraph voronoiGraph){
  if((voronoiGraph.order<MAXORDER)){
    Iterator polygonItr = voronoiGraph.polygons.iterator();
    while(polygonItr.hasNext()){
      Polygon currentPolygon= (Polygon) polygonItr.next();
      generateBorders(currentPolygon.points);
      Voronoi divVoronoi=new Voronoi(NUMPOINTS,borders,voronoiGraph.order+1, color(red(voronoiGraph.fillColor)+random(-20,20),green(voronoiGraph.fillColor)+random(-20,20),blue(voronoiGraph.fillColor)+random(-20,20)));
      VoronoiGraph divGraph = new VoronoiGraph(divVoronoi,MAXORDER);
      voronoiGraphs.add(divGraph);
      divide(divGraph);
    }
  }
}

void mousePressed(){
  generateBorders();
  voronoiGraphs=new ArrayList();
  colorMode(HSB,100,255,255);
  Voronoi mainVoronoi=new Voronoi(NUMPOINTS,borders,0,color(random(100),225,225));
  colorMode(RGB,255);
  VoronoiGraph mainGraph = new VoronoiGraph(mainVoronoi,MAXORDER);
  voronoiGraphs.add(mainGraph);
  divide(mainGraph);
  DRAWING=true;

}

void keyPressed(){
  save("voronoiFractal.jpg");
}